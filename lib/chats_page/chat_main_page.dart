import 'package:flutter/material.dart';
import 'package:messanger/chats_page/chats_list.dart';

class ChatsMainPage extends StatelessWidget {
  const ChatsMainPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Чаты'),),
      body: ChatList(),
    );
  }
}


