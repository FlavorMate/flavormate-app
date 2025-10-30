import 'package:flavormate/data/models/features/unit/unit_conversion_dto.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'p_rest_unit_conversions.g.dart';

const _gramId = 'a736bf0e-e8a4-4605-a173-c710bfa0a4e4';

@riverpod
class PRestUnitConversions extends _$PRestUnitConversions {
  @override
  Future<List<UnitConversionDto>> build() async {
    return [];
  }

  double? convertFromGram(String targetId) {
    return state.value
        ?.where(
          (conversion) =>
              conversion.source.id == targetId &&
              conversion.target.id == _gramId,
        )
        .firstOrNull
        ?.factor;
  }
}
