import 'package:fb/providers/account.dart';
import 'package:fb/providers/category.dart';
import 'package:fb/providers/state.dart';
import 'package:fb/ui/dialog_button.dart';
import 'package:fb/ui/drawer_card.dart';
import 'package:fb/utils/import.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BudgetDrawer extends StatelessWidget {
  const BudgetDrawer({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    StateProvider stateProvider = Provider.of<StateProvider>(context);
    CategoryProvider categoryProvider = Provider.of<CategoryProvider>(context);
    AccountProvider accountProvider = Provider.of<AccountProvider>(context);

    return Drawer(
      backgroundColor: theme.scaffoldBackgroundColor,
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: theme.colorScheme.primary,
            ),
            child: null,
          ),
          StringDrawerCard(
            name: "First day of month",
            value: stateProvider.firstDayOfMonth.toString(),
            icon: Icons.calendar_month,
            color: theme.colorScheme.primary,
            onPressed: () {
              // todo move
              showDialog<void>(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    backgroundColor: theme.scaffoldBackgroundColor,
                    content: StatefulBuilder(
                      builder: (BuildContext context, StateSetter setState) {
                        return SingleChildScrollView(
                          child: Column(
                            children: List<Widget>.generate(
                                30,
                                (index) => RadioListTile<int>(
                                      title: Text((index + 1).toString(),
                                          style: const TextStyle(color: Colors.white, fontSize: 18)),
                                      value: index + 1,
                                      groupValue: stateProvider.firstDayOfMonth,
                                      onChanged: (int? value) {
                                        setState(() {
                                          stateProvider.setFirstDayOfMonth(value!);

                                          Navigator.pop(context);
                                        });
                                      },
                                    )),
                          ),
                        );
                      },
                    ),
                  );
                },
              );
            },
          ),
          StringDrawerCard(
              name: "Import CSV",
              icon: Icons.upload,
              color: theme.colorScheme.primary,
              onPressed: () {
                FilePicker.platform.pickFiles().then((result) {
                  if (result == null) {
                    return;
                  }

                  DataImport(context).import(result.files.first);
                });
              }),
          StringDrawerCard(
              name: "Clean Data",
              icon: Icons.highlight_remove,
              color: theme.colorScheme.primary,
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text("Confirmation", style: TextStyle(color: Colors.white, fontSize: 18)),
                      content: const Text("Would you like to remove all the data?", style: TextStyle(color: Colors.white)),
                      actions: [
                        DialogButton(onPressed: () => Navigator.pop(context), color: Colors.red, text: "Cancel"),
                        DialogButton(
                          onPressed: () {
                            categoryProvider.deleteAll();
                            accountProvider.deleteAll();

                            Navigator.pop(context);
                          },
                          color: Colors.green,
                          text: "Confirm",
                        )
                      ],
                    );
                  },
                );
              }),
        ],
      ),
    );
  }
}
