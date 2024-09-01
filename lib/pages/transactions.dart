import 'package:fb/db/account.dart';
import 'package:fb/db/category.dart';
import 'package:fb/db/transaction.dart';
import 'package:fb/db/transfer_target.dart';
import 'package:fb/pages/page.dart' as page;
import 'package:fb/providers/account.dart';
import 'package:fb/providers/budget.dart';
import 'package:fb/providers/category.dart';
import 'package:fb/providers/state.dart';
import 'package:fb/providers/transaction.dart';
import 'package:fb/ui/account_card.dart';
import 'package:fb/ui/category_card.dart';
import 'package:fb/ui/numpad.dart';
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

    List<Widget> actions = [const TransactionFilterButton()];
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
  Icon getIcon(BuildContext _) {
    return const Icon(Icons.receipt, color: Colors.white);
  }

  @override
  String getLabel() {
    return 'Transactions';
  }
}

class TransactionFilterButton extends StatelessWidget {
  const TransactionFilterButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final TransactionProvider provider = Provider.of<TransactionProvider>(context, listen: false);

    return IconButton(
        onPressed: () {
          showGeneralDialog(
            context: context,
            barrierLabel: "Barrier",
            barrierDismissible: true,
            pageBuilder: (context, animation, secondaryAnimation) {
              return Center(
                child: Container(
                  color: Theme.of(context).colorScheme.background,
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  height: MediaQuery.of(context).size.height * 0.8,
                  // todo add filter by notes, sort
                  child: TargetFilter(
                      filters: provider.targetFilter,
                      onUpdate: (target) {
                        provider.filterByTargets(target);

                        Navigator.pop(context);
                      }),
                ),
              );
            },
          );
        },
        icon: const Icon(Icons.filter_alt_rounded));
  }
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
                // todo handle categories and accounts with the same id
                dataItems = dataItems
                    ?.where((element) =>
                        provider.targetFilter.any((filterElement) => filterElement.id == element.fromAccount) ||
                        provider.targetFilter.any((filterElement) => filterElement.id == element.fromCategory) ||
                        provider.targetFilter.any((filterElement) => filterElement.id == element.toAccount) ||
                        provider.targetFilter.any((filterElement) => filterElement.id == element.toCategory))
                    .toList();
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
              Text(transaction.note, style: const TextStyle(color: Colors.grey), overflow: TextOverflow.ellipsis),
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
              height: 1,
              fontSize: 25,
              fontWeight: FontWeight.bold,
              color: Colors.grey.shade400,
            ),
            overflow: TextOverflow.ellipsis),
        const SizedBox(width: 3),
        Text(DateFormat(DateFormat.MONTH).format(date),
            style: TextStyle(
              height: 1.3,
              fontSize: 16,
              color: Colors.grey.shade400,
            ),
            overflow: TextOverflow.ellipsis)
      ],
    );
  }
}

class TargetFilter extends StatefulWidget {
  final Function(Set<TransferTarget>) onUpdate;
  final Set<TransferTarget> filters;

  const TargetFilter({super.key, required this.onUpdate, required this.filters});

  @override
  State<TargetFilter> createState() => _TargetFilterState();
}

class _TargetFilterState extends State<TargetFilter> {
  bool _isAccount = true;
  late Set<TransferTarget> filters;

  @override
  void initState() {
    filters = widget.filters;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final AccountProvider accountProvider = Provider.of<AccountProvider>(context);
    final CategoryProvider categoryProvider = Provider.of<CategoryProvider>(context);

    return Column(
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            TextButton(
                onPressed: () => setState(() {
                      _isAccount = true;
                    }),
                child: Text(
                  'Accounts',
                  style: TextStyle(fontSize: 15, color: _isAccount ? null : Colors.grey),
                )),
            const SizedBox(width: 20),
            TextButton(
                onPressed: () => setState(() {
                      _isAccount = false;
                    }),
                child: Text('Categories', style: TextStyle(fontSize: 15, color: _isAccount ? Colors.grey : null))),
          ],
        ),
        Flexible(
          child: SingleChildScrollView(
            child: _isAccount
                ? ListView(
                    shrinkWrap: true,
                    physics: const ScrollPhysics(),
                    children: List.generate(accountProvider.length, (index) {
                      Account account = accountProvider.get(index)!;

                      return FilterChip(
                        padding: const EdgeInsets.all(0),
                        label: AccountCard(key: ValueKey(index), account: account),
                        showCheckmark: false,
                        side: const BorderSide(width: 0, color: Colors.transparent),
                        shape: const RoundedRectangleBorder(),
                        selected: filters.contains(account),
                        onSelected: (bool selected) {
                          setState(() {
                            if (selected) {
                              filters.add(account);
                            } else {
                              filters.remove(account);
                            }
                          });
                        },
                      );
                    }))
                : GridView.count(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    crossAxisCount: 4,
                    childAspectRatio: 0.7,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 16,
                    shrinkWrap: true,
                    physics: const ScrollPhysics(),
                    children: categoryProvider
                        .getCategories()
                        .map((category) => FilterChip(
                              padding: const EdgeInsets.all(0),
                              showCheckmark: false,
                              side: const BorderSide(width: 0, color: Colors.transparent),
                              label: CategoryCard(key: ValueKey(category.id), category: category),
                              selected: filters.contains(category),
                              onSelected: (bool selected) {
                                setState(() {
                                  if (selected) {
                                    filters.add(category);
                                  } else {
                                    filters.remove(category);
                                  }
                                });
                              },
                            ))
                        .toList()),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    filters.clear();
                  });

                  widget.onUpdate(filters);
                },
                style: ButtonStyle(
                  backgroundColor: WidgetStateProperty.all(Theme.of(context).colorScheme.error),
                ),
                child: Text(
                  'Reset',
                  style: TextStyle(color: Theme.of(context).colorScheme.onPrimary),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  widget.onUpdate(filters);
                },
                style: ButtonStyle(
                  backgroundColor: WidgetStateProperty.all(Theme.of(context).colorScheme.onPrimary),
                ),
                child: const Text('Apply'),
              ),
            ],
          ),
        )
      ],
    );
  }
}
