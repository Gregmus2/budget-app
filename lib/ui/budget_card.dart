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
                    EdgeInsets.symmetric(vertical: 20, horizontal: 10))),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                CategoryCircle(progress: 100, primaryColor: category.color, icon: category.icon),
                SizedBox(width: 10,),
                Expanded(
                  child: LinearProgressIndicator(
                    value: budget, // todo fill math about current sum transactions for this category
                    color: category.color,
                  ),
                ),
              ],
            ))),
      ],
    );
  }
}
// CategoryCircle(progress: 100, primaryColor: category.color, icon: category.icon),