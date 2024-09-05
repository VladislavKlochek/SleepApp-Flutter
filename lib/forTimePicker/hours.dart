// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

class MyHours extends StatelessWidget {
  final int hours;

  const MyHours({super.key, required this.hours});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: Center(
        child: Text(
          hours.toString(),
          style: TextStyle(
            fontSize: 50,
            color: const Color.fromARGB(255, 75, 68, 68),
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
