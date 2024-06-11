import 'package:fb/models/account.dart';
import 'package:fb/pages/account_create.dart';
import 'package:fb/pages/page.dart' as page;
import 'package:fb/providers/account.dart';
import 'package:fb/providers/transaction.dart';
import 'package:fb/ui/account_card.dart';
import 'package:fb/ui/context_menu.dart';
import 'package:fb/ui/drawer.dart';
import 'package:fb/ui/numpad.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AccountsPage extends StatelessWidget implements page.Page {
  const AccountsPage({super.key});

  @override
  List<Widget>? getActions(BuildContext context) => null;

  @override
  bool ownAppBar() => true;

  @override
  Icon getIcon(BuildContext _) {
    return const Icon(Icons.account_balance_wallet, color: Colors.white);
  }

  @override
  String getLabel() {
    return 'Accounts';
  }

  @override
  Widget build(BuildContext context) {
    final AccountProvider provider = Provider.of<AccountProvider>(context);

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        drawer: const BudgetDrawer(),
        appBar: AppBar(
          actions: [
            IconButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const AccountCreatePage()));
                },
                icon: const Icon(Icons.add, color: Colors.white))
          ],
          bottom: const TabBar(
            tabs: [
              Tab(icon: Text("Regular")),
              Tab(icon: Text("Debt")),
              Tab(icon: Text("Archived")),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            SingleChildScrollView(
                child: Column(children: [
              AccountTab(accounts: provider.getAccounts(archived: false, type: AccountType.regular)),
              Text("Savings",
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey.shade400,
                  ),
                  overflow: TextOverflow.ellipsis),
              AccountTab(accounts: provider.getAccounts(archived: false, type: AccountType.savings)),
            ])),
            AccountTab(accounts: provider.getAccounts(archived: false, type: AccountType.debt)),
            AccountTab(accounts: provider.getAccounts(archived: true)),
          ],
        ),
      ),
    );
  }
}

class AccountTab extends StatelessWidget {
  final List<Account> accounts;

  const AccountTab({super.key, required this.accounts});

  @override
  Widget build(BuildContext context) {
    AccountProvider provider = Provider.of<AccountProvider>(context);

    return ReorderableListView(
      shrinkWrap: true,
      /*dragWidgetBuilder: (index, child) => Scaffold(
              backgroundColor: Colors.transparent,
              body: child,
            ),*/
      physics: const ScrollPhysics(),
      footer: const Divider(
        color: Colors.grey,
      ),
      onReorder: (oldIndex, newIndex) => provider.reOrder(oldIndex, newIndex),
      children: List.generate(accounts.length, (index) {
        Account? account = accounts[index];

        return AccountCard(
            key: ValueKey(index),
            account: account,
            onPressed: () {
              _showAccountContextMenu(context, account);
            });
      }),
    );
  }

  _showAccountContextMenu(BuildContext context, Account account) {
    AccountProvider provider = Provider.of<AccountProvider>(context, listen: false);
    TransactionProvider transactionProvider = Provider.of<TransactionProvider>(context, listen: false);

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
            Navigator.pop(context);
            showModalBottomSheet(
              context: context,
              builder: (context) => SimpleNumPad(
                number: account.balance,
                currency: account.currency,
                onDone: (value) {
                  provider.addBalance(account, value - account.balance);

                  Navigator.pop(context);
                },
              ),
            );
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
            Navigator.pop(context);
            showModalBottomSheet(
              context: context,
              builder: (context) => TransactionNumPad(
                onDoneFunc: (value, date, from, to, note) {
                  transactionProvider.add(note, from, to, value, value, date);
                  Navigator.pop(context);
                },
                from: transactionProvider.getRecentFromTarget(),
                to: account,
              ),
            );
          },
        ),
        ContextMenuItem(
          title: "Withdraw",
          icon: Icons.arrow_upward,
          color: Colors.red,
          onPressed: () {
            Navigator.pop(context);
            showModalBottomSheet(
              context: context,
              builder: (context) => TransactionNumPad(
                onDoneFunc: (value, date, from, to, note) {
                  transactionProvider.add(note, from, to, value, value, date);
                  Navigator.pop(context);
                },
                from: account,
                to: transactionProvider.getRecentToTarget(),
              ),
            );
          },
        ),
        ContextMenuItem(
          title: "Transfer",
          icon: Icons.arrow_forward,
          color: Colors.grey,
          onPressed: () {
            Navigator.pop(context);
            showModalBottomSheet(
              context: context,
              builder: (context) => TransactionNumPad(
                onDoneFunc: (value, date, from, to, note) {
                  transactionProvider.add(note, from, to, value, value, date);
                  Navigator.pop(context);
                },
                from: account,
                // todo replace with recently used
                to: provider.items.last,
              ),
            );
          },
        ),
      ],
    );
  }
}
