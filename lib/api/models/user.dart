import 'dart:convert';

class User {
  User({required this.id, required this.login});

  final String id;
  final String login;

  String toJson() {
    return jsonEncode({'id': id, 'login': login});
  }
}
