import 'package:dart_mappable/dart_mappable.dart';
import 'package:flavormate/data/models/core/features/feature_type.dart';

part 'features_response.mapper.dart';

@MappableClass()
class FeaturesResponse with FeaturesResponseMappable {
  final String version;
  final List<FeatureType> features;

  FeaturesResponse({required this.version, required this.features});
}
