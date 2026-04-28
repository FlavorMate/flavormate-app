import 'package:flavormate/core/cache/cache_image_provider.dart';
import 'package:flavormate/core/cache/provider/p_cached_image.dart';
import 'package:flavormate/core/extensions/e_string.dart';
import 'package:flavormate/core/storage/shared_preferences/providers/settings/p_settings_image_mode.dart';
import 'package:flavormate/data/repositories/features/accounts/p_rest_accounts_self.dart';
import 'package:flavormate/data/repositories/features/books/p_rest_books.dart';
import 'package:flavormate/presentation/features/library/library_page.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../test_data/accounts/accounts.dart';
import '../test_data/books/books.dart';
import '../test_widgets/main_test_layout.dart';
import '../utils/u_pageable.dart';
import 'tc.dart';

class TC02LibraryPage extends TC {
  const TC02LibraryPage({
    required super.locale,
    required super.assets,
  });

  @override
  List<Override> get overrides {
    final account = AccountFulls.a_d6fc559f_ddc1_4bc2_a9c1_c8a17ff5ffcc;

    final books = Books.getByOrder(
      locale,
      (a, b) => a.label.compareToIgnoreCase(b.label),
    );

    return [
      pRestAccountsSelfProvider.overrideWithBuild(
        (ref, it) => account,
      ),
      pRestBooksProvider.overrideWithBuild(
        (ref, it) => UPageableDto.fromTestData(books),
      ),
      pSettingsImageModeProvider.overrideWithValue(.Scale),
      pCachedImageProvider.overrideWithBuild(
        (ref, it) => CacheImageProvider(
          url: it.url,
          imageLoader: (url) async {
            final asset = await assets.load(url.split('?')[0]);
            return asset.buffer.asUint8List();
          },
        ),
      ),
    ];
  }

  @override
  void run() {
    screenshot(
      '2_library',
      const MainTestLayout(
        activeIndex: 1,
        child: LibraryPage(),
      ),
    );
  }
}
