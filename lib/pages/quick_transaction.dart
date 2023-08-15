import 'package:fb/providers/account.dart';
import 'package:fb/providers/category.dart';
import 'package:fb/providers/transaction.dart';
import 'package:fb/ui/numpad.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:money2/money2.dart';
import 'package:provider/provider.dart';

class QuickTransaction extends StatefulWidget {
  const QuickTransaction({super.key});

  @override
  State<QuickTransaction> createState() => _QuickTransactionState();
}

class _QuickTransactionState extends State<QuickTransaction> {
  @override
  Widget build(BuildContext context) {
    final AccountProvider accountProvider =
        Provider.of<AccountProvider>(context);
    final CategoryProvider categoryProvider =
        Provider.of<CategoryProvider>(context);
    final TransactionProvider transactionProvider =
        Provider.of<TransactionProvider>(context);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Gregmus Budget',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: const Color.fromRGBO(42, 45, 66, 1.0),
        appBarTheme: const AppBarTheme(
            backgroundColor: Colors.blue, foregroundColor: Colors.blue),
        colorScheme: const ColorScheme.dark(
          primary: Colors.blue,
        ),
        textTheme: GoogleFonts.latoTextTheme(
          Theme.of(context).textTheme,
        ),
      ),
      home: Scaffold(
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            TransactionNumPad(
              from: accountProvider.get(0),
              to: categoryProvider.get(0),
              currency: CommonCurrencies().euro,
              onDoneFunc: (value, date, from, to, note) {
                transactionProvider.add(note, from, to, value, value, date);

                SystemNavigator.pop();
              },
            ),
          ],
        ),
      ),
    );
  }
}
