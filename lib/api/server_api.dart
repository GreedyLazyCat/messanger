import 'dart:convert';

import 'package:http/http.dart' as http;

Future<http.Response> pingServer(Uri serverUri) {
  return http.get(serverUri);
}

Future<http.Response> getAuthToken(
    Uri serverUri, String login, String password) async {
  return http.post(serverUri,
      body: jsonEncode({'login': login, 'password': password}));
}

Future<http.Response> signUp(Uri serverUri, String login, String password) {
  return http.post(serverUri,
      body: jsonEncode({'login': login, 'password': password}));
}
