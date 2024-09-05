import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:sleep_app/Pages/BottomNavigation.dart';
import 'package:sleep_app/back_services.dart';
import 'AlarmScreen.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'boxes.dart';
import 'NotificationController.dart';
import 'models/Note.dart';
import 'models/alarm_info.dart';
import 'package:hive_flutter/hive_flutter.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await _initializeNotifications();
  await _initializeBackgroundService();
  await _initializeHive();
  await initializeDateFormatting('ru_RU', null);

  runApp(const MyApp());
}

Future<void> _initializeNotifications() async {
  AwesomeNotifications().initialize(
    null,
    [
      NotificationChannel(
        channelGroupKey: 'basic_channel_group',
        channelKey: 'basic_channel',
        channelName: 'Basic notifications',
        channelDescription: 'Notification channel for basic tests',
        defaultColor: const Color(0xFF9D50DD),
        ledColor: Colors.white,
      ),
    ],
    channelGroups: [
      NotificationChannelGroup(
        channelGroupKey: 'basic_channel_group',
        channelGroupName: 'Basic group',
      ),
    ],
    debug: true,
  );

  bool isAllowed = await AwesomeNotifications().isNotificationAllowed();
  if (!isAllowed) {
    await AwesomeNotifications().requestPermissionToSendNotifications();
  }

  AwesomeNotifications().setListeners(
    onActionReceivedMethod: NotificationController.onActionReceivedMethod,
    onNotificationCreatedMethod: NotificationController.onNotificationCreatedMethod,
    onNotificationDisplayedMethod: NotificationController.onNotificationDisplayedMethod,
    onDismissActionReceivedMethod: NotificationController.onDismissActionReceivedMethod,
  );
}

Future<void> _initializeBackgroundService() async {
  await initializeService();
  FlutterBackgroundService().startService();
}

Future<void> _initializeHive() async {
  await Hive.initFlutter();
  Hive.registerAdapter(NoteAdapter());
  Hive.registerAdapter(AlarmInfoAdapter());

  noteBox = await Hive.openBox('notes');
  alarmBox = await Hive.openBox('alarms');
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  static final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  static const String name = 'Awesome Notifications - Example App';
  static const Color mainColor = Colors.deepPurple;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      title: name,
      color: mainColor,
      debugShowCheckedModeBanner: false,
      home: const BottomNavigation(),
      initialRoute: '/',
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case '/':
            return MaterialPageRoute(builder: (context) => const BottomNavigation());
          case '/notification-page':
            return MaterialPageRoute(builder: (context) {
              final receivedAction = settings.arguments as ReceivedAction;
              return AlarmScreen(receivedAction: receivedAction);
            });
          default:
            assert(false, 'Page ${settings.name} not found');
            return null;
        }
      },
    );
  }
}

