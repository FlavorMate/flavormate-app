import 'package:dart_mappable/dart_mappable.dart';
import 'package:flavormate/data/models/shared/enums/image_resolution.dart';
import 'package:flutter/material.dart';

part 'account_file_dto.mapper.dart';

@immutable
@MappableClass()
class AccountFileDto with AccountFileDtoMappable {
  final String id;
  final String path;

  const AccountFileDto({required this.id, required this.path});

  String url(ImageResolution resolution) =>
      '$path?resolution=${resolution.name}';
}
