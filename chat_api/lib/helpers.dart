import 'dart:async';
import 'dart:convert';

import 'package:chat_models/chat_models.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

export 'src/to_encodable.dart';

class SubjectWebSocketChannel {
  final String chatId;
  final String userId;
  final WebSocketChannel channel;
  SubjectWebSocketChannel(this.chatId, this.userId, this.channel);
}

class WsChannels {
  final channels = List<SubjectWebSocketChannel>();
}

class ChatViewModel {
  WebSocketChannel webSocketChannel;
  Stream<Message> onMessages$;
  StreamController<Message> messagesStream;
  int newMessagesCount;
  Chat chat;
  bool _isOpened;

  ChatViewModel(this.chat) {
    newMessagesCount = 0;
    _isOpened = false;

    messagesStream = StreamController<Message>();
    onMessages$ = messagesStream.stream.asBroadcastStream();
    final url = Uri.parse('http://localhost:8888/ws/' + chat.id.toString());
    webSocketChannel = WebSocketChannel.connect(url);
    webSocketChannel.stream.listen((data) {
      final msg = Message.fromJson(json.decode(data));
      messagesStream.add(msg);
      if (!_isOpened) {
        newMessagesCount++;
      }
    });
  }

  onLoadMessages() {
    _isOpened = true;
    newMessagesCount = 0;
  }

  onHide() {
    _isOpened = false;
  }

  Disconnect() {
//    if (webSocketChannel != null) {
//      webSocketChannel.sink.close();
    //  }
  }
}
