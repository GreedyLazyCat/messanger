import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:messanger/api/models/chatroom.dart';
import 'package:messanger/api/models/message.dart';
import 'package:messanger/api/models/user.dart';
import 'package:messanger/api/server_api.dart';
import 'package:messanger/api/ws_controller.dart';

class SingleChatPage extends StatefulWidget {
  const SingleChatPage(
      {super.key,
      required this.controller,
      required this.chatroom,
      required this.title});

  final WsController controller;
  final Chatroom chatroom;
  final String title;

  @override
  State<SingleChatPage> createState() => _SingleChatPageState();
}

class _SingleChatPageState extends State<SingleChatPage> {
  late Future<List<Message>> messages;
  late Future<List<User>> participants;

  TextEditingController txtController = TextEditingController();

  Future<List<User>> _getParticipants() async {
    final users = List<User>.empty(growable: true);
    for (String userId in widget.chatroom.participantIds) {
      users.add(await getUserById(
          widget.controller.serverUri, userId, widget.controller.token));
    }

    return users;
  }

  @override
  void initState() {
    super.initState();
    messages = getChatroomMessages(widget.controller.serverUri,
        widget.chatroom.id, widget.controller.token);
    participants = _getParticipants();
  }

  Widget _buildListView() {
    return FutureBuilder(
        future: Future.wait([messages, participants]),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final futureMessages = snapshot.data![0] as List<Message>;
            final futureUsers = snapshot.data![1] as List<User>;

            return ListenableBuilder(
              listenable: widget.controller,
              builder: (context, child) {
                return ListView.builder(
                  itemCount: futureMessages.length,
                  itemBuilder: (context, index) {
                    final message = futureMessages[index];
                    final author = futureUsers.singleWhere(
                      (element) => element.id == message.authorId,
                    );
                    final isSelf = author.id == widget.controller.user.id;
                    return ListTile(
                      title: Text(
                        author.login,
                        textAlign: isSelf ? TextAlign.end : TextAlign.start,
                      ),
                      subtitle: Text(
                        futureMessages[index].body,
                        textAlign: isSelf ? TextAlign.end : TextAlign.start,
                      ),
                    );
                  },
                );
              },
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
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Column(
        children: [
          Expanded(child: _buildListView()),
          Padding(
              padding: const EdgeInsets.only(left: 10, bottom: 10),
              child: Row(
                children: [
                  Expanded(
                      child: TextField(
                    controller: txtController,
                  )),
                  IconButton(onPressed: () {}, icon: const Icon(Icons.send))
                ],
              ))
        ],
      ),
    );
  }
}
