import 'package:flavormate/models/recipe/unit_ref/unit_conversion.dart';
import 'package:flavormate/models/recipe/unit_ref/unit_ref.dart';
import 'package:flavormate/riverpod/api/p_api.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'p_unit_conversions.g.dart';

@riverpod
class PUnitConversion extends _$PUnitConversion {
  @override
  Future<List<UnitConversion>> build() async {
    final response =
        await ref.watch(pApiProvider).unitsClient.getAllConversions();

    ref.keepAlive();

    return response;
  }

  double? convert(UnitRef from, UnitRef to) {
    final results =
        state.value!.where((v) => v.id.from == from && v.id.to == to);

    return results.firstOrNull?.factor;
  }

  double? convertFromGram(UnitRef to) {
    final results = state.value!
        .where((v) =>
            (v.id.from.description == 'gram' ||
                v.id.from.description == 'milliliter') &&
            v.id.to == to)
        .toList();

    return results.firstOrNull?.factor;
  }
}
