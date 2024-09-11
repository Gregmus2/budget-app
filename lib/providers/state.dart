import 'package:fb/utils/currency.dart';
import 'package:fb/utils/dates.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

const firstDayOfMonthKey = 'firstDayOfMonth';

class StateProvider extends ChangeNotifier {
  late DateTimeRange range;
  RangeType rangeType = RangeType.monthly;
  int firstDayOfMonth = 1;
  Currency defaultCurrency = Currency.eur;
  ThemeMode themeMode = ThemeMode.system;

  late SharedPreferences _prefs;
  late User? _user;
  late String? userID;

  StateProvider();

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
    await _initFirstDayOfMonth();
    await _initThemeMode();
    _initMonthlyRange();
    _initUser();
  }

  Future<void> _initFirstDayOfMonth() async {
    int? firstDayOfMonth = _prefs.getInt(firstDayOfMonthKey);
    if (firstDayOfMonth != null) {
      this.firstDayOfMonth = firstDayOfMonth;
    }
  }

  Future<void> _initThemeMode() async {
    final themeMode = _prefs.getString('themeMode');
    if (themeMode != null) {
      this.themeMode = ThemeMode.values.firstWhere((e) => e.toString() == themeMode);
    }
  }

  void _initUser() {
    _user = FirebaseAuth.instance.currentUser;
    userID = _user?.uid;
  }

  void _initMonthlyRange() {
    final now = DateTime.now();
    final start = DateTime(now.year, now.month, firstDayOfMonth);
    range = _buildMonthlyRange(start);
  }

  bool get isMonthlyRange => rangeType == RangeType.monthly;

  bool get isCustomRange => rangeType == RangeType.custom;

  User? get user => _user;

  set user(User? user) {
    _initUser();
    notifyListeners();
  }

  void setFirstDayOfMonth(int day) {
    firstDayOfMonth = day;
    _prefs.setInt(firstDayOfMonthKey, firstDayOfMonth);
    if (rangeType == RangeType.monthly) {
      final start = range.start.copyWith(day: firstDayOfMonth);
      range = _buildMonthlyRange(start);

      notifyListeners();
    }
  }

  void setThemeMode(ThemeMode mode) {
    themeMode = mode;
    _prefs.setString('themeMode', mode.toString());

    notifyListeners();
  }

  DateTimeRange _buildMonthlyRange(DateTime start) {
    return DateTimeRange(start: start, end: start.copyWith(month: start.month + 1).subtract(const Duration(days: 1)));
  }

  void nextRange() {
    range = getNextRange(range, rangeType);

    notifyListeners();
  }

  void previousRange() {
    range = getPreviousRange(range, rangeType);

    notifyListeners();
  }
}
