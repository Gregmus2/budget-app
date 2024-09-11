import 'package:fb/db/account.dart';
import 'package:fb/db/category.dart';
import 'package:fb/db/transaction.dart';
import 'package:fb/db/transfer_target.dart';
import 'package:fb/ext/string.dart';
import 'package:fb/pages/page.dart' as page;
import 'package:fb/pages/transactions/filter.dart';
import 'package:fb/pages/transactions/search.dart';
import 'package:fb/providers/account.dart';
import 'package:fb/providers/budget.dart';
import 'package:fb/providers/category.dart';
import 'package:fb/providers/state.dart';
import 'package:fb/providers/transaction.dart';
import 'package:fb/ui/numpad/transaction.dart';
import 'package:flutter/material.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class TransactionsPage extends StatelessWidget implements page.Page {
  const TransactionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: TransactionList(),
    );
  }

  @override
  List<Widget>? getActions(BuildContext context) {
    final AccountProvider accountProvider = Provider.of<AccountProvider>(context);
    final CategoryProvider categoryProvider = Provider.of<CategoryProvider>(context);

    List<Widget> actions = [const TransactionsSearchBar(), const TransactionFilterButton()];
    if (accountProvider.items.isNotEmpty && categoryProvider.isNotEmpty()) {
      actions.add(
        const AddTransactionButton(),
      );
    }

    return actions;
  }

  @override
  bool ownAppBar() => false;

  @override
  IconData getIcon() => Icons.receipt;

  @override
  String getLabel() {
    return 'Transactions';
  }

  @override
  bool isDisabled(BuildContext context) => false;
}

class AddTransactionButton extends StatelessWidget {
  const AddTransactionButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final TransactionProvider provider = Provider.of<TransactionProvider>(context, listen: false);

    return IconButton(
      onPressed: () {
        showModalBottomSheet(
          isScrollControlled: true,
          context: context,
          builder: (context) => Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TransactionNumPad(
                onDoneFunc: (value, date, from, to, note) {
                  provider.add(note, from, to, value, value, date);
                  Navigator.pop(context);
                },
                from: provider.getRecentFromTarget(),
                to: provider.getRecentToTarget(),
              ),
            ],
          ),
        );
      },
      icon: const Icon(Icons.add),
    );
  }
}

class TransactionList extends StatefulWidget {
  const TransactionList({
    super.key,
  });

  @override
  State<TransactionList> createState() => _TransactionListState();
}

const _initialPage = 365 * 100;

class _TransactionListState extends State<TransactionList> {
  final PageController _controller = PageController(initialPage: _initialPage);
  int currentIndex = _initialPage;

  @override
  Widget build(BuildContext context) {
    final TransactionProvider provider = Provider.of<TransactionProvider>(context);
    final StateProvider stateProvider = Provider.of<StateProvider>(context, listen: false);
    final BudgetProvider budgetProvider = Provider.of<BudgetProvider>(context, listen: false);

    return PageView.builder(
      controller: _controller,
      itemBuilder: (context, index) {
        Future<List<Transaction>> items = Future<List<Transaction>>.value(provider.items);
        if (currentIndex > index) {
          items = provider.previousItems;
        } else if (currentIndex < index) {
          items = provider.nextItems;
        }

        return FutureBuilder(
            future: items,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              List<Transaction>? dataItems = snapshot.data;
              if (provider.targetFilter.isNotEmpty) {
                final accountFilters = provider.targetFilter.whereType<Account>();
                if (accountFilters.isNotEmpty) {
                  dataItems = dataItems
                      ?.where((element) => accountFilters.any((filterElement) =>
                          (filterElement.id == element.fromAccount || filterElement.id == element.toAccount)))
                      .toList();
                }
                final categoryFilters = provider.targetFilter.whereType<Category>();
                if (categoryFilters.isNotEmpty) {
                  dataItems = dataItems
                      ?.where((element) => categoryFilters.any((filterElement) =>
                          (filterElement.id == element.fromCategory || filterElement.id == element.toCategory)))
                      .toList();
                }
              }

              if (provider.search != '') {
                dataItems = dataItems?.where((element) => element.note.containsIgnoreCase(provider.search)).toList();
              }

              return TransactionsGrid(items: dataItems!);
            });
      },
      onPageChanged: (index) {
        if (currentIndex == index) {
          return;
        } else if (currentIndex > index) {
          stateProvider.previousRange();
        } else {
          stateProvider.nextRange();
        }
        // to not cause page rebuild in this case
        provider.silentUpdateRange();
        budgetProvider.updateRange().then((value) => currentIndex = index);
      },
    );
  }
}

