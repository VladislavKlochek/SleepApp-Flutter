// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

class MyMinutes extends StatelessWidget {
  final int mins;

  const MyMinutes({super.key, required this.mins});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: Container(
        child: Center(
          child: Text(
            mins < 10 ? '0$mins' : mins.toString(),
            style: TextStyle(
              fontSize: 50,
              color: const Color.fromARGB(255, 75, 68, 68),
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
