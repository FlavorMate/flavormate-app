import 'package:flavormate/models/recipe/unit_ref/unit_localized.dart';
import 'package:flavormate/riverpod/api/p_api.dart';
import 'package:flavormate/utils/u_localizations.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'p_units.g.dart';

@riverpod
class PUnits extends _$PUnits {
  @override
  Future<List<UnitLocalized>> build() async {
    final units = (await ref.watch(pApiProvider).unitsClient.findAll())
        .where((unit) => unit.language == currentLocalization().languageCode)
        .toList();

    ref.keepAlive();

    return units;
  }
}
