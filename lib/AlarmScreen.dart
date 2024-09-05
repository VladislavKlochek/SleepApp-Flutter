import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';

class AlarmScreen extends StatelessWidget {
  final ReceivedAction receivedAction;
  const AlarmScreen({super.key, required this.receivedAction});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Alarm Screen'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'Alarm Fired!',
              style: TextStyle(fontSize: 24),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {},
              child: const Text('Dismiss'),
            ),
          ],
        ),
      ),
    );
  }
}