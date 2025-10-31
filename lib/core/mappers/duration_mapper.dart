part of 'custom_mappers.dart';

class _DurationMapper extends SimpleMapper<Duration> {
  @override
  Duration decode(Object value) {
    return UDuration.toDuration('$value');
  }

  @override
  String encode(Duration self) {
    return self.iso8601;
  }
}
