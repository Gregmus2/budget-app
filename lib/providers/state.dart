import 'package:fb/utils/currency.dart';
import 'package:fb/utils/dates.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

const firstDayOfMonthKey = 'firstDayOfMonth';


// todo make all properties for all classes private (which are not used outside) and add getters/setters if necessary

class StateProvider extends ChangeNotifier {
  late DateTimeRange range;
  RangeType rangeType = RangeType.monthly;
  int firstDayOfMonth = 1;
  Currency defaultCurrency = Currency();
  late SharedPreferences _prefs;
  late User? _user;
  late String? userID;

  StateProvider();

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
    await _initFirstDayOfMonth();
    _initMonthlyRange();
    _initUser();
  }

  Future<void> _initFirstDayOfMonth() async {
    int? firstDayOfMonth = _prefs.getInt(firstDayOfMonthKey);
    if (firstDayOfMonth == null) {
      await _prefs.setInt(firstDayOfMonthKey, this.firstDayOfMonth);
    } else {
      this.firstDayOfMonth = firstDayOfMonth;
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
