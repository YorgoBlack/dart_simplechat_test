import 'package:data_model/data_model.dart';

import 'user.dart';

class Chat implements Model<ChatId> {
  ChatId id;
  String chatName;
  List<User> members;

  Chat({this.id, this.chatName, this.members});
  factory Chat.fromJson(Map<String, dynamic> json) {
    if (json == null) return null;
    return Chat(
        id: ChatId(json['id']),
        chatName: json['chatName'],
        members: json['members'] is List
            ? List.from(
                json['members'].map((userJson) => User.fromJson(userJson)))
            : null);
  }

  Map<String, dynamic> get json => {
        'id': id?.json,
        'chatName': chatName,
        'members': members?.map((user) => user.json)?.toList()
      }..removeWhere((key, value) => value == null);
}

class ChatId extends ObjectId {
  ChatId._(id) : super(id);
  factory ChatId(id) {
    if (id == null) return null;
    return ChatId._(id);
  }
}
