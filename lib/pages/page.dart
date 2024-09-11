import 'package:flutter/material.dart';

abstract class Page extends Widget {
  const Page({super.key});

  List<Widget>? getActions(BuildContext context) => null;

  bool ownAppBar() => false;

  Icon getIcon(BuildContext context) => const Icon(Icons.not_interested);

  String getLabel() => "";
}
