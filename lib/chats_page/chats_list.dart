import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:messanger/api/models/user.dart';
import 'package:messanger/api/server_api.dart';
import 'package:messanger/chats_page/chat_list_controller.dart';
import 'package:messanger/chats_page/chatroom_item.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChatList extends StatefulWidget {
  const ChatList({super.key});

  @override
  State<ChatList> createState() => _ChatListState();
}

class _ChatListState extends State<ChatList> {
  String token = '';
  User user = User(id: 'id', login: 'login');
  Uri serverUri = Uri();
  List<String> chatroomIds = ['first'];
  ChatListController controller = ChatListController();

  Future<void> _asyncInitState() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      token = prefs.getString('token') ?? 'no token';

      serverUri = Uri.parse(prefs.getString('serverUri') ?? 'http://localhost');
    });
    if (token != 'no token') {
      var response = await getUserByToken(
          Uri.http(serverUri.authority, '/users/read'), token);
      setState(() {
        final body = jsonDecode(response.body) as Map<String, dynamic>;
        user = User(id: body['id'] as String, login: body['login'] as String);
      });

      final chatrooms = await getUserChatrooms(serverUri, token);

      setState(() {
        chatroomIds = chatrooms;
        // debugPrint(chatroomIds.toString());
      });
    }
  }

  @override
  void initState() {
    super.initState();
    // _asyncInitState();
    controller.initState();
  }

  @override
  Widget build(BuildContext context) {
    // debugPrint('build called');
    // debugPrint('chatroomId:v${chatroomIds[0]}, token: $token, serverUri: serverUri');

    return ListenableBuilder(
      listenable: controller,
      builder: (context, child) {
        return ListView.builder(
            padding: const EdgeInsets.all(8),
            itemCount: controller.chatrooms.length,
            itemBuilder: (BuildContext context, int index) {
              return ChatroomItem(
                  chatroomIndex: index,
                  controller: controller);
            });
      },
    );
  }
}
