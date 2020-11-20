import 'dart:async';
import 'dart:convert';
import 'dart:html';

import 'package:angular/angular.dart';
import 'package:web_socket_channel/html.dart';
import 'package:chat_models/chat_models.dart';

@Injectable()
class ChatsNotifier {
  HtmlWebSocketChannel webSocketChannel;
  StreamController<Message> onMessages$;

  ChatsNotifier() {
    onMessages$ = StreamController<Message>.broadcast();
  }

  Connect(url) {
    if (webSocketChannel == null) {
      webSocketChannel = HtmlWebSocketChannel.connect(url);
      webSocketChannel.stream.listen((data) {
        final n = Notification.fromJson(json.decode(data));
        switch (n.notificationType) {
          case NotificationType.Message:
            print(n.notificationMessage);
            onMessages$.add(n.notificationMessage);
            break;
          default:
            break;
        }
      });
    }
  }

  Disconnect() {
    if (webSocketChannel != null) {
      webSocketChannel.sink.close();
    }
  }
}
