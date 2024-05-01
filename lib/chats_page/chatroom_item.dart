import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:messanger/api/models/message.dart';
import 'package:messanger/api/server_api.dart';
import 'package:messanger/chats_page/chat_list_controller.dart';

class ChatroomItem extends StatefulWidget {
  const ChatroomItem(
      {super.key, required this.chatroomIndex, required this.controller});

  final ChatListController controller;
  final int chatroomIndex;

  @override
  State<ChatroomItem> createState() => _ChatroomItemState();
}

class _ChatroomItemState extends State<ChatroomItem> {
  Message lastMessage = Message(
      id: 'id',
      chatroomId: 'chatroomId',
      authorId: 'authorId',
      body: 'Здесь пока нет сообщений');
  String title = '';

  Future<void> _asyncInitState() async {
    final chatroom = getChatroomById(
        widget.controller.serverUri,
        widget.controller.chatrooms[widget.chatroomIndex].id,
        widget.controller.token);
    // debugPrint(chatroom.id);

    chatroom.then((chatroom) {
      if (chatroom.type == 'pm') {
        setState(() {
          title = 'Сделать здесь имя собеседника';
        });
      }

      if (chatroom.type == 'group') {
        setState(() {
          title = chatroom.title;
        });
      }

      if (chatroom.lastMessageId != 'none') {
        final message = getMessageById(widget.controller.serverUri,
            chatroom.lastMessageId!, widget.controller.token);
        message.then(
          (message) {
            setState(() {
              lastMessage = message;
            });
          },
        );
      }
    });
  }

  @override
  void initState() {
    super.initState();
    // widget.controller.addListener(() {
    _asyncInitState();
    // });
  }

  @override
  Widget build(BuildContext context) {
    // debugPrint('token: ${widget.token} title: $title body: ${lastMessage.body}');
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration:
          const BoxDecoration(border: Border(bottom: BorderSide(width: 1))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
              padding: const EdgeInsets.symmetric(vertical: 2),
              child: Text(title)),
          Padding(
              padding: const EdgeInsets.symmetric(vertical: 2),
              child: Text(lastMessage.body))
        ],
      ),
    );
  }
}
