import 'package:angular_router/angular_router.dart';
import 'route_paths.dart';
import 'package:chat_web/src/components/profile_component/profile_component.template.dart'
    as profileComponentTemplate;
import 'package:chat_web/src/components/sign_in_component/sign_in_component.template.dart'
    as signInComponentTemplate;
import 'package:chat_web/src/components/sign_up_component/sign_up_component.template.dart'
    as signUpComponentTemplate;
import 'package:chat_web/src/components/chat_list_component/chat_list_component.template.dart'
    as chatListComponentTemplate;
import 'package:chat_web/src/components/chat_component/chat_component.template.dart'
    as chatComponentTemplate;
import 'package:chat_web/src/components/chat_dashboard_component/chat_dashboard_component.template.dart'
    as chatDashboardComponentTemplate;

class Routes {
  static final profile = RouteDefinition(
      routePath: RoutePaths.profile,
      component: profileComponentTemplate.ProfileComponentNgFactory);

  static final signIn = RouteDefinition(
      routePath: RoutePaths.signIn,
      component: signInComponentTemplate.SignInComponentNgFactory);

  static final signUp = RouteDefinition(
      routePath: RoutePaths.signUp,
      component: signUpComponentTemplate.SignUpComponentNgFactory);

  static final chatDashboard = RouteDefinition(
      routePath: RoutePaths.chatdashboard,
      component:
          chatDashboardComponentTemplate.ChatDashboardComponentNgFactory);

  static final chats = RouteDefinition(
      routePath: RoutePaths.chats,
      component: chatListComponentTemplate.ChatListComponentNgFactory);

  static final chat = RouteDefinition(
      routePath: RoutePaths.chat,
      component: chatComponentTemplate.ChatComponentNgFactory);

  static final all = <RouteDefinition>[
    profile,
    signIn,
    signUp,
    chats,
    chat,
    chatDashboard
  ];
}
