import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:messanger/api/models/chatroom.dart';
import 'package:messanger/api/models/message.dart';
import 'package:messanger/api/models/user.dart';
import 'package:messanger/api/server_api.dart';
import 'package:messanger/chats_page/ws_controller.dart';

class ChatroomItem extends StatefulWidget {
  const ChatroomItem(
      {super.key, required this.chatroomIndex, required this.controller});

  final WsController controller;
  final int chatroomIndex;

  @override
  State<ChatroomItem> createState() => _ChatroomItemState();
}

class _ChatroomItemState extends State<ChatroomItem> {
  late Message? lastMessage;
  // late Future<User?> author;
  late Future<String?> futureTitle;
  late Chatroom chatroom;

  Future<String?> _getTitleByUser() async {
    final self = await getUserByToken(
        widget.controller.serverUri, widget.controller.token);
    for (var id in chatroom.participantIds) {
      if (self.id != id) {
        final other = await getUserById(
            widget.controller.serverUri, id, widget.controller.token);
        return other.login;
      }
    }
    return null;
  }

  @override
  void initState() {
    super.initState();
    chatroom = widget.controller.chatrooms[widget.chatroomIndex];

    lastMessage = widget.controller.newMessages[chatroom.id];

    if (chatroom.type == 'pm') {
      futureTitle = _getTitleByUser();
    } else {
      futureTitle = Future<String?>(() => chatroom.title);
    }
    // widget.controller.addListener(() {
    // _asyncInitState();
    // });
  }

  Widget _buildLoaded(BuildContext context, String? title) {
    Color grey = Colors.grey[300]!;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
          border: Border(bottom: BorderSide(width: 1, color: Colors.grey[300]!))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
              padding: const EdgeInsets.symmetric(vertical: 2),
              child: Text(
                (title ?? 'no title'),
                style: const TextStyle(fontSize: 20),
              )),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 2),
            child: Text(
              ((lastMessage != null)
                  ? lastMessage!.body
                  : 'Здесь пока нет сообщений'),
              overflow: TextOverflow.fade,
              style: const TextStyle(fontSize: 15),
            ),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // debugPrint('token: ${widget.token} title: $title body: ${lastMessage.body}');
    return FutureBuilder(
      future: futureTitle,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return _buildLoaded(context, snapshot.data);
        } else {
          return const Text('Loading');
        }
      },
    );
  }
}
