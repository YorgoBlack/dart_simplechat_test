import 'package:angular_router/angular_router.dart';

class RoutePaths {
  static final profile = RoutePath(path: 'profile');
  static final signIn = RoutePath(path: 'signin');
  static final signUp = RoutePath(path: 'signup');
  static final chats = RoutePath(path: 'chats');
  static final chatdashboard = RoutePath(path: 'chatdashboard');
  static final chat = RoutePath(path: 'chats/:chatId');
}
