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
  const ChatList({super.key, required this.controller});

  final WsController controller;

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
    // wsController = _getController();
  }

  @override
  Widget build(BuildContext context) {

    return ListenableBuilder(
            listenable: widget.controller,
            builder: (context, child) {
              return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: ListView.builder(
                    itemCount: widget.controller.chatrooms.length,
                    itemBuilder: (context, index) {
                      return ChatroomItem(
                          chatroomIndex: index, controller: widget.controller);
                    },
                  ));
            },
          );

  
  }
}
