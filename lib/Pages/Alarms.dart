import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:sleep_app/models/AlarmItem.dart';
import '../boxes.dart';
import '../forTimePicker/hours.dart';
import '../forTimePicker/minutes.dart';
import '../models/alarm_info.dart';

class AlarmsPage extends StatefulWidget {
  const AlarmsPage({Key? key}) : super(key: key);

  @override
  State<AlarmsPage> createState() => _AlarmsPageState();
}

class _AlarmsPageState extends State<AlarmsPage> {
  final TextEditingController _nameController = TextEditingController();
  final FixedExtentScrollController _minutesController = FixedExtentScrollController();
  final FixedExtentScrollController _hoursController = FixedExtentScrollController();
  bool showCard = false;
  bool alarmSwitch = true;
  bool vibrationSwitch = true;
  String selectedSound = "lib/sounds/Belt.mp3";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Alarms"),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => setState(() {
              showCard = !showCard;
            }),
          ),
        ],
      ),
      body: Stack(
        children: [
          _buildBackground(),
          if (showCard) _buildAlarmCard(),
        ],
      ),
    );
  }

  Widget _buildBackground() {
    return Opacity(
      opacity: showCard ? 0.9 : 1,
      child: GestureDetector(
        onTap: () => setState(() {
          showCard = false;
        }),
        child: Container(
          color: showCard ? Colors.black : Colors.white,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(width: MediaQuery.of(context).size.width * 0.05),
              Expanded(
                child: ListView.builder(
                  itemCount: alarmBox.length,
                  itemBuilder: (context, index) {
                    final alarm = alarmBox.getAt(index) as AlarmInfo;
                    return Dismissible(
                      key: ValueKey(alarm.key),
                      onDismissed: (direction) => _deleteAlarmAt(index),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: AlarmItem(alarmInfo: alarm),
                      ),
                    );
                  },
                ),
              ),
              SizedBox(width: MediaQuery.of(context).size.width * 0.05),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAlarmCard() {
    return Center(
      child: SingleChildScrollView(
        child: FractionallySizedBox(
          widthFactor: 0.8,
          child: Card(
            shadowColor: Colors.black26,
            elevation: 3,
            color: Colors.white,
            child: SizedBox(
              height: 500.0,
              child: Column(
                children: [
                  _buildTimePicker(),
                  _buildTextField(),
                  _buildSoundPicker(),
                  _buildVibrationPicker(),
                  const Spacer(),
                  _buildConfirmButton(),
                  const Spacer(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTimePicker() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildHoursWheel(),
        const SizedBox(width: 5),
        const Text(":", style: TextStyle(fontSize: 50, color: Color.fromARGB(255, 75, 68, 68), fontWeight: FontWeight.bold)),
        const SizedBox(width: 5),
        _buildMinutesWheel(),
      ],
    );
  }

  Widget _buildHoursWheel() {
    return SizedBox(
      width: 140,
      height: 200,
      child: ListWheelScrollView.useDelegate(
        controller: _hoursController,
        itemExtent: 80,
        perspective: 0.003,
        diameterRatio: 1.2,
        physics: const FixedExtentScrollPhysics(),
        childDelegate: ListWheelChildBuilderDelegate(
          childCount: 24,
          builder: (context, index) => MyHours(hours: index),
        ),
      ),
    );
  }

  Widget _buildMinutesWheel() {
    return SizedBox(
      width: 140,
      height: 200,
      child: ListWheelScrollView.useDelegate(
        controller: _minutesController,
        itemExtent: 75,
        perspective: 0.003,
        diameterRatio: 1.2,
        physics: const FixedExtentScrollPhysics(),
        childDelegate: ListWheelChildBuilderDelegate(
          childCount: 60,
          builder: (context, index) => MyMinutes(mins: index),
        ),
      ),
    );
  }

  Widget _buildTextField() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: TextField(
        controller: _nameController,
        decoration: InputDecoration(
          hintText: 'Введите текст',
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.black.withOpacity(0.12), width: 0.5),
          ),
          focusedBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.black, width: 2.0),
          ),
        ),
      ),
    );
  }

  Widget _buildSoundPicker() {
    return GestureDetector(
      onTap: pickTrack,
      child: _buildSwitchRow(
        title: "Звук будильника",
        subtitle: selectedSound.split("/").last,
        switchValue: alarmSwitch,
        onChanged: (value) => setState(() {
          alarmSwitch = value;
        }),
      ),
    );
  }

  Widget _buildVibrationPicker() {
    return _buildSwitchRow(
      title: "Вибрация будильника",
      subtitle: "Базовая",
      switchValue: vibrationSwitch,
      onChanged: (value) => setState(() {
        vibrationSwitch = value;
      }),
    );
  }

  Widget _buildSwitchRow({required String title, required String subtitle, required bool switchValue, required ValueChanged<bool> onChanged}) {
    return Container(
      decoration: const BoxDecoration(
        color: Color.fromARGB(117, 138, 1, 180),
        borderRadius: BorderRadius.all(Radius.circular(30)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold)),
                Text(subtitle, style: const TextStyle(fontSize: 15, color: Colors.white24, fontWeight: FontWeight.bold)),
              ],
            ),
            Switch(value: switchValue, onChanged: onChanged),
          ],
        ),
      ),
    );
  }

  Widget _buildConfirmButton() {
    return GestureDetector(
      onTap: _confirmAlarm,
      child: Container(
        height: 50,
        width: 200,
        alignment: Alignment.center,
        decoration: ShapeDecoration(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
          color: const Color.fromARGB(222, 87, 8, 121),
        ),
        child: const Text(
          "Подтвердить",
          style: TextStyle(fontSize: 15, color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  void _deleteAlarmAt(int index) {
    final removedAlarm = alarmBox.getAt(index) as AlarmInfo;
    alarmBox.deleteAt(index);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Будильник удален'),
        action: SnackBarAction(
          label: 'Отмена',
          onPressed: () => setState(() {
            alarmBox.add(removedAlarm);
          }),
        ),
      ),
    );
  }

  void _confirmAlarm() {
    DateTime now = DateTime.now();
    Duration difference = now.difference(DateTime(now.year, now.month, now.day));

    String hoursString = _hoursController.selectedItem.toString().padLeft(2, '0');
    String minutesString = _minutesController.selectedItem.toString().padLeft(2, '0');
    alarmBox.add(
      AlarmInfo(
        time: "$hoursString:$minutesString",
        description: _nameController.text,
        isActive: false,
        isSound: alarmSwitch,
        isVibration: vibrationSwitch,
        id: difference.inSeconds,
        soundName: selectedSound,
      ),
    );
    setState(() {
      showCard = false;
    });
  }

  Future<void> pickTrack() async {
    final result = await FilePicker.platform.pickFiles(type: FileType.audio);
    if (result != null) {
      setState(() {
        selectedSound = result.files.single.path ?? selectedSound;
      });
    } else {
      // User canceled the picker
    }
  }
}
