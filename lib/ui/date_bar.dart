import 'package:fb/providers/budget.dart';
import 'package:fb/providers/state.dart';
import 'package:fb/providers/transaction.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class DateBar extends StatefulWidget implements PreferredSizeWidget {
  const DateBar({super.key});

  @override
  State<DateBar> createState() => _DateBarState();

  @override
  Size get preferredSize => const Size.fromHeight(40);
}

class _DateBarState extends State<DateBar> {
  @override
  Widget build(BuildContext context) {
    final StateProvider stateProvider = Provider.of<StateProvider>(context);
    final TransactionProvider transactionProvider = Provider.of<TransactionProvider>(context, listen: false);
    final BudgetProvider budgetProvider = Provider.of<BudgetProvider>(context, listen: false);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          onPressed: () {
            stateProvider.previousRange();
            transactionProvider.updateRange();
            budgetProvider.updateRange();
          },
          icon: Icon(Icons.arrow_back_ios, color: !stateProvider.isCustomRange ? Colors.white : Colors.grey),
        ),
        Text(
            "${DateFormat("dd MMM yyyy").format(stateProvider.range.start)} - ${DateFormat("dd MMM yyyy").format(stateProvider.range.end)}",
            style: const TextStyle(color: Colors.white)),
        IconButton(
          onPressed: () {
            stateProvider.nextRange();
            transactionProvider.updateRange();
          },
          icon: Icon(Icons.arrow_forward_ios, color: !stateProvider.isCustomRange ? Colors.white : Colors.grey),
        ),
      ],
    );
  }
}
