import 'dart:async';
import 'dart:html';
import 'package:angular/angular.dart';
import 'package:angular_components/angular_components.dart';
import 'package:angular_router/angular_router.dart';
import 'package:chat_api_client/chat_api_client.dart';
import 'package:chat_models/chat_models.dart';
import 'package:chat_web/routes.dart';
import 'package:chat_web/services.dart';
import 'package:chat_web/src/components/chat_dashboard_component/chat_dashboard_component.dart';

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
  Router router;
  Session session;
  ChatsNotifier notifier;
  StreamSubscription subscription;
  ChatId chatId;
  Chat chat;
  List<Message> messages;
  String newMessageText = '';

  ChatComponent(this.messagesClient, this.router, this.session, this.notifier);

  ChatDashboardComponent _parent;
  @Input()
  set parent(ChatDashboardComponent value) => _parent = value;
  get parent => _parent;

  String getChatMembers() => chat.members
      .where((x) => x.id != session.currentUser.id)
      .map((user) => user.name)
      .join(', ');

  closeChat() {
    if (subscription != null) {
      subscription.cancel();
    }
    chatId = null;
    chat = null;
  }

  openChat(Chat _chat) async {
    chat = _chat;
    chatId = chat.id;
    messages = await messagesClient
        .read(chatId)
        .whenComplete(() => querySelector('.chatHistory').scrollTop = 1000000);

    if (subscription == null) {
      subscription = notifier.onMessages$.stream.listen((message) {
        if (message.chat == chatId) {
          messages.add(message);
          querySelector('.chatHistory').scrollTop = 1000000;
        }
      });
    }
  }

  send() async {
    final newMessage = Message(
        chat: chatId,
        author: session.currentUser,
        text: newMessageText,
        createdAt: DateTime.now());
    try {
      await messagesClient.create(newMessage);
    } on HttpException catch (e) {
      print('Sending message failed');
      print(e);
    }

    newMessageText = '';
  }

  @override
  onActivate(_, RouterState current) async {
    chatId = ChatId(current.parameters['chatId']);
    messages = await messagesClient
        .read(chatId)
        .whenComplete(() => querySelector('.chatHistory').scrollTop = 1000000);
    if (subscription == null) {
      subscription = notifier.onMessages$.stream.listen((message) {
        if (message.chat == chatId) {
          messages.add(message);
        }
      });
    }
  }

  @override
  onDeactivate(RouterState current, _) {
    if (subscription != null) {
      subscription.cancel();
    }
  }
}
