import 'package:chat_models/src/inotification.dart';
import 'package:data_model/data_model.dart';
import 'inotification.dart';
import 'message.dart';

enum NotificationType { Message, Unknown }

extension ParseToString on NotificationType {
  String toShortString() {
    return this.toString().split('.').last;
  }
}

class Notification implements Model {
  NotificationType notificationType;
  INotificationMessage notificationMessage;

  Notification({this.notificationType, this.notificationMessage});

  @override
  factory Notification.fromJson(Map<String, dynamic> json) {
    if (json == null) return null;
    try {
      final NotificationType tp = NotificationType.values.firstWhere(
          (e) => e.toString() == 'NotificationType.' + json['type']);
      switch (tp) {
        case NotificationType.Message:
          return Notification(
              notificationType: tp,
              notificationMessage: Message.fromJson(json['message']));
        default:
          return null;
      }
    } catch (e) {
      return null;
    }
  }

  @override
  Map<String, dynamic> get json => {
        'type': notificationType.toShortString(),
        'message': notificationMessage.json
      };

  @override
  ObjectId id;
}
