import 'package:flutter/material.dart';
import 'package:money2/money2.dart';

abstract class TransferTarget {
  final int id;
  String name;
  IconData icon;
  Color color;
  Currency currency;

  TransferTarget(this.id, this.name, this.icon, this.color, this.currency);
}
