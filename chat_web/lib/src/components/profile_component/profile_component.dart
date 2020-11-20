import 'package:angular/angular.dart';
import 'package:chat_web/services.dart';

@Component(
    selector: 'profile',
    templateUrl: 'profile_component.html',
    styleUrls: ['profile_component.css'],
    directives: [],
    providers: [],
    exports: [])
class ProfileComponent {
  Session session;

  ProfileComponent(this.session);
}
