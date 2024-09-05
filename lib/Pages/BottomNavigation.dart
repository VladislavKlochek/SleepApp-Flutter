import 'package:flutter/material.dart';
import 'package:sleep_app/Pages/Alarms.dart';
import 'package:sleep_app/Pages/Information.dart';
import 'package:sleep_app/Pages/NotesPage.dart';

class BottomNavigation extends StatefulWidget {
  const BottomNavigation({super.key});

  @override
  State<BottomNavigation> createState() => _BottomNavigationState();
}

class _BottomNavigationState extends State<BottomNavigation> {
  int _selectedIndex = 0;

  void _navigateBottomBar(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  final List _pages = [const NotesPage(), const AlarmsPage(), const InformationPage()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: _pages[_selectedIndex],
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: _navigateBottomBar,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.notes), label: "Notes"),
            BottomNavigationBarItem(
                icon: Icon(Icons.alarm_sharp), label: "Alarms"),
            BottomNavigationBarItem(
                icon: Icon(Icons.book), label: "Information")
          ],
        ));
  }
}
