import 'package:flutter/material.dart';

enum RangeType { daily, weekly, monthly, yearly, custom }

DateTimeRange getPreviousRange(DateTimeRange range, RangeType type) {
  switch (type) {
    case RangeType.monthly:
      return DateTimeRange(
          start: range.start.copyWith(month: range.start.month - 1),
          end: range.start.copyWith(month: range.start.month).subtract(const Duration(microseconds: 1)));
    case RangeType.yearly:
      return DateTimeRange(
          start: range.start.copyWith(year: range.start.year - 1),
          end: range.start.copyWith(year: range.start.year).subtract(const Duration(microseconds: 1)));
    case RangeType.daily:
      return DateTimeRange(
          start: range.start.copyWith(day: range.start.day - 1),
          end: range.start.copyWith(day: range.start.day).subtract(const Duration(microseconds: 1)));
    case RangeType.weekly:
      return DateTimeRange(
          start: range.start.subtract(const Duration(days: 7)),
          end: range.start.subtract(const Duration(microseconds: 1)));
    default:
      return range;
  }
}

DateTimeRange getNextRange(DateTimeRange range, RangeType type) {
  switch (type) {
    case RangeType.monthly:
      return DateTimeRange(
          start: range.start.copyWith(month: range.start.month + 1),
          end: range.start.copyWith(month: range.start.month + 2).subtract(const Duration(microseconds: 1)));
    case RangeType.yearly:
      return DateTimeRange(
          start: range.start.copyWith(year: range.start.year + 1),
          end: range.start.copyWith(year: range.start.year + 2).subtract(const Duration(microseconds: 1)));
    case RangeType.daily:
      return DateTimeRange(
          start: range.start.copyWith(day: range.start.day + 1),
          end: range.start.copyWith(day: range.start.day + 2).subtract(const Duration(microseconds: 1)));
    case RangeType.weekly:
      return DateTimeRange(
          start: range.start.add(const Duration(days: 7)),
          end: range.start.add(const Duration(days: 14)).subtract(const Duration(microseconds: 1)));
    default:
      return range;
  }
}
