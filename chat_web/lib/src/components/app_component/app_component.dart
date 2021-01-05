import 'dart:async';

import 'package:angular/angular.dart';
import 'package:angular_components/angular_components.dart';
import 'package:angular_components/model/menu/menu.dart';
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
      DropdownMenuComponent,
      MaterialMenuComponent,
      routerDirectives
    ],
    providers: [
      popupBindings,
      ClassProvider(ApiClient, useClass: WebApiClient),
      ClassProvider(Session)
    ],
    exports: [RoutePaths, Routes])
class AppComponent implements OnDeactivate {
  Session session;
  bool isVisible = false;
  Router router;

  final menuModel_1 = MenuModel<MenuItem>([
    MenuItemGroup<MenuItem>([MenuItem('Profile'), MenuItem('SignOut')])
  ]);

  MenuModel menuModel;

  AppComponent(this.session, this.router) {
    menuModel = MenuModel<MenuItem>([
      MenuItemGroup<MenuItem>([
        MenuItem('Profile',
            action: () => router.navigate(RoutePaths.profile.toUrl())),
        MenuItem('SignOut', action: () => signOut()),
      ])
    ]);
  }

  signOut() {
    session.clear();
    router.navigate(RoutePaths.signIn.toUrl());
  }

  nav_profile() {
    ;
  }

  showAlert() {
    if (this.isVisible) {
      return;
    }
    this.isVisible = true;
    new Timer(new Duration(seconds: 2), () => this.isVisible = false);
  }

  @override
  void onDeactivate(RouterState current, RouterState next) {}
}
