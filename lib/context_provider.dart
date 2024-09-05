import 'package:flutter/material.dart';

class AlarmClockContext extends ChangeNotifier {
  BuildContext? _context;

  BuildContext get context => _context!;

  set context(BuildContext context) {
    _context = context;
    notifyListeners();
  }
}
