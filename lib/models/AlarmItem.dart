import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:sleep_app/models/alarm_info.dart';

class AlarmItem extends StatefulWidget {
  final AlarmInfo alarmInfo;

  const AlarmItem({super.key, required this.alarmInfo});

  @override
  State<AlarmItem> createState() => _AlarmItemState();
}

class _AlarmItemState extends State<AlarmItem> {
  @override
  Widget build(BuildContext context) {
    final AlarmInfo alarm = widget.alarmInfo;

    DateTime now = DateTime.now();
    DateTime alarmTime = _getAlarmTime(alarm.time, now);
    String dateWhen = _getDateWhen(alarmTime, now);
    bool isNextDay = alarmTime.isBefore(now);

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color.fromARGB(179, 55, 62, 125), Color.fromARGB(200, 72, 30, 125)],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: BorderRadius.all(Radius.circular(24)),
      ),
      child: Column(
        children: <Widget>[
          _buildAlarmInfoRow(alarm, dateWhen, isNextDay, alarmTime, now),
          const SizedBox(height: 8),
          _buildAlarmTimeRow(alarm.time),
        ],
      ),
    );
  }

  DateTime _getAlarmTime(String time, DateTime now) {
    return DateTime(
      now.year,
      now.month,
      now.day,
      int.parse(time.split(":")[0]),
      int.parse(time.split(":")[1]),
    );
  }

  String _getDateWhen(DateTime alarmTime, DateTime now) {
    if (alarmTime.isBefore(now)) {
      final tomorrow = now.add(const Duration(days: 1));
      return DateFormat('EEE, dd MMM', 'ru').format(tomorrow);
    } else {
      return DateFormat('EEE, dd MMM', 'ru').format(now);
    }
  }

  Widget _buildAlarmInfoRow(
      AlarmInfo alarm, String dateWhen, bool isNextDay, DateTime alarmTime, DateTime now) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        _buildAlarmLabel(alarm.description),
        Expanded(
          child: Align(
            alignment: Alignment.centerRight,
            child: Text(
              dateWhen,
              style: const TextStyle(color: Colors.white, fontFamily: "avenir"),
            ),
          ),
        ),
        _buildAlarmSwitch(alarm, isNextDay, alarmTime, now),
      ],
    );
  }

  Widget _buildAlarmLabel(String description) {
    return Row(
      children: <Widget>[
        const Icon(Icons.label, color: Colors.white, size: 24),
        const SizedBox(width: 8),
        Text(
          description,
          style: const TextStyle(color: Colors.white, fontFamily: "avenir"),
        ),
      ],
    );
  }

  Widget _buildAlarmSwitch(AlarmInfo alarm, bool isNextDay, DateTime alarmTime, DateTime now) {
    return Switch(
      value: alarm.isActive,
      onChanged: (bool value) => _toggleAlarm(value, alarm, isNextDay, alarmTime, now),
    );
  }

  void _toggleAlarm(bool value, AlarmInfo alarm, bool isNextDay, DateTime alarmTime, DateTime now) {
    setState(() {
      alarm.isActive = value;
    });

    if (value) {
      int secondsToWait = _calculateSecondsToWait(isNextDay, alarmTime, now);
      _scheduleAlarmNotification(alarm, secondsToWait);
    } else {
      AwesomeNotifications().cancel(alarm.id);
      alarm.isActive = false;
    }
  }

  int _calculateSecondsToWait(bool isNextDay, DateTime alarmTime, DateTime now) {
    if (isNextDay) {
      alarmTime = alarmTime.add(const Duration(days: 1));
    }
    return alarmTime.difference(now).inSeconds + 30;
  }

  void _scheduleAlarmNotification(AlarmInfo alarm, int secondsToWait) {
    String message = 'Будильника сработает через ${secondsToWait ~/ 3600} часов, ${(secondsToWait % 3600) ~/ 60} минут';
    Fluttertoast.showToast(msg: message);

    AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: alarm.id,
        channelKey: 'basic_channel',
        actionType: ActionType.Default,
        title: 'Будильник',
        body: alarm.time,
        wakeUpScreen: true,
        criticalAlert: true,
        category: NotificationCategory.Alarm,
        autoDismissible: false,
        fullScreenIntent: true,
        payload: {
          'isSound': alarm.isSound.toString(),
          'isVibration': alarm.isVibration.toString(),
          'id': alarm.id.toString(),
          'soundName': alarm.soundName,
        },
      ),
      schedule: NotificationInterval(
        interval: secondsToWait,
        timeZone: AwesomeNotifications.localTimeZoneIdentifier,
        preciseAlarm: true,
      ),
    );
  }

  Widget _buildAlarmTimeRow(String time) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(left: 18),
          child: Text(
            time,
            style: const TextStyle(
              color: Colors.white,
              fontFamily: "avenir",
              fontSize: 24,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        const Icon(
          Icons.keyboard_arrow_down,
          size: 36,
          color: Colors.white,
        ),
      ],
    );
  }
}
