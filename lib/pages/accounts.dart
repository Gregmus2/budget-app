import 'package:fb/db/account.dart';
import 'package:fb/pages/account_create.dart';
import 'package:fb/pages/page.dart' as page;
import 'package:fb/providers/account.dart';
import 'package:fb/ui/account_card.dart';
import 'package:fb/ui/context_menu.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AccountsPage extends StatelessWidget implements page.Page {
  const AccountsPage({super.key});

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
          ContextMenu.showMenu(
            context,
            [
              ContextMenuItem(
                title: "Delete",
                icon: Icons.delete,
                color: Colors.red,
                onPressed: () {
                  provider.remove(account);
                  Navigator.pop(context);
                },
              ),
              ContextMenuItem(
                title: "Balance",
                icon: Icons.balance,
                color: Colors.yellow,
                onPressed: () {
                  // todo
                  Navigator.pop(context);
                },
              ),
              ContextMenuItem(
                title: "Edit",
                icon: Icons.edit,
                color: Colors.yellow,
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => AccountCreatePage(
                                account: account,
                              )));
                },
              ),
              ContextMenuItem(
                title: "Recharge",
                icon: Icons.arrow_downward,
                color: Colors.green,
                onPressed: () {
                  // todo
                  Navigator.pop(context);
                },
              ),
              ContextMenuItem(
                title: "Withdraw",
                icon: Icons.arrow_upward,
                color: Colors.red,
                onPressed: () {
                  // todo
                  Navigator.pop(context);
                },
              ),
              ContextMenuItem(
                title: "Transfer",
                icon: Icons.arrow_forward,
                color: Colors.grey,
                onPressed: () {
                  // todo
                  Navigator.pop(context);
                },
              ),
            ],
          );
        }),
      ),
    );
  }

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
  Icon getIcon(BuildContext _) {
    return const Icon(Icons.account_balance_wallet, color: Colors.white);
  }

  @override
  String getLabel() {
    return 'Accounts';
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
          }));
}
