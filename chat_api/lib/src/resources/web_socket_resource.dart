import 'package:chat_models/chat_models.dart';
import 'package:rest_api_server/annotations.dart';
import 'package:rest_api_server/http_exception.dart';
import 'package:shelf/shelf.dart' as shelf;
import 'package:shelf_web_socket/shelf_web_socket.dart';
import 'package:rest_api_server/service_registry.dart';
import 'package:chat_api/helpers.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import '../../collections.dart';

@Resource(path: '/ws/{chatIdStr}')
class WebSocketResource {
  ChatsCollection chatsCollection = locateService<ChatsCollection>();
  WsChannels _wsChannels = locateService<WsChannels>();

  shelf.Handler _wsConnectionHandler;

  WebSocketResource() {}

  @Get()
  Future<shelf.Response> handleUpgradeRequest(
      String chatIdStr, shelf.Request request, Map context) async {
    final currentUser = User.fromJson(context['payload']);
    if (currentUser == null) throw (ForbiddenException());
    final chatId = ChatId(chatIdStr);
    final chat = await chatsCollection.findOne(chatId);
    if (!chat.members.any((member) => member.id == currentUser.id))
      throw (ForbiddenException());

    _wsConnectionHandler = webSocketHandler((WebSocketChannel wsChannel) {
      final exist = _wsChannels.channels.firstWhere(
          (element) =>
              element.chatId == chatIdStr &&
              element.userId == currentUser.id.value,
          orElse: () => null);
      if (exist != null) {
        exist.channel.sink.close();
        _wsChannels.channels.remove(exist);
      }
      _wsChannels.channels.add(
          SubjectWebSocketChannel(chatIdStr, currentUser.id.value, wsChannel));
    });

    return _wsConnectionHandler(request);
  }

  @Delete()
  Future<shelf.Response> deleteChannel(
      String chatIdStr, shelf.Request request, Map context) async {
    final currentUser = User.fromJson(context['payload']);
    if (currentUser == null) throw (ForbiddenException());
    final chatId = ChatId(chatIdStr);
    final chat = await chatsCollection.findOne(chatId);
    if (!chat.members.any((member) => member.id == currentUser.id))
      throw (ForbiddenException());

    final exist = _wsChannels.channels.firstWhere(
        (element) =>
            element.chatId == chatIdStr &&
            element.userId == currentUser.id.value,
        orElse: () => null);
    if (exist != null) {
      exist.channel.sink.close();
      _wsChannels.channels.remove(exist);
      return shelf.Response.ok(null);
    } else {
      return shelf.Response.notFound(null);
    }
  }
}
