import 'package:dart_mappable/dart_mappable.dart';

part 'feature_type.mapper.dart';

@MappableEnum()
enum FeatureType {
  Ratings,
  Registration,
  Recovery,
  ScraperImport,
  Story,
  Bring,
  OpenFoodFacts,
  Share,
}
