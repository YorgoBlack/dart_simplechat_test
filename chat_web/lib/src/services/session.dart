import 'dart:convert';
import 'dart:html';

import 'package:angular/angular.dart';
import 'package:chat_models/chat_models.dart';

import 'chats_notifier.dart';

@Injectable()
class Session {
  ChatsNotifier notifier;

  Session(this.notifier);

  set currentUser(User user) {
    if (currentUser != null) {
      notifier.Disconnect();
    }
    print('set user' + json.encode(user.json));
    window.localStorage['currentUser'] = json.encode(user.json);
    notifier.Connect('ws://localhost:8888/ws?token=' + authToken);
  }

  User get currentUser {
    if (window.localStorage['currentUser'] == null) return null;
    notifier.Connect('ws://localhost:8888/ws?token=' + authToken);
    return User.fromJson(json.decode(window.localStorage['currentUser']));
  }

  set authToken(String token) {
    window.localStorage['authtoken'] = token;
  }

  String get authToken => window.localStorage['authtoken'];

  void clear() {
    window.localStorage.clear();
    notifier.Disconnect();
  }
}
