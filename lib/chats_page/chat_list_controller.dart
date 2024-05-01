import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:messanger/api/models/chatroom.dart';
import 'package:messanger/api/models/user.dart';
import 'package:messanger/api/server_api.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChatListController extends ChangeNotifier {
  String token = '';
  User user = User(id: 'id', login: 'login');
  Uri serverUri = Uri();
  List<Chatroom> chatrooms = List.empty(growable: true);

  Future<void> initState() async {
    final prefs = await SharedPreferences.getInstance();

    token = prefs.getString('token') ?? 'no token';

    serverUri = Uri.parse(prefs.getString('serverUri') ?? 'http://localhost');
    if (token != 'no token') {
      var response = await getUserByToken(
          Uri.http(serverUri.authority, '/users/read'), token);

      final body = jsonDecode(response.body) as Map<String, dynamic>;
      user = User(id: body['id'] as String, login: body['login'] as String);

      final chatroomIds = await getUserChatrooms(serverUri, token);

      for (var chatroomId in chatroomIds){
        chatrooms.add(await getChatroomById(serverUri, chatroomId, token));
      }

      notifyListeners();
      // debugPrint(chatroomIds.toString());
    }
  }
}
