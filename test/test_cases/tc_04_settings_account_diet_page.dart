import 'package:flavormate/data/repositories/features/accounts/p_rest_accounts_self.dart';
import 'package:flavormate/presentation/features/settings/settings_account/settings_account_diet/settings_account_diet_page.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../test_data/accounts/accounts.dart';
import 'tc.dart';

class TC04SettingsAccountDietPage extends TC {
  const TC04SettingsAccountDietPage({
    required super.locale,
    required super.assets,
  });

  @override
  List<Override> get overrides => [
    pRestAccountsSelfProvider.overrideWithBuild(
      (ref, it) => AccountFulls.a_d6fc559f_ddc1_4bc2_a9c1_c8a17ff5ffcc,
    ),
  ];

  @override
  void run() {
    screenshot(
      '4_account_diet',
      const SettingsAccountDietPage(),
    );
  }
}
