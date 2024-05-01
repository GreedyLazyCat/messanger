import 'dart:convert';

class Chatroom {
  late String id;

  /// [type] = pm - личные сообщения
  /// [type] = group - группа
  late String type;
  late List<String> participantIds;
  late String title;
  late String? lastMessageId;

  Chatroom(
      {required this.id,
      required this.type,
      required this.title,
      required this.participantIds,
      required this.lastMessageId});
  Chatroom.fromJson(String json) {
    final decoded = jsonDecode(json) as Map<String, dynamic>;

    id = decoded['id'] as String;
    type = decoded['type'] as String;
    title = decoded['title'] as String;
    participantIds = (decoded['participant_ids'] as List<dynamic>).cast<String>();
    lastMessageId = decoded['lastMessage_id'] as String;
  }

  Chatroom.fromObject(Object json) {
    final decoded = json as Map<String, dynamic>;

    id = decoded['id'] as String;
    type = decoded['type'] as String;
    title = decoded['title'] as String;
    participantIds = (decoded['participant_ids'] as List<dynamic>).cast<String>();
    lastMessageId = decoded['lastMessage_id'] as String;
  }

  String toJson() {
    return jsonEncode({
      'id': id,
      'type': type,
      'title': title,
      'participant_ids': participantIds,
      'lastMessage_id': lastMessageId
    });
  }
}
