import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:messanger/api/models/chatroom.dart';
import 'package:messanger/api/models/message.dart';

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

Future<http.Response> getUserByToken(Uri serverUri, String token) async {
  return http.get(serverUri, headers: {'Authorization': 'Bearer $token'});
}

Future<List<String>> getUserChatrooms(Uri serverUri, String token) async {
  final response = await http.get(
      Uri.http(serverUri.authority, '/chatrooms/read'),
      headers: {'Authorization': 'Bearer $token'});
  final body = jsonDecode(response.body) as Map<String, dynamic>;
  final result = body['chatroom_ids'] as List<dynamic>;
  return result.cast<String>();
}

Future<Chatroom> getChatroomById(
    Uri serverUri, String chatroomId, String token) async {
  final response = await http.post(
      Uri.http(serverUri.authority, '/chatrooms/readone'),
      headers: {'Authorization': 'Bearer $token'},
      body: '{"chatroom_id": "$chatroomId"}');
  debugPrint(response.body);

  return Chatroom.fromJson(response.body);
}

Future<Message> getMessageById(
    Uri serverUri, String messageId, String token) async {
  final response = await http.post(
      Uri.http(serverUri.authority, '/messages/readone'),
      headers: {'Authorization': 'Bearer $token'},
      body: '{"message_id": "$messageId"}');
  debugPrint(response.body);
  return Message.fromJson(response.body);
}
