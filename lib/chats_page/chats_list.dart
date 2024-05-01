import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:messanger/api/models/chatroom.dart';
import 'package:messanger/api/models/message.dart';
import 'package:messanger/api/models/user.dart';
import 'package:messanger/api/server_api.dart';
import 'package:messanger/chats_page/chatroom_item.dart';
import 'package:messanger/chats_page/ws_controller.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChatList extends StatefulWidget {
  const ChatList({super.key});

  @override
  State<ChatList> createState() => _ChatListState();
}

class _ChatListState extends State<ChatList> {
  late Future<WsController> wsController;

  Future<WsController> _getController() async {
    final prefs = await SharedPreferences.getInstance();
    final controller = WsController();

    controller.token = prefs.getString('token') ?? 'no token';
    controller.serverUri =
        Uri.parse(prefs.getString('serverUri') ?? 'http://localhost');

    if (controller.token != 'no token') {
      controller.user =
          await getUserByToken(controller.serverUri, controller.token);
      controller.chatrooms =
          (await getUserChatrooms(controller.serverUri, controller.token))!;
      for (var chatroom in controller.chatrooms) {
        if (chatroom.lastMessageId != 'none') {
          final lastMessage = await getMessageById(
              controller.serverUri, chatroom.lastMessageId!, controller.token);
          controller.newMessages.addAll({chatroom.id: lastMessage});
        } else {
          controller.newMessages.addAll({chatroom.id: null});
        }
      }
    }
    return controller;
  }

  @override
  void initState() {
    super.initState();
    wsController = _getController();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: wsController,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final controller = snapshot.data as WsController;
          return ListenableBuilder(
            listenable: controller,
            builder: (context, child) {
              return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: ListView.builder(
                    itemCount: controller.chatrooms.length,
                    itemBuilder: (context, index) {
                      return ChatroomItem(
                          chatroomIndex: index, controller: controller);
                    },
                  ));
            },
          );
        } else if (snapshot.hasError) {
          return Center(
            child: Column(
              children: <Widget>[
                const Icon(
                  Icons.error_outline,
                  color: Colors.red,
                  size: 60,
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 16),
                  child: Text('Error: ${snapshot.error}'),
                ),
              ],
            ),
          );
        } else {
          return const Center(
            child: SizedBox(
              width: 60,
              height: 60,
              child: CircularProgressIndicator(),
            ),
          );
        }
      },
    );
  }
}