class TransactionsGrid extends StatelessWidget {
  const TransactionsGrid({
    super.key,
    required this.items,
  });

  final List<Transaction> items;

  @override
  Widget build(BuildContext context) {
    final TransactionProvider provider = Provider.of<TransactionProvider>(context, listen: false);
    final AccountProvider accountProvider = Provider.of<AccountProvider>(context, listen: false);
    final CategoryProvider categoryProvider = Provider.of<CategoryProvider>(context, listen: false);
    ColorScheme colorScheme = Theme.of(context).colorScheme;

    return GroupedListView<Transaction, String>(
      physics: const ScrollPhysics(),
      elements: items,
      groupBy: (element) => element.date.day.toString(),
      groupSeparatorBuilder: (String groupByValue) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        child: TransactionsSeparator(
          text: groupByValue.length == 1 ? "0$groupByValue" : groupByValue,
          date: items.first.date,
        ),
      ),
      itemBuilder: (context, Transaction transaction) {
        TransferTarget from;
        TransferTarget to;
        Category? parent;
        if (transaction.fromAccount != null) {
          from = accountProvider.getById(transaction.fromAccount!);
        } else {
          Category category = categoryProvider.getByID(transaction.fromCategory!);
          from = category;
          if (category.parent != null) {
            parent = categoryProvider.getByID(category.parent!);
          }
        }
        if (transaction.toAccount != null) {
          to = accountProvider.getById(transaction.toAccount!);
        } else {
          Category category = categoryProvider.getByID(transaction.toCategory!);
          to = category;
          if (category.parent != null) {
            parent = categoryProvider.getByID(category.parent!);
          }
        }

        return ListTile(
          onTap: () {
            showModalBottomSheet(
              isScrollControlled: true,
              context: context,
              builder: (context) => Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TransactionNumPad(
                    onDoneFunc: (value, date, from, to, note) {
                      transaction
                        ..amountFrom = value
                        ..amountTo = value
                        ..date = date
                        ..fromAccount = from is Account ? from.id : null
                        ..fromCategory = from is Category ? from.id : null
                        ..toAccount = to is Account ? to.id : null
                        ..toCategory = to is Category ? to.id : null
                        ..note = note;
                      provider.update(transaction);
                      Navigator.pop(context);
                    },
                    transaction: transaction,
                    from: from,
                    to: to,
                  ),
                ],
              ),
            );
          },
          leading: CircleAvatar(
            backgroundColor: to.color,
            child: Icon(
              to.icon,
                color: Colors.white
            ),
          ),
          textColor: colorScheme.onSurface,
          title: Text(to.name + (parent != null ? " (${parent.name})" : ""), overflow: TextOverflow.ellipsis),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(from.icon, color: colorScheme.onSurfaceVariant, size: 16),
                  const SizedBox(width: 3),
                  Text(from.name, style: TextStyle(color: colorScheme.onSurfaceVariant), overflow: TextOverflow.ellipsis),
                ],
              ),
              Text(transaction.note, style: TextStyle(color: colorScheme.outline), overflow: TextOverflow.ellipsis),
            ],
          ),
          trailing: Text("${transaction.amountFrom.toString()} ${from.currency.symbol}",
              style: TextStyle(color: transaction.fromAccount == null ? Colors.green : colorScheme.error, fontSize: 16),
              overflow: TextOverflow.ellipsis),
          contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
        );
      },
      order: GroupedListOrder.DESC,
      sort: false,
    );
  }
}

class TransactionsSeparator extends StatelessWidget {
  const TransactionsSeparator({
    super.key,
    required this.date,
    required this.text,
  });

  final DateTime date;
  final String text;

  @override
  Widget build(BuildContext context) {
    ColorScheme colorScheme = Theme.of(context).colorScheme;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(text,
            style: TextStyle(
              height: 1,
              fontSize: 25,
              fontWeight: FontWeight.bold,
              color: colorScheme.onSurfaceVariant,
            ),
            overflow: TextOverflow.ellipsis),
        const SizedBox(width: 3),
        Text(DateFormat(DateFormat.MONTH).format(date),
            style: TextStyle(
              height: 1.3,
              fontSize: 16,
              color: colorScheme.onSurfaceVariant,
            ),
            overflow: TextOverflow.ellipsis)
      ],
    );
  }
}
