import 'package:fb/db/account.dart';
import 'package:fb/db/transfer_target.dart';
import 'package:fb/providers/account.dart';
import 'package:fb/providers/category.dart';
import 'package:fb/providers/transaction.dart';
import 'package:fb/ui/account_card.dart';
import 'package:fb/ui/category_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
                  child: TargetFilter(
                      filters: provider.targetFilter,
                      onUpdate: (target) {
                        provider.targetFilter = target;

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

class TargetFilter extends StatefulWidget {
  final Function(Set<TransferTarget>) onUpdate;
  final Set<TransferTarget> filters;

  const TargetFilter({super.key, required this.onUpdate, required this.filters});

  @override
  State<TargetFilter> createState() => _TargetFilterState();
}

class _TargetFilterState extends State<TargetFilter> with TickerProviderStateMixin {
  late Set<TransferTarget> filters;
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();

    filters = widget.filters;
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final AccountProvider accountProvider = Provider.of<AccountProvider>(context);
    final CategoryProvider categoryProvider = Provider.of<CategoryProvider>(context);

    return Column(
      children: [
        TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Accounts'),
            Tab(text: 'Categories'),
          ],
        ),
        Flexible(
          child: TabBarView(controller: _tabController, children: <Widget>[
            ListView(
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
                })),
            GridView.count(
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
                    .toList())
          ]),
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
