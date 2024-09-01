import 'package:json_annotation/json_annotation.dart';

part 'login.g.dart';

@JsonSerializable()
class Login {
  final String username;
  final String password;

  Login({required this.username, required this.password});

  /// Connect the generated [_$LoginFromJson] function to the `fromJson`
  /// factory.
  factory Login.fromJson(Map<String, dynamic> json) => _$LoginFromJson(json);

  /// Connect the generated [_$LoginToJson] function to the `toJson` method.
  Map<String, dynamic> toJson() => _$LoginToJson(this);
}
