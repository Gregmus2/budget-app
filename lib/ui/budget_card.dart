import 'package:fb/db/category.dart';
import 'package:fb/providers/transaction.dart';
import 'package:fb/ui/category_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BudgetCard extends StatelessWidget {
  final Category category;
  final double budget;
  final Function() onPressed;

  const BudgetCard({super.key, required this.category, required this.budget, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    TransactionProvider transactionProvider = Provider.of<TransactionProvider>(context);
    final double spent = transactionProvider.getRangeExpenses(category.id);
    final double left = budget - spent;
    ColorScheme colorScheme = Theme.of(context).colorScheme;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
            child: TextButton(
                onPressed: onPressed,
                style: const ButtonStyle(
                    alignment: AlignmentDirectional.centerStart,
                    shape: WidgetStatePropertyAll(RoundedRectangleBorder()),
                    padding: WidgetStatePropertyAll(EdgeInsets.symmetric(vertical: 15, horizontal: 10))),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    CategoryIcon(category: category),
                    const SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(category.name,
                                  style: const TextStyle(fontSize: 18),
                                  overflow: TextOverflow.ellipsis),
                              Text("${left.toStringAsFixed(2)} ${category.currency.symbol}",
                                  style: TextStyle(color: left < 0 ? colorScheme.error : colorScheme.primary, fontSize: 18),
                                  overflow: TextOverflow.ellipsis),
                            ],
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          LinearProgressIndicator(
                            value: spent / budget,
                            color: category.color,
                            minHeight: 5,
                            backgroundColor: colorScheme.surfaceDim,
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("$spent ${category.currency.symbol}",
                                  style: TextStyle(color: category.color, fontSize: 14),
                                  overflow: TextOverflow.ellipsis),
                              Text("$budget ${category.currency.symbol}",
                                  style: TextStyle(color: colorScheme.secondary, fontSize: 14),
                                  overflow: TextOverflow.ellipsis),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ))),
      ],
    );
  }
}
// CategoryCircle(progress: 100, primaryColor: category.color, icon: category.icon),
