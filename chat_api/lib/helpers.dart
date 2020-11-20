import 'package:web_socket_channel/web_socket_channel.dart';

export 'src/to_encodable.dart';

class SubjectWebSocketChannel {
  final String subject;
  final WebSocketChannel channel;
  SubjectWebSocketChannel(this.subject, this.channel);
}

class WsChannels {
  final channels = List<SubjectWebSocketChannel>();
}
