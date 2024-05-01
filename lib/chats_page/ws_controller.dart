import 'package:flutter/material.dart';
import 'package:messanger/api/models/chatroom.dart';
import 'package:messanger/api/models/message.dart';
import 'package:messanger/api/models/user.dart';

class WsController extends ChangeNotifier {
  String token = '';
  Uri serverUri = Uri();
  List<Chatroom> chatrooms = [];
  ///[String] - chatroomId
  ///[Message] - последнее сообщение для чатрума
  Map<String, Message?> newMessages = {};
  User user = User(id: '', login: 'login');
}
