import 'dart:async';
import 'dart:convert';
import 'dart:html';

import 'package:angular/angular.dart';
import 'package:web_socket_channel/html.dart';
import 'package:chat_models/chat_models.dart';

@Injectable()
class ChatsNotifier {
  HtmlWebSocketChannel webSocketChannel;
  Stream<Message> onMessages$;
  StreamController<Message> messagesStream;

  ChatsNotifier() {
    messagesStream = StreamController<Message>();
    onMessages$ = messagesStream.stream.asBroadcastStream();
  }

  Connect(url) {
    if (webSocketChannel == null) {
      webSocketChannel = HtmlWebSocketChannel.connect(url);
      webSocketChannel.stream.listen((data) {
        final n = Notification.fromJson(json.decode(data));
        switch (n.notificationType) {
          case NotificationType.Message:
            print(n.notificationMessage);
            messagesStream.add(n.notificationMessage);
            break;
          default:
            break;
        }
      });
    }
    print(webSocketChannel.closeCode);
  }

  Disconnect() {
    if (webSocketChannel != null) {
      webSocketChannel.sink.close();
    }
  }
}
