part of 'custom_mappers.dart';

class _UriMapper extends SimpleMapper<Uri> {
  const _UriMapper();

  @override
  Uri decode(Object value) {
    return Uri.parse('$value');
  }

  @override
  String encode(Uri self) {
    return self.toString();
  }
}
