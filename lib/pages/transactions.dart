import 'dart:math' as math;

import 'package:fb/db/account.dart';
import 'package:fb/db/category.dart';
import 'package:fb/db/transaction.dart';
import 'package:fb/db/transfer_target.dart';
import 'package:fb/pages/page.dart' as page;
import 'package:fb/providers/account.dart';
import 'package:fb/providers/category.dart';
import 'package:fb/providers/transaction.dart';
import 'package:fb/ui/context_menu.dart';
import 'package:fb/ui/numpad.dart';
import 'package:flutter/material.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class TransactionsPage extends StatelessWidget implements page.Page {
  const TransactionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final TransactionProvider provider = Provider.of<TransactionProvider>(context);
    final AccountProvider accountProvider = Provider.of<AccountProvider>(context);
    final CategoryProvider categoryProvider = Provider.of<CategoryProvider>(context);

    return Scaffold(
      body: GroupedListView<Transaction, String>(
        elements: provider.items,
        groupBy: (element) => element.date.day.toString(),
        groupSeparatorBuilder: (String groupByValue) => Padding(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(groupByValue.length == 1 ? "0$groupByValue" : groupByValue,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey.shade400,
                  ),
                  overflow: TextOverflow.ellipsis),
              const SizedBox(width: 5),
              Text(DateFormat(DateFormat.MONTH).format(provider.items.first.date),
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey.shade400,
                    fontWeight: FontWeight.bold,
                  ),
                  overflow: TextOverflow.ellipsis)
            ],
          ),
        ),
        itemBuilder: (context, Transaction transaction) {
          TransferTarget from;
          TransferTarget to;
          Category? parent;
          if (transaction.fromAccount != null) {
            from = accountProvider.getById(transaction.fromAccount!);
          } else {
            Category category = categoryProvider.getById(transaction.fromCategory!);
            from = category;
            if (category.parent != null) {
              parent = categoryProvider.getById(category.parent!);
            }
          }
          if (transaction.toAccount != null) {
            to = accountProvider.getById(transaction.toAccount!);
          } else {
            Category category = categoryProvider.getById(transaction.toCategory!);
            to = category;
            if (category.parent != null) {
              parent = categoryProvider.getById(category.parent!);
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
                style: TextStyle(color: transaction.fromAccount == null ? Colors.green : Colors.red),
                overflow: TextOverflow.ellipsis),
            contentPadding: const EdgeInsets.symmetric(vertical: 3, horizontal: 16),
            shape: BorderDirectional(bottom: BorderSide(color: Colors.grey.withOpacity(0.2))),
          );
        },
        order: GroupedListOrder.DESC,
        sort: false,
      ),
    );
  }

  @override
  List<Widget>? getActions(BuildContext context) {
    final TransactionProvider provider = Provider.of<TransactionProvider>(context);
    final AccountProvider accountProvider = Provider.of<AccountProvider>(context);
    final CategoryProvider categoryProvider = Provider.of<CategoryProvider>(context);

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
                    onDoneFunc: (value, date, from, to, note) {
                      provider.add(note, from, to, value, value, date);
                      Navigator.pop(context);
                    },
                    // todo replace with default currency from user configuration
                    from: accountProvider.items.last,
                    to: categoryProvider.items.where((element) => element.parent == null).first,
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
