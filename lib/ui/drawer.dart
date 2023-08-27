import 'package:fb/providers/state.dart';
import 'package:fb/ui/drawer_card.dart';
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
        ],
      ),
    );
  }
}
