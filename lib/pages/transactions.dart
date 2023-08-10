import 'package:fb/db/account.dart';
import 'package:fb/db/transaction.dart';
import 'package:fb/db/transfer_target.dart';
import 'package:fb/providers/account.dart';
import 'package:fb/providers/category.dart';
import 'package:fb/providers/transaction.dart';
import 'package:flutter/material.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:intl/intl.dart';
import 'package:money2/money2.dart';
import 'package:provider/provider.dart';
import 'dart:math' as math;

import '../ui/numpad.dart';

class TransactionsPage extends StatelessWidget {
  const TransactionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final TransactionProvider provider =
        Provider.of<TransactionProvider>(context);
    final AccountProvider accountProvider =
        Provider.of<AccountProvider>(context);
    final CategoryProvider categoryProvider =
        Provider.of<CategoryProvider>(context);

    List<Widget> actions = [];
    if (accountProvider.items.isNotEmpty && categoryProvider.items.isNotEmpty) {
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
                    currency: CommonCurrencies().euro,
                    onDoneFunc: (value, date, from, to, note) {
                      provider.add(note, from, to, value, value, date);
                      Navigator.pop(context);
                    },
                    // todo replace with default currency from user configuration
                    from: accountProvider.items.last,
                    to: categoryProvider.items.last,
                  ),
                ],
              ),
            );
          },
          icon: const Icon(Icons.add, color: Colors.white),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        actions: actions,
        foregroundColor: Colors.white,
      ),
      body: GroupedListView<Transaction, String>(
        elements: provider.items,
        groupBy: (element) => element.date.day.toString(),
        groupSeparatorBuilder: (String groupByValue) => Padding(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                groupByValue.length == 1 ? "0$groupByValue" : groupByValue,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey.shade400,
                ),
              ),
              const SizedBox(width: 5),
              Text(
                DateFormat(DateFormat.MONTH).format(provider.items.first.date),
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey.shade400,
                  fontWeight: FontWeight.bold,
                ),
              )
            ],
          ),
        ),
        itemBuilder: (context, Transaction transaction) {
          Account from = accountProvider.getById(transaction.from);
          TransferTarget to;
          if (transaction.toAccount != null) {
            to = accountProvider.getById(transaction.toAccount!);
          } else {
            to = categoryProvider.getById(transaction.toCategory!);
          }

          return ListTile(
            leading: CircleAvatar(
              backgroundColor: to.color,
              child: Icon(
                to.icon,
                color: Colors.white,
              ),
            ),
            textColor: Colors.white,
            title: Text(to.name),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(from.icon, color: Colors.grey.shade400, size: 16),
                    Text(from.name,
                        style: TextStyle(color: Colors.grey.shade400)),
                  ],
                ),
                Text(
                  transaction.note,
                  style: const TextStyle(fontSize: 14, color: Colors.grey),
                ),
              ],
            ),
            trailing: Text(
              "${transaction.amountFrom.toString()} ${from.currency.symbol}",
              style: TextStyle(
                  color:
                      transaction.amountFrom < 0 ? Colors.green : Colors.red),
            ),
            contentPadding:
                const EdgeInsets.symmetric(vertical: 3, horizontal: 16),
            shape: BorderDirectional(
                bottom: BorderSide(color: Colors.grey.withOpacity(0.2))),
          );
        },
        order: GroupedListOrder.ASC,
      ),
    );
  }
}

class ProgressCirclePainter extends CustomPainter {
  final Color color;

  const ProgressCirclePainter({super.repaint, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()..color = color;
    paint.style = PaintingStyle.stroke;
    paint.strokeWidth = 1;

    canvas.drawArc(
      Rect.fromCenter(
        center: Offset(size.height / 2, size.width / 2),
        height: size.height,
        width: size.width,
      ),
      // 90 to -90 start angle
      (90 - 100 * 1.8) * math.pi / 180,
      // 0 to 360 sweep angle
      100 * 3.6 * math.pi / 180,
      false,
      paint,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
