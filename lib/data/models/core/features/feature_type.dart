import 'package:dart_mappable/dart_mappable.dart';

part 'feature_type.mapper.dart';

@MappableEnum()
enum FeatureType {
  Bring,
  ImportExport,
  OpenFoodFacts,
  Recovery,
  Registration,
  Share,
  Story,
}
