import 'package:fb/db/category.dart';
import 'package:fb/ui/category_card.dart';
import 'package:flutter/material.dart';

class BudgetCard extends StatelessWidget {
  final Category category;
  final double spent;
  final double budget;
  final Function() onPressed;

  const BudgetCard(
      {super.key,
        required this.category,
        required this.spent,
        required this.budget,
        required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(child: TextButton(
            onPressed: onPressed,
            style: const ButtonStyle(
                alignment: AlignmentDirectional.centerStart,
                shape: MaterialStatePropertyAll(RoundedRectangleBorder()),
                padding: MaterialStatePropertyAll(
                    EdgeInsets.symmetric(vertical: 15, horizontal: 10))),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                CategoryCircle(progress: 100, primaryColor: category.color, icon: category.icon),
                const SizedBox(width: 10,),
                Expanded(
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(category.name, style: const TextStyle(color: Colors.white, fontSize: 18)),
                          Text("${budget - spent} ${category.currency.symbol}",
                              style: const TextStyle(color: Colors.red, fontSize: 18)),
                        ],
                      ),
                      const SizedBox(height: 5,),
                      LinearProgressIndicator(
                        value: budget/10000*spent, // todo fill math about current sum transactions for this category
                        color: category.color,
                        minHeight: 5,
                        backgroundColor: Colors.grey[800],
                      ),
                      const SizedBox(height: 5,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("$spent ${category.currency.symbol}",
                              style: TextStyle(color: category.color, fontSize: 14)),
                          Text("$budget ${category.currency.symbol}",
                              style: const TextStyle(color: Colors.grey, fontSize: 14)),
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