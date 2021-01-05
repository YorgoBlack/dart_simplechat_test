import 'dart:html';
import 'package:angular/angular.dart';
import 'package:angular_components/angular_components.dart';
import 'package:angular_router/angular_router.dart';
import 'package:chat_api_client/chat_api_client.dart';
import 'package:chat_models/chat_models.dart';
import 'package:chat_web/services.dart';
import 'package:web_socket_channel/html.dart';

@Component(
  selector: 'chat',
  templateUrl: 'chat_component.html',
  styleUrls: [
    'chat_component.css',
  ],
  directives: [
    coreDirectives,
    materialInputDirectives,
    MaterialButtonComponent,
    MaterialIconComponent,
  ],
  pipes: [
    DatePipe,
  ],
  providers: [
    materialProviders,
    ClassProvider(
      MessagesClient,
    )
  ],
)
class ChatComponent implements OnActivate, OnDeactivate {
  MessagesClient messagesClient;
  ChatsClient chatsClient;
  Router router;
  Session session;
  Chat chat;
  ChatId chatId;
  List<Message> messages;
  String newMessageText = '';
  HtmlWebSocketChannel webSocketChannel;

  ChatComponent(this.messagesClient, this.router, this.session);

  String getChatMembers() => chat.members
      .where((x) => x.id != session.currentUser.id)
      .map((user) => user.name)
      .join(', ');

  send() async {
    final newMessage = Message(
        chat: chat.id,
        author: session.currentUser,
        text: newMessageText,
        createdAt: DateTime.now());
    try {
      await messagesClient.create(newMessage);
    } on HttpException catch (e) {
      print(e);
      print('Sending message failed');
    }

    newMessageText = '';
  }

  @override
  onActivate(_, RouterState current) async {
    chatId = ChatId(current.parameters['chatId']);
    messages = await messagesClient
        .read(chatId)
        .whenComplete(() => querySelector('.chatHistory').scrollTop = 1000000);

    final url = Uri.parse('http://localhost:8888/ws/' + chatId.json);
    webSocketChannel = HtmlWebSocketChannel.connect(url);
    webSocketChannel.stream.listen((msg) {
      messages.add(msg);
    });
  }

  @override
  onDeactivate(RouterState current, _) {
    webSocketChannel.sink.close();
  }
}
