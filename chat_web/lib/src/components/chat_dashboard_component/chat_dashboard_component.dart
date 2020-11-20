import 'package:angular/angular.dart';
import 'package:chat_web/src/components/chat_component/chat_component.dart';
import 'package:chat_web/src/components/chat_list_component/chat_list_component.dart';

@Component(
    selector: 'chat-dashboard',
    templateUrl: 'chat_dashboard_component.html',
    styleUrls: [
      'chat_dashboard_component.css'
    ],
    directives: [
      coreDirectives,
      ChatComponent,
      ChatListComponent,
    ],
    providers: [])
class ChatDashboardComponent {
  ChatDashboardComponent();

  get self => this;
  @ViewChild(ChatListComponent)
  ChatListComponent chatsListComponent;
  @ViewChild(ChatComponent)
  ChatComponent chatComponent;
}
