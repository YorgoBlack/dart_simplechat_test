import 'dart:async';

import 'package:angular/angular.dart';
import 'package:angular_components/angular_components.dart';
import 'package:angular_router/angular_router.dart';
import 'package:chat_web/routes.dart';
import 'package:chat_web/services.dart';
import 'package:rest_api_client/rest_api_client.dart';

@Component(
    selector: 'my-app',
    styleUrls: [
      'package:angular_components/app_layout/layout.scss.css',
      'app_component.css'
    ],
    templateUrl: 'app_component.html',
    directives: [
      coreDirectives,
      MaterialButtonComponent,
      MaterialIconComponent,
      routerDirectives
    ],
    providers: [
      ClassProvider(ApiClient, useClass: WebApiClient),
      ClassProvider(ChatsNotifier),
      ClassProvider(Session)
    ],
    exports: [RoutePaths, Routes])
class AppComponent implements OnDeactivate {
  Session session;
  ChatsNotifier notifier;
  StreamSubscription subscription;
  bool isVisible = false;
  Router router;

  AppComponent(this.session, this.router, this.notifier) {
    if (subscription == null) {
      subscription = notifier.onMessages$.listen((message) {
        showAlert();
      });
    }
  }

  signOut() {
    session.clear();
    router.navigate(RoutePaths.signIn.toUrl());
  }

  showAlert() {
    if (this.isVisible) {
      return;
    }
    this.isVisible = true;
    new Timer(new Duration(seconds: 2), () => this.isVisible = false);
  }

  @override
  void onDeactivate(RouterState current, RouterState next) {
    if (subscription != null) {
      subscription.cancel();
    }
  }
}
