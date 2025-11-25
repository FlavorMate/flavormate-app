import 'package:dart_mappable/dart_mappable.dart';

part 'feature_type.mapper.dart';

@MappableEnum()
enum FeatureType {
  Bring,
  ImportExport,
  OpenFoodFacts,
  Ratings,
  Recovery,
  Registration,
  Share,
  Story,
}
