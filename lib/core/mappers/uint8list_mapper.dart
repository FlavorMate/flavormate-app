part of 'custom_mappers.dart';

class _UInt8ListMapper extends SimpleMapper<Uint8List> {
  const _UInt8ListMapper();

  @override
  Uint8List decode(dynamic value) {
    return base64Decode(value);
  }

  @override
  dynamic encode(Uint8List self) {
    return base64Encode(self);
  }
}
