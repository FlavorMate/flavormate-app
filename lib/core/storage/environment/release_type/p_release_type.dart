import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'p_release_type.g.dart';

@riverpod
class PReleaseType extends _$PReleaseType {
  @override
  String build() {
    return const String.fromEnvironment(
      'build.stage',
      defaultValue: '-',
    );
  }
}
