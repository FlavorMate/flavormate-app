import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:glob/glob.dart';
import 'package:glob/list_local_fs.dart';

/// A custom [AssetBundle] that reads files from a directory.
///
/// This is meant to be used in place of [rootBundle] for testing
class DiskAssetBundle extends CachingAssetBundle {
  static const _assetManifestDotJson = 'AssetManifest.json';
  static const _assetManifestDotBin = 'AssetManifest.bin';

  /// Creates a [DiskAssetBundle] by loading files from [path].
  static Future<AssetBundle> loadFromPath(
    String path, {
    String? from,
  }) async {
    // Prepare the file search pattern
    path = _formatPath(path);
    String pattern = path;
    if (!pattern.endsWith('/')) {
      pattern += '/';
    }
    pattern += '**';

    // Load the assets
    final cache = <String, ByteData>{};
    await for (final entity in Glob(pattern).list(root: from)) {
      if (entity is File) {
        final bytes = await (entity as File).readAsBytes();

        // Keep only the asset name relative to the folder
        String name = _formatPath(entity.path);
        name = name.substring(name.indexOf(path) + path.length);
        cache[name] = ByteData.sublistView(bytes);
      }
    }

    // Create the asset manifests.
    final jsonManifest = <String, List<String>>{};
    final binManifest = <String, List<Map<String, Object>>>{};

    cache.forEach((key, _) {
      jsonManifest[key] = [key];
      binManifest[key] = [
        {
          'asset': key,
        },
      ];
    });

    cache[_assetManifestDotJson] = ByteData.sublistView(
      Uint8List.fromList(jsonEncode(jsonManifest).codeUnits),
    );

    cache[_assetManifestDotBin] = const StandardMessageCodec().encodeMessage(
      binManifest,
    )!;

    return DiskAssetBundle._(cache);
  }

  /// Format a file path to only forward slashes
  static String _formatPath(String path) {
    return path.replaceAll(r'\', '/');
  }

  /// The cache of assets
  final Map<String, ByteData> _cache;

  /// Private constructor
  DiskAssetBundle._(this._cache);

  /// Load an asset from the cache
  @override
  Future<ByteData> load(String key) async {
    if (!_cache.containsKey(key)) {
      throw FlutterError(
        'Asset not found in DiskAssetBundle: "$key"\n'
        'Available assets:\n${_cache.keys.join('\n')}',
      );
    }

    return _cache[key]!;
  }
}
