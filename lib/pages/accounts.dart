import 'package:fb/db/account.dart';
import 'package:fb/pages/account_create.dart';
import 'package:fb/pages/page.dart' as page;
import 'package:fb/providers/account.dart';
import 'package:fb/ui/account_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AccountsPage extends StatelessWidget implements page.Page {
  const AccountsPage({super.key});

  @override
  List<Widget>? getActions(BuildContext context) => [
        IconButton(
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => const AccountCreatePage()));
            },
            icon: const Icon(Icons.add, color: Colors.white))
      ];

  @override
  bool ownAppBar() => false;

  @override
  Widget build(BuildContext context) {
    final AccountProvider provider = Provider.of<AccountProvider>(context);

    return Scaffold(
      body: ReorderableListView(
        /*dragWidgetBuilder: (index, child) => Scaffold(
          backgroundColor: Colors.transparent,
          body: child,
        ),*/
        footer: const Divider(
          color: Colors.grey,
        ),
        onReorder: (oldIndex, newIndex) => provider.reOrder(oldIndex, newIndex),
        children: buildAccountCards(context, (account) {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => AccountCreatePage(
                        account: account,
                      )));
        }),
      ),
    );
  }
}

List<Widget> buildAccountCards(BuildContext context, Function(Account) onPressed) {
  final AccountProvider provider = Provider.of<AccountProvider>(context);

  return List.generate(
      provider.length,
      (index) => AccountCard(
            key: ValueKey(index),
            account: provider.get(index),
            onPressed: () {
              onPressed(provider.get(index));
            },
          ));
}
