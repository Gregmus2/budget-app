import 'dart:collection';

import 'package:fb/db/transfer_target.dart';
import 'package:flutter/material.dart';

class EntityNameTextInput extends StatelessWidget {
  const EntityNameTextInput({
    super.key,
    required TextEditingController nameInput,
    required this.items,
  }) : _nameInput = nameInput;

  final TextEditingController _nameInput;
  final UnmodifiableListView<TransferTarget> items;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: _nameInput,
      decoration: const InputDecoration(
        hintText: 'Name',
      ),
      style: const TextStyle(color: Colors.white),
      validator: (String? value) {
        if (value == null || value.isEmpty) {
          return 'Please enter some text';
        }
        if (items.any((element) => element.name == value)) {
          return 'Entity with this name already exists';
        }

        return null;
      },
    );
  }
}