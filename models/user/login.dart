import 'dart:convert';

RegisterModel registerModelFromJson(String str) =>
    RegisterModel.fromJson(json.decode(str) as Map<String, dynamic>);

String registerModelToJson(RegisterModel data) => json.encode(data.toJson());

class RegisterModel {
  RegisterModel({
    required this.login,
    required this.password,
  });

  factory RegisterModel.fromJson(Map<String, dynamic> json) => RegisterModel(
        login: json['login'] as String,
        password: json['password'] as String,
      );

  final String login;
  final String password;

  Map<String, dynamic> toJson() => {
        'login': login,
        'password': password,
      };
}
