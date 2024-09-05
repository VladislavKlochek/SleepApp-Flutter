import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:sleep_app/boxes.dart';
import 'main.dart';

class NotificationController {
  static String lastId = "";

  @pragma("vm:entry-point")
  static Future<void> onNotificationCreatedMethod(
      ReceivedNotification receivedNotification) async {
  }

  @pragma("vm:entry-point")
  static Future<void> onNotificationDisplayedMethod(
      ReceivedNotification receivedNotification) async {

    final Map<String, dynamic> payloadData = receivedNotification.payload!;
    lastId = payloadData['id'];

    FlutterBackgroundService().invoke('setAsBackground');
    if (payloadData['isVibration'] == "true" &&
        payloadData['isSound'] == "true") {
      FlutterBackgroundService().invoke('startAlarmWithSoundAndVibration');
    } else if (payloadData['isVibration'] == "true") {
      FlutterBackgroundService().invoke('startAlarmWithVibration');
    } else if (payloadData['isSound'] == "true") {
      FlutterBackgroundService().invoke('startAlarmWithSound');
    }
  }

  /// Use this method to detect if the user dismissed a notification
  @pragma("vm:entry-point")
  static Future<void> onDismissActionReceivedMethod(
      ReceivedAction receivedAction) async {
    FlutterBackgroundService().invoke('stopAlarm');
    MyApp.navigatorKey.currentState?.setState(() {
      final alarm = alarmBox.values
          .firstWhere((element) => element.id == int.parse(lastId));
      alarm.isActive = false;
    });
  }

  @pragma("vm:entry-point")
  static Future<void> onActionReceivedMethod(
      ReceivedAction receivedAction) async {

    MyApp.navigatorKey.currentState?.pushNamedAndRemoveUntil(
        '/notification-page',
        (route) =>
            (route.settings.name != '/notification-page') || route.isFirst,
        arguments: receivedAction);
  }
}
