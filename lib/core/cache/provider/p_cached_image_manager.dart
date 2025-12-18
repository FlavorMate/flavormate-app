import 'dart:io';

import 'package:flavormate/core/cache/daos/cached_image_dao.dart';
import 'package:flavormate/core/extensions/e_object.dart';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sembast/sembast_io.dart';
import 'package:path/path.dart';
import 'package:sembast/timestamp.dart';

part 'p_cached_image_manager.g.dart';

@Riverpod(keepAlive: true)
class PCachedImageManager extends _$PCachedImageManager {
  final cacheName = 'de.flavormate.image_cache';
  late final Directory _filePath;

  StoreRef<String, Map<String, Object?>> get _store =>
      stringMapStoreFactory.store(cacheName);

  @override
  Future<Database?> build() async {
    // Web doesn't support disk storage, so ignore
    if (kIsWeb) return null;

    // get the application documents directory
    final dir = await getApplicationSupportDirectory();

    // make sure it exists
    await dir.create(recursive: true);

    // build the database path
    final dbPath = join(dir.path, '$cacheName.db');

    // get the temporary directory
    final fileDir = await getTemporaryDirectory();

    // make sure it exists
    await fileDir.create(recursive: true);

    // get the cache directory
    _filePath = Directory(join(fileDir.path, cacheName));

    // make sure it exists
    await _filePath.create(recursive: true);

    ref.onDispose(() {
      state.value?.close();
    });

    // open the database
    return await databaseFactoryIo.openDatabase(dbPath);
  }

  Future<Uint8List?> getImage(String url) async {
    final db = state.value;
    if (db == null) return null;

    final image = await db.transaction((txn) async {
      final record = await _store.record(url).get(txn);
      return record?.let(CachedImageDao.fromDB);
    });

    if (image == null) return null;

    final file = File(join(_filePath.path, image.fileName));

    if (file.existsSync()) {
      await db.transaction((txn) async {
        await _store.record(url).update(txn, image.updatedDates);
      });
      return await file.readAsBytes();
    } else {
      await db.transaction((txn) async {
        await _store.record(url).delete(txn);
      });
    }

    return null;
  }

  Future<void> insertImage(String url, Uint8List data) async {
    final db = state.value;
    if (db == null) return;

    final image = CachedImageDao.create(id: url);

    await db.transaction((txn) async {
      await _store.record(url).put(txn, image.toDB);
    });

    final file = File(
      join(
        _filePath.path,
        image.fileName,
      ),
    );

    await file.writeAsBytes(data);
  }

  Future<void> housekeeping() async {
    final db = state.value;
    if (db == null) return;

    await db.transaction((txn) async {
      final filter = Filter.lessThan(
        'validUntil',
        Timestamp.now(),
      );

      final count = await _store.count(txn, filter: filter);

      for (int i = 0; i < count; i += 10) {
        final finder = Finder(filter: filter, limit: 10, offset: i);
        final query = await _store.find(txn, finder: finder);
        for (final record in query) {
          final image = CachedImageDao.fromDB(record.value);

          final imageFile = File(join(_filePath.path, image.fileName));
          if (imageFile.existsSync()) {
            try {
              await imageFile.delete(recursive: true);
            } catch (_) {
              // File couldn't be deleted.
              // This can have multiple reasons, one of them is the OS deleting cache to safe disk storage.
            }
          }

          record.ref.delete(txn);
        }
      }
    });
  }

  Future<void> clear() async {
    final db = state.value;
    if (db == null) return;

    await db.dropAll();

    await _filePath.delete(recursive: true);
    await _filePath.create(recursive: true);

    // old values used in former app versions
    await _deleteCachedFiles('flavormate_cached_images');
    await _deleteCachedFiles('libCachedImageData');
    await _deleteCachedFiles('secure_images');
  }

  Future<void> _deleteCachedFiles(String key, {bool recreate = false}) async {
    final baseDir = await getTemporaryDirectory();

    final directory = Directory(join(baseDir.path, key));

    if (await directory.exists()) {
      await directory.delete(recursive: true);
      if (recreate) await directory.create(recursive: true);
    }
  }
}
