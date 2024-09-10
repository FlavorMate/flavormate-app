import 'package:flavormate/models/unit.dart';
import 'package:flavormate/riverpod/api/p_api.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'p_units.g.dart';

@riverpod
class PUnits extends _$PUnits {
  @override
  Future<List<Unit>> build() async {
    final units = await ref.watch(pApiProvider).unitsClient.findAll();

    ref.keepAlive();

    return units;
  }
}
