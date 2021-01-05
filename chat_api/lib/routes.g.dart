import 'dart:convert';
import 'package:shelf/shelf.dart';
import 'package:rest_api_server/src/route.dart';
import 'package:chat_api/src/resources/chats_resource.dart';
import 'package:chat_api/src/resources/messages_resource.dart';
import 'package:chat_api/src/resources/users_resource.dart';
import 'package:chat_api/src/resources/web_socket_resource.dart';

final _chatsResource = ChatsResource();
final _messagesResource = MessagesResource();
final _usersResource = UsersResource();
final _webSocketResource = WebSocketResource();
final routes = <Route>[
  Route('GET*', 'chats', (Request request) async {
    final reqParameters = <String, String>{};
    reqParameters.addAll(request.requestedUri.queryParameters);
    final result = _chatsResource.read(request.context);
    return makeResponseFrom(result);
  }),
  Route('GET*', 'chats/{chatIdStr}', (Request request) async {
    final offset = (List.from(request.requestedUri.pathSegments)
              ..removeWhere((segment) => segment.isEmpty))
            .length -
        2;
    final reqParameters = <String, String>{
      'chatIdStr': request.requestedUri.pathSegments[1 + offset]
    };
    reqParameters.addAll(request.requestedUri.queryParameters);
    final result =
        _chatsResource.getChat(reqParameters['chatIdStr'], request.context);
    return makeResponseFrom(result);
  }),
  Route('POST*', 'chats', (Request request) async {
    final reqParameters = <String, String>{};
    reqParameters.addAll(request.requestedUri.queryParameters);
    final result = _chatsResource.create(
        json.decode(await request.readAsString()), request.context);
    return makeResponseFrom(result);
  }),
  Route('POST*', 'chats/{chatIdStr}/messages', (Request request) async {
    final offset = (List.from(request.requestedUri.pathSegments)
              ..removeWhere((segment) => segment.isEmpty))
            .length -
        3;
    final reqParameters = <String, String>{
      'chatIdStr': request.requestedUri.pathSegments[1 + offset]
    };
    reqParameters.addAll(request.requestedUri.queryParameters);
    final result = _messagesResource.create(reqParameters['chatIdStr'],
        json.decode(await request.readAsString()), request.context);
    return makeResponseFrom(result);
  }),
  Route('GET*', 'chats/{chatIdStr}/messages', (Request request) async {
    final offset = (List.from(request.requestedUri.pathSegments)
              ..removeWhere((segment) => segment.isEmpty))
            .length -
        3;
    final reqParameters = <String, String>{
      'chatIdStr': request.requestedUri.pathSegments[1 + offset]
    };
    reqParameters.addAll(request.requestedUri.queryParameters);
    final result =
        _messagesResource.read(reqParameters['chatIdStr'], request.context);
    return makeResponseFrom(result);
  }),
  Route('POST*', 'users/login', (Request request) async {
    final reqParameters = <String, String>{};
    reqParameters.addAll(request.requestedUri.queryParameters);
    final result =
        _usersResource.login(json.decode(await request.readAsString()));
    return makeResponseFrom(result);
  }),
  Route('POST*', 'users', (Request request) async {
    final reqParameters = <String, String>{};
    reqParameters.addAll(request.requestedUri.queryParameters);
    final result = _usersResource.create(
        json.decode(await request.readAsString()), request.context);
    return makeResponseFrom(result);
  }),
  Route('PATCH*', 'users', (Request request) async {
    final reqParameters = <String, String>{};
    reqParameters.addAll(request.requestedUri.queryParameters);
    final result = _usersResource.update(
        json.decode(await request.readAsString()), request.context);
    return makeResponseFrom(result);
  }),
  Route('GET*', 'users', (Request request) async {
    final reqParameters = <String, String>{};
    reqParameters.addAll(request.requestedUri.queryParameters);
    final result = _usersResource.read(reqParameters['name'], request.context);
    return makeResponseFrom(result);
  }),
  Route('GET*', 'ws/{chatIdStr}', (Request request) async {
    final offset = (List.from(request.requestedUri.pathSegments)
              ..removeWhere((segment) => segment.isEmpty))
            .length -
        2;
    final reqParameters = <String, String>{
      'chatIdStr': request.requestedUri.pathSegments[1 + offset]
    };
    reqParameters.addAll(request.requestedUri.queryParameters);
    final result = _webSocketResource.handleUpgradeRequest(
        reqParameters['chatIdStr'], request, request.context);
    return makeResponseFrom(result);
  }),
  Route('DELETE*', 'ws/{chatIdStr}', (Request request) async {
    final offset = (List.from(request.requestedUri.pathSegments)
              ..removeWhere((segment) => segment.isEmpty))
            .length -
        2;
    final reqParameters = <String, String>{
      'chatIdStr': request.requestedUri.pathSegments[1 + offset]
    };
    reqParameters.addAll(request.requestedUri.queryParameters);
    final result = _webSocketResource.deleteChannel(
        reqParameters['chatIdStr'], request, request.context);
    return makeResponseFrom(result);
  })
];
