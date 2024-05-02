import 'package:flutter/material.dart';
import 'package:messanger/api/models/message.dart';
import 'package:messanger/api/server_api.dart';
import 'package:messanger/chats_page/chats_list.dart';
import 'package:messanger/api/ws_controller.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChatsMainPage extends StatefulWidget {
  const ChatsMainPage({super.key});

  @override
  State<ChatsMainPage> createState() => _ChatsMainPageState();
}

class _ChatsMainPageState extends State<ChatsMainPage> {
  late Future<WsController> wsController;

  Future<WsController> _getController() async {
    final prefs = await SharedPreferences.getInstance();
    final controller = WsController();

    controller.token = prefs.getString('token') ?? 'no token';
    debugPrint(controller.token);
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

  Future<void> _setAuthToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('token', token);
  }

  @override
  void initState() {
    debugPrint('chats init state');
    super.initState();
    wsController = _getController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Чаты'),
          actions: [
            IconButton(onPressed: () {
              _setAuthToken('no token');
              Navigator.pushReplacementNamed(context, '/login');
            }, icon: const Icon(Icons.logout))
          ],
        ),
        floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.add),
          onPressed: () async {
            final controller = await wsController;
            controller.newMessages['first'] = Message(
                id: 'safdsfasdf',
                chatroomId: 'dasdf',
                authorId: 'asdf',
                body: 'asdf');
            controller.test();
          },
        ),
        body: FutureBuilder(
          future: wsController,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final controller = snapshot.data as WsController;
              return ChatList(controller: controller);
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
        ));
  }
}
