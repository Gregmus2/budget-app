import 'dart:async';

import 'package:fb/pages/quick_transaction.dart';
import 'package:fb/providers/account.dart';
import 'package:fb/providers/budget.dart';
import 'package:fb/providers/category.dart';
import 'package:fb/db/repository.dart';
import 'package:fb/providers/state.dart';
import 'package:fb/providers/transaction.dart';
import 'package:flutter/material.dart';
import 'package:home_widget/home_widget.dart';
import 'package:provider/provider.dart';

import 'app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  HomeWidget.initiallyLaunchedFromHomeWidget().then((value) {
    if (value != null) {
      _runApp(const QuickTransaction(), false);
    } else {
      _runApp(const App(), true);
    }
  });
}

Future<void> _runApp(Widget app, bool main) async {
  Repository repo = Repository();
  await repo.init();

  CategoryProvider catProvider = CategoryProvider(repo);
  AccountProvider accountProvider = AccountProvider(repo);
  TransactionProvider transactionProvider = TransactionProvider(repo);
  BudgetProvider budgetProvider = BudgetProvider(repo);
  StateProvider stateProvider = StateProvider(transactionProvider);
  await catProvider.init();
  await accountProvider.init();
  await transactionProvider.init();
  await budgetProvider.init();
  await stateProvider.init();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => catProvider),
        ChangeNotifierProvider(create: (context) => accountProvider),
        ChangeNotifierProvider(create: (context) => transactionProvider),
        ChangeNotifierProvider(create: (context) => budgetProvider),
        ChangeNotifierProvider(create: (context) => stateProvider),
      ],
      child: app,
    ),
  );
}
