import 'package:fb/pages/account_create.dart';
import 'package:fb/providers/account.dart';
import 'package:fb/ui/account_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reorderable_grid_view/reorderable_grid_view.dart';

class AccountsPage extends StatelessWidget {
  const AccountsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final AccountProvider provider = Provider.of<AccountProvider>(context);

    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const AccountCreatePage()));
              },
              icon: const Icon(Icons.add))
        ],
      ),
      body: ReorderableGridView.builder(
        dragWidgetBuilder: (index, child) => Scaffold(
          backgroundColor: Colors.transparent,
          body: child,
        ),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 10,
            mainAxisSpacing: 16,
            mainAxisExtent: 120),
        itemBuilder: (context, index) => GestureDetector(
          key: ValueKey(index),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => AccountCreatePage(
                        account: provider.get(index),
                      )),
            );
          },
          child: AccountCard(
              key: ValueKey(index),
              color: provider.get(index).color,
              name: provider.get(index).name,
              balance: provider.get(index).balance,
              icon: provider.get(index).icon,
              currency: provider.get(index).currency),
        ),
        itemCount: provider.length,
        onReorder: (oldIndex, newIndex) => provider.reOrder(oldIndex, newIndex),
      ),
    );
  }
}
