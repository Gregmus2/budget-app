import 'package:fb/utils/currency.dart';
import 'package:flutter/material.dart';

abstract class TransferTarget {
  final String id;
  String name;
  IconData icon;
  Color color;
  Currency currency;

  TransferTarget(this.id, this.name, this.icon, this.color, this.currency);
}
