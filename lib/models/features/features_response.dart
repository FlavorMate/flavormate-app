import 'package:dart_mappable/dart_mappable.dart';

part 'features_response.mapper.dart';

@MappableClass()
class FeaturesResponse with FeaturesResponseMappable {
  final String version;
  final List<String> features;

  FeaturesResponse({
    required this.version,
    required this.features,
  });
}
