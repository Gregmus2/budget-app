import 'package:fb/providers/transaction.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

const firstDayOfMonthKey = 'firstDayOfMonth';

enum RangeType { daily, weekly, monthly, yearly, custom }

class StateProvider extends ChangeNotifier {
  late DateTimeRange range;
  RangeType rangeType = RangeType.monthly;
  int firstDayOfMonth = 1;
  final TransactionProvider transactionProvider;
  late SharedPreferences prefs;

  StateProvider(this.transactionProvider);

  Future<void> init() async {
    prefs = await SharedPreferences.getInstance();
    int? firstDayOfMonth = prefs.getInt(firstDayOfMonthKey);
    if (firstDayOfMonth == null) {
      await prefs.setInt(firstDayOfMonthKey, this.firstDayOfMonth);
    } else {
      this.firstDayOfMonth = firstDayOfMonth;
    }

    final now = DateTime.now();
    final start = DateTime(now.year, now.month, this.firstDayOfMonth);
    range = _buildMonthlyRange(start);
  }

  bool get isMonthlyRange => rangeType == RangeType.monthly;

  bool get isCustomRange => rangeType == RangeType.custom;

  void setFirstDayOfMonth(int day) {
    firstDayOfMonth = day;
    prefs.setInt(firstDayOfMonthKey, firstDayOfMonth);
    if (rangeType == RangeType.monthly) {
      final start = range.start.copyWith(day: firstDayOfMonth);
      range = _buildMonthlyRange(start);
      update();
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
    update();
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
    update();
  }

  void update() {
    transactionProvider.updateRange(range);
    notifyListeners();
  }
}
