import 'package:fb/providers/account.dart';
import 'package:fb/providers/budget.dart';
import 'package:fb/providers/category.dart';
import 'package:fb/providers/state.dart';
import 'package:fb/providers/transaction.dart';
import 'package:fb/ui/dialog_button.dart';
import 'package:fb/ui/drawer_card.dart';
import 'package:fb/utils/import.dart';
import 'package:fb/utils/sign_in.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
      backgroundColor: colorScheme.surface,
      child: Column(
        children: [
          Expanded(
            child: ListView(
              children: [
                DrawerHeader(
                  decoration: BoxDecoration(
                    color: colorScheme.primary,
                  ),
                  child: null,
                ),
                StringDrawerCard(
                    name: stateProvider.user == null ? "Sign In" : "Sign Out",
                    value: stateProvider.user?.displayName,
                    icon: Icons.account_circle,
                    color: colorScheme.primary,
                    onPressed: () {
                      if (stateProvider.user != null) {
                        FirebaseAuth.instance.signOut();
                        stateProvider.user = null;
                        return;
                      }

                      signInWithGoogle().then((user) {
                        stateProvider.user = user.user;
                      });
                    }),
                const Divider(),
                StringDrawerCard(
                  name: "First day of month",
                  value: stateProvider.firstDayOfMonth.toString(),
                  icon: Icons.calendar_month,
                  color: colorScheme.primary,
                  onPressed: () {
                    showDialog<void>(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          backgroundColor: colorScheme.surface,
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
                                                budgetProvider.updateRange().then((value) => Navigator.pop(context));
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
                const Divider(),
                const ListTile(
                  title: Text("Data", style: TextStyle(fontWeight: FontWeight.bold)), // Section header
                  dense: true, // Make the header compact
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
                            title: const Text("Confirmation", style: TextStyle(fontSize: 18)),
                            content: const Text("Would you like to remove all the data?"),
                            actions: [
                              DialogButton(onPressed: () => Navigator.pop(context), text: "Cancel"),
                              DialogButton(
                                onPressed: () {
                                  categoryProvider.deleteAll();
                                  accountProvider.deleteAll();
                                  budgetProvider.deleteAll();
                                  transactionProvider.deleteAll();

                                  Navigator.pop(context);
                                },
                                text: "Confirm",
                              )
                            ],
                          );
                        },
                      );
                    }),
                StringDrawerCard(
                    name: "Clean Transactions",
                    icon: Icons.highlight_remove,
                    color: colorScheme.primary,
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text("Confirmation", style: TextStyle(fontSize: 18)),
                            content: const Text("Would you like to remove all transactions?"),
                            actions: [
                              DialogButton(onPressed: () => Navigator.pop(context), text: "Cancel"),
                              DialogButton(
                                onPressed: () {
                                  transactionProvider.deleteAll();

                                  Navigator.pop(context);
                                },
                                text: "Confirm",
                              )
                            ],
                          );
                        },
                      );
                    })
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(16.0),
            child: SegmentedButton<ThemeMode>(
              showSelectedIcon: false,
              segments: const <ButtonSegment<ThemeMode>>[
                ButtonSegment<ThemeMode>(value: ThemeMode.system, icon: Icon(Icons.hdr_auto)),
                ButtonSegment<ThemeMode>(value: ThemeMode.light, icon: Icon(Icons.light_mode)),
                ButtonSegment<ThemeMode>(value: ThemeMode.dark, icon: Icon(Icons.dark_mode)),
              ],
              selected: <ThemeMode>{stateProvider.themeMode},
              onSelectionChanged: (Set<ThemeMode> newSelection) {
                stateProvider.setThemeMode(newSelection.first);
              },
            ),
          ),
        ],
      ),
    );
  }
}
