part of 'custom_mappers.dart';

class _UserAgentMapper extends SimpleMapper<UserAgent> {
  const _UserAgentMapper();

  @override
  UserAgent decode(dynamic value) {
    return UserAgent.parse(value);
  }

  @override
  dynamic encode(UserAgent self) {
    return self.toString();
  }
}
