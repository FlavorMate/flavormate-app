import 'package:flavormate/core/extensions/e_duration.dart';
import 'package:flavormate/core/utils/u_duration.dart';
import 'package:sembast/timestamp.dart';

class CachedImageDao {
  final String id;
  final String fileName;
  final Duration validFor;
  final Timestamp touched;
  final Timestamp validUntil;

  CachedImageDao({
    required this.id,
    required this.fileName,
    required this.validFor,
    required this.touched,
    required this.validUntil,
  });

  factory CachedImageDao.create({
    required String id,
    Duration validFor = const Duration(days: 7),
  }) {
    final uri = Uri.parse(id);

    final fileName =
        '${uri.pathSegments.last}_${uri.queryParameters['resolution']}.webp';

    final validUntil = DateTime.now().add(validFor);

    return CachedImageDao(
      id: id,
      fileName: fileName,
      validFor: validFor,
      touched: Timestamp.now(),
      validUntil: Timestamp.fromDateTime(validUntil),
    );
  }

  factory CachedImageDao.fromDB(Map<String, Object?> map) {
    return CachedImageDao(
      id: map['id'] as String,
      fileName: map['fileName'] as String,
      validFor: UDuration.toDuration(map['validFor'] as String),
      touched: map['touched'] as Timestamp,
      validUntil: map['validUntil'] as Timestamp,
    );
  }

  Map<String, Object?> get toDB {
    return {
      'id': id,
      'fileName': fileName,
      'validFor': validFor.iso8601,
      ...updatedDates,
    };
  }

  Map<String, Object?> get updatedDates {
    final validUntil = DateTime.now().add(validFor);

    return {
      'touched': Timestamp.now(),
      'validUntil': Timestamp.fromDateTime(validUntil),
    };
  }
}
