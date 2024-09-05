import 'dart:async';
import 'dart:ui';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_background_service_android/flutter_background_service_android.dart';
import 'package:vibration/vibration.dart';
import 'boxes.dart';

Future<void> initializeService() async {
  final service = FlutterBackgroundService();
  await service.configure(
    iosConfiguration: IosConfiguration(),
    androidConfiguration: AndroidConfiguration(
        onStart: onStart, isForegroundMode: false, autoStart: false),
  );
}

@pragma('vm:entry-point')
void onStart(ServiceInstance service) async {
  DartPluginRegistrant.ensureInitialized();

  AudioCache.instance = AudioCache(prefix: '');
  final player = AudioPlayer();
  player.setSourceAsset("lib/sounds/Belt.mp3");


  if (service is AndroidServiceInstance) {
    service.on('setAsForeground').listen((event) {
      service.setAsForegroundService();

    });
    service.on('setAsBackground').listen((event) {
      service.setAsBackgroundService();
      String currentSound = alarmBox.get("currentSound");
      if(currentSound != "lib/sounds/Belt.mp3"){
        player.setSourceDeviceFile(currentSound);
        print(currentSound);
        print("setAsBackground");
      }
    });
    service.on('stopService').listen((event) {
      player.stop();
      service.stopSelf();
    });
    service.on('startAlarmWithVibration').listen((event) async {
      if (await Vibration.hasVibrator() != null) {
        Vibration.vibrate(pattern: [500, 1000, 500, 2000], repeat: 1);
        // Vibration.vibrate(duration: 10000);
      }
    });
    service.on('startAlarmWithSound').listen((event) async {
      print("startAlarmWithSound");
      //print(currentSound);
     player.resume();
    });
    service.on('startAlarmWithSoundAndVibration').listen((event) async {
      player.resume();
      if (await Vibration.hasVibrator() != null) {
        Vibration.vibrate(pattern: [500, 1000, 500, 2000], repeat: 1);
        // Vibration.vibrate(duration: 10000);
      }
    });
    service.on('stopAlarm').listen((event) {
      player.stop();
      Vibration.cancel();
    });
  }
}
