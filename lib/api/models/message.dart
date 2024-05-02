import 'dart:convert';

class Message {
  late String id;
  late String chatroomId;
  late String authorId;
  late String body;

  Message(
      {required this.id, required this.chatroomId, required this.authorId, required this.body});

  Message.fromJson(String json){
    final decoded = jsonDecode(json) as Map<String, dynamic>;
    
    id = decoded['id'];
    chatroomId = decoded['chatroom_id'];
    authorId = decoded['author_id'];
    body = decoded['body'];
  }

  Message.fromObject(Object object){
    final decoded = object as Map<String, dynamic>;
    
    id = decoded['id'];
    chatroomId = decoded['chatroom_id'];
    authorId = decoded['author_id'];
    body = decoded['body'];
  }

  String toJson() {
    return jsonEncode(
        {'chatroom_id': chatroomId, 'author_id': authorId, 'body': body});
  }

  Object toObject() {
    return {'chatroom_id': chatroomId, 'author_id': authorId, 'body': body};
  }


}
