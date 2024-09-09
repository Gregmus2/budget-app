import 'package:fb/common/theme_data.dart';
import 'package:fb/providers/transaction.dart';
import 'package:fb/ui/numpad.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class QuickTransaction extends StatefulWidget {
  const QuickTransaction({super.key});

  @override
  State<QuickTransaction> createState() => _QuickTransactionState();
}

class _QuickTransactionState extends State<QuickTransaction> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Gregmus Budget',
      theme: getThemeData(context),
      home: _buildQuickTransactionView(context),
    );
  }

  Scaffold _buildQuickTransactionView(BuildContext context) {
    final TransactionProvider transactionProvider = Provider.of<TransactionProvider>(context, listen: false);

    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          TransactionNumPad(
            from: transactionProvider.getRecentFromTarget(),
            to: transactionProvider.getRecentToTarget(),
            onDoneFunc: (value, date, from, to, note) {
              transactionProvider.add(note, from, to, value, value, date);

              SystemNavigator.pop();
            },
          ),
        ],
      ),
    );
  }
}
