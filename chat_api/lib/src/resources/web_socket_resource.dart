import 'package:rest_api_server/annotations.dart';
import 'package:shelf/shelf.dart' as shelf;
import 'package:shelf_web_socket/shelf_web_socket.dart';
import 'package:rest_api_server/service_registry.dart';
import 'package:chat_api/helpers.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

@Resource(path: '/ws')
class WebSocketResource {
  final WsChannels _wsChannels = locateService<WsChannels>();

  shelf.Handler _wsConnectionHandler;

  WebSocketResource(String subject) {
    _wsConnectionHandler = webSocketHandler((WebSocketChannel wsChannel) {
      final exist = _wsChannels.channels.firstWhere(
          (element) => element.subject == subject,
          orElse: () => null);
      if (exist != null) {
        exist.channel.sink.close();
        _wsChannels.channels.remove(exist);
      }
      _wsChannels.channels.add(SubjectWebSocketChannel(subject, wsChannel));
    });
  }

  @Get()
  shelf.Response handleUpgradeRequest(shelf.Request request, Map context) {
    return _wsConnectionHandler(request);
  }
}
