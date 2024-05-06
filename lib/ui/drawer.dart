import 'package:fb/providers/account.dart';
import 'package:fb/providers/budget.dart';
import 'package:fb/providers/category.dart';
import 'package:fb/providers/state.dart';
import 'package:fb/providers/transaction.dart';
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
    ColorScheme colorScheme = Theme.of(context).colorScheme;
    StateProvider stateProvider = Provider.of<StateProvider>(context);
    CategoryProvider categoryProvider = Provider.of<CategoryProvider>(context, listen: false);
    AccountProvider accountProvider = Provider.of<AccountProvider>(context, listen: false);
    TransactionProvider transactionProvider = Provider.of<TransactionProvider>(context, listen: false);
    BudgetProvider budgetProvider = Provider.of<BudgetProvider>(context, listen: false);

    return Drawer(
      backgroundColor: colorScheme.background,
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: colorScheme.primary,
            ),
            child: null,
          ),
          // todo add automatic archive of old accounts and categories
          StringDrawerCard(
              name: "Sign Out",
              value: stateProvider.user?.profile.name,
              icon: Icons.account_circle,
              color: colorScheme.primary,
              onPressed: () {
                stateProvider.user!.logOut();
                // it will notify app page about that to rebuild body with LoginPage
                stateProvider.user = null;
              }),
          StringDrawerCard(
            name: "First day of month",
            value: stateProvider.firstDayOfMonth.toString(),
            icon: Icons.calendar_month,
            color: colorScheme.primary,
            onPressed: () {
              // todo move
              showDialog<void>(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    backgroundColor: colorScheme.background,
                    content: StatefulBuilder(
                      builder: (BuildContext context, StateSetter setState) {
                        return SingleChildScrollView(
                          child: Column(
                            children: List<Widget>.generate(
                                30,
                                (index) => RadioListTile<int>(
                                      title: Text((index + 1).toString()),
                                      value: index + 1,
                                      groupValue: stateProvider.firstDayOfMonth,
                                      onChanged: (int? value) {
                                        setState(() {
                                          stateProvider.setFirstDayOfMonth(value!);
                                          transactionProvider.updateRange();

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
              name: "Import Accounts",
              icon: Icons.upload,
              color: colorScheme.primary,
              onPressed: () {
                FilePicker.platform.pickFiles().then((result) {
                  if (result == null) {
                    return;
                  }

                  DataImport(context).importAccounts(result.files.first);
                });
              }),
          StringDrawerCard(
              name: "Import Transactions",
              icon: Icons.upload,
              color: colorScheme.primary,
              onPressed: () {
                FilePicker.platform.pickFiles().then((result) {
                  if (result == null) {
                    return;
                  }

                  DataImport(context).importTransactions(result.files.first);
                });
              }),
          StringDrawerCard(
              name: "Clean Data",
              icon: Icons.highlight_remove,
              color: colorScheme.primary,
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text("Confirmation", style: TextStyle(color: Colors.white, fontSize: 18)),
                      content:
                          const Text("Would you like to remove all the data?", style: TextStyle(color: Colors.white)),
                      actions: [
                        DialogButton(onPressed: () => Navigator.pop(context), color: Colors.red, text: "Cancel"),
                        DialogButton(
                          onPressed: () {
                            categoryProvider.deleteAll();
                            accountProvider.deleteAll();
                            budgetProvider.deleteAll();
                            transactionProvider.deleteAll();

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
