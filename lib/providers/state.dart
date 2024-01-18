import 'package:flutter/material.dart';
import 'package:realm/realm.dart';
import 'package:shared_preferences/shared_preferences.dart';

const firstDayOfMonthKey = 'firstDayOfMonth';

enum RangeType { daily, weekly, monthly, yearly, custom }

// todo make all properties for all classes private (which are not used outside) and add getters/setters if necessary

class StateProvider extends ChangeNotifier {
  late DateTimeRange range;
  RangeType rangeType = RangeType.monthly;
  int firstDayOfMonth = 1;
  final App _app;
  late SharedPreferences _prefs;
  late User? _user;
  late String? userID;

  StateProvider(this._app);

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
    _user = _app.currentUser;
    userID = _user?.id;
  }

  void _initMonthlyRange() {
    final now = DateTime.now();
    final start = DateTime(now.year, now.month, firstDayOfMonth);
    range = _buildMonthlyRange(start);
  }

  bool get isMonthlyRange => rangeType == RangeType.monthly;

  bool get isCustomRange => rangeType == RangeType.custom;

  User? get user => _user;

  App get app => _app;

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
    switch (rangeType) {
      case RangeType.monthly:
        range = DateTimeRange(
            start: range.start.copyWith(month: range.start.month + 1),
            end: range.start.copyWith(month: range.start.month + 2).subtract(const Duration(microseconds: 1)));
        break;
      case RangeType.yearly:
        range = DateTimeRange(
            start: range.start.copyWith(year: range.start.year + 1),
            end: range.start.copyWith(year: range.start.year + 2).subtract(const Duration(microseconds: 1)));
        break;
      case RangeType.daily:
        range = DateTimeRange(
            start: range.start.copyWith(day: range.start.day + 1),
            end: range.start.copyWith(day: range.start.day + 2).subtract(const Duration(microseconds: 1)));
        break;
      case RangeType.weekly:
        range = DateTimeRange(
            start: range.start.add(const Duration(days: 7)),
            end: range.start.add(const Duration(days: 14)).subtract(const Duration(microseconds: 1)));
        break;
      case RangeType.custom:
        return;
    }

    notifyListeners();
  }

  void previousRange() {
    switch (rangeType) {
      case RangeType.monthly:
        range = DateTimeRange(
            start: range.start.copyWith(month: range.start.month - 1),
            end: range.start.copyWith(month: range.start.month).subtract(const Duration(microseconds: 1)));
        break;
      case RangeType.yearly:
        range = DateTimeRange(
            start: range.start.copyWith(year: range.start.year - 1),
            end: range.start.copyWith(year: range.start.year).subtract(const Duration(microseconds: 1)));
        break;
      case RangeType.daily:
        range = DateTimeRange(
            start: range.start.copyWith(day: range.start.day - 1),
            end: range.start.copyWith(day: range.start.day).subtract(const Duration(microseconds: 1)));
        break;
      case RangeType.weekly:
        range = DateTimeRange(
            start: range.start.subtract(const Duration(days: 7)),
            end: range.start.subtract(const Duration(microseconds: 1)));
        break;
      case RangeType.custom:
        return;
    }

    notifyListeners();
  }
}
