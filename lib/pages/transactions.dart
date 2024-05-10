import 'package:fb/models/account.dart';
import 'package:fb/models/category.dart';
import 'package:fb/models/transaction.dart';
import 'package:fb/models/transfer_target.dart';
import 'package:fb/pages/page.dart' as page;
import 'package:fb/providers/account.dart';
import 'package:fb/providers/category.dart';
import 'package:fb/providers/state.dart';
import 'package:fb/providers/transaction.dart';
import 'package:fb/ui/numpad.dart';
import 'package:flutter/material.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

// todo add search, sort, filter
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
    final TransactionProvider provider = Provider.of<TransactionProvider>(context, listen: false);
    final AccountProvider accountProvider = Provider.of<AccountProvider>(context);
    final CategoryProvider categoryProvider = Provider.of<CategoryProvider>(context);

    List<Widget> actions = [];
    if (accountProvider.items.isNotEmpty && categoryProvider.isNotEmpty()) {
      actions.add(
        IconButton(
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
                    // todo replace with default currency from user configuration
                    from: provider.getRecentFromTarget(),
                    to: provider.getRecentToTarget(),
                  ),
                ],
              ),
            );
          },
          icon: const Icon(Icons.add, color: Colors.white),
        ),
      );
    }

    return actions;
  }

  @override
  bool ownAppBar() => false;

  @override
  Icon getIcon(BuildContext _) {
    return const Icon(Icons.receipt, color: Colors.white);
  }

  @override
  String getLabel() {
    return 'Transactions';
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

    return PageView.builder(
      controller: _controller,
      itemBuilder: (context, index) {
        if (currentIndex == index) {
          return TransactionsGrid(items: provider.items);
        } else if (currentIndex > index) {
          return TransactionsGrid(items: provider.previousItems);
        } else {
          return TransactionsGrid(items: provider.nextItems);
        }
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
        currentIndex = index;
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
              color: Colors.white,
            ),
          ),
          textColor: Colors.white,
          title: Text(to.name + (parent != null ? " (${parent.name})" : ""), overflow: TextOverflow.ellipsis),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(from.icon, color: Colors.grey.shade400, size: 16),
                  Text(from.name, style: TextStyle(color: Colors.grey.shade400), overflow: TextOverflow.ellipsis),
                ],
              ),
              Text(transaction.note,
                  style: const TextStyle(fontSize: 14, color: Colors.grey), overflow: TextOverflow.ellipsis),
            ],
          ),
          trailing: Text("${transaction.amountFrom.toString()} ${from.currency.symbol}",
              style: TextStyle(color: transaction.fromAccount == null ? Colors.green : Colors.red, fontSize: 16),
              overflow: TextOverflow.ellipsis),
          contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
          shape: BorderDirectional(bottom: BorderSide(color: Colors.grey.withOpacity(0.2))),
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
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(text,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.grey.shade400,
            ),
            overflow: TextOverflow.ellipsis),
        const SizedBox(width: 5),
        Text(DateFormat(DateFormat.MONTH).format(date),
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey.shade400,
              fontWeight: FontWeight.bold,
            ),
            overflow: TextOverflow.ellipsis)
      ],
    );
  }
}
