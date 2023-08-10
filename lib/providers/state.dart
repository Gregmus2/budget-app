import 'package:flutter/material.dart';

class StateProvider extends ChangeNotifier {
  int month = DateTime.now().month;
  int year = DateTime.now().year;
}
