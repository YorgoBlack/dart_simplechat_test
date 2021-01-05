import 'package:angular/angular.dart';
import 'package:angular_components/angular_components.dart';
import 'package:angular_router/angular_router.dart';
import 'package:chat_api_client/chat_api_client.dart';
import 'package:chat_models/chat_models.dart';
import 'package:chat_web/components.dart';
import 'package:chat_web/routes.dart';
import 'package:chat_web/services.dart';

@Component(
    selector: 'chat-list',
    templateUrl: 'chat_list_component.html',
    styleUrls: [
      'chat_list_component.css'
    ],
    directives: [
      coreDirectives,
      materialInputDirectives,
      routerDirectives,
      MaterialListComponent,
      MaterialListItemComponent,
      MaterialButtonComponent,
      MaterialFabComponent,
      MaterialIconComponent,
      MaterialDialogComponent,
      ModalComponent,
      UsersListComponent
    ],
    providers: [
      overlayBindings,
      ClassProvider(ChatsClient)
    ])
class ChatListComponent implements OnInit {
  Session session;
  ChatsClient chatsClient;
  Router router;

  List<Chat> chats = [];
  bool showCreateChatDialog = false;
  String chatName = '';

  @ViewChild(UsersListComponent)
  UsersListComponent usersList;

  ChatListComponent(this.session, this.chatsClient, this.router);

  String getChatMembers(ChatId chatId) {
    final chat = chats.firstWhere((chat) => chat.id == chatId);
    return chat.chatName == null
        ? chat.members.map((user) => user.name).join(', ')
        : chat.chatName;
  }

  void selectChat(Chat chat) {
    router
        .navigate(RoutePaths.chat.toUrl(parameters: {'chatId': chat.id.json}));
  }

  void createChat() async {
    try {
      final newChat = await chatsClient.create(Chat(
          chatName: chatName,
          members: usersList.selectedUsers.selectedValues.toList()
            ..add(session.currentUser)));
      chats.add(newChat);
      selectChat(newChat);
    } on HttpException catch (e) {
      print('Chat creation failed');
      print(e);
    }
  }

  @override
  ngOnInit() async {
    try {
      chats = await chatsClient.read({});
    } on HttpException catch (e) {
      print('Getting chat list failed');
      print(e);
    }
  }
}
