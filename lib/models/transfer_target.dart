import 'package:flutter/material.dart';
import 'package:money2/money2.dart';
import 'package:uuid/v5.dart';

abstract class TransferTarget {
  final String id;
  String name;
  IconData icon;
  Color color;
  Currency currency;

  TransferTarget(this.id, this.name, this.icon, this.color, this.currency);
}
