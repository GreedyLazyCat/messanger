import 'dart:async';
import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:messanger/api/models/chatroom.dart';
import 'package:messanger/api/models/message.dart';
import 'package:messanger/api/models/user.dart';
import 'package:messanger/api/server_api.dart';
import 'package:messanger/api/ws_controller.dart';
import 'package:messanger/single_chat_page/single_chat_page_main.dart';

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
    debugPrint('Item init state');
    super.initState();
    chatroom = widget.controller.chatrooms[widget.chatroomIndex];

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
    lastMessage = widget.controller.newMessages[chatroom.id];
    final lastMessageText =
        (lastMessage != null) ? lastMessage!.body : 'Здесь пока нет сообщений';
    final finalTitle = (title ?? 'no title');
    Color grey = Colors.grey[300]!;

    return ListTile(
      title: Text(finalTitle),
      subtitle: Text(lastMessageText, overflow: TextOverflow.fade),
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => SingleChatPage(
                  controller: widget.controller,
                  chatroom: chatroom,
                  title: finalTitle),
            ));
      },
    );
/*
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
          border:
              Border(bottom: BorderSide(width: 1, color: Colors.grey[300]!))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
              padding: const EdgeInsets.symmetric(vertical: 2),
              child: Text(
                finalTitle,
                style: const TextStyle(fontSize: 20),
              )),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 2),
            child: Text(
              (lastMessageText),
              overflow: TextOverflow.fade,
              style: const TextStyle(fontSize: 15),
            ),
          )
        ],
      ),
    );*/
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
