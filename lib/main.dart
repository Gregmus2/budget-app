import 'dart:async';

import 'package:fb/db/repository.dart';
import 'package:fb/quick_transaction.dart';
import 'package:fb/providers/account.dart';
import 'package:fb/providers/budget.dart';
import 'package:fb/providers/category.dart';
import 'package:fb/providers/state.dart';
import 'package:fb/providers/transaction.dart';
import 'package:flutter/material.dart';
import 'package:home_widget/home_widget.dart';
import 'package:money2/money2.dart';
import 'package:provider/provider.dart';

import 'app.dart';

// todo do refactoring to extract widgets and functions as much as possible (globally)

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Currencies().registerList(<Currency>[
    Currency.create('UAH', 2,
        symbol: '₴',
        invertSeparators: true,
        name: 'Ukrainian Hryvnia',
        country: 'Ukraine',
        pattern: 'S0.00',
        unit: 'hryvnia'),
    Currency.create('AED', 2,
        symbol: 'د.إ',
        name: 'The United Arab Emirates dirham',
        country: 'The United Arab Emirate',
        unit: 'dirham'),
  ]);

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
  TransactionProvider transactionProvider = TransactionProvider(repo, accountProvider);
  BudgetProvider budgetProvider = BudgetProvider(repo);
  StateProvider stateProvider = StateProvider(transactionProvider);
  await Future.wait([
    catProvider.init(),
    accountProvider.init(),
    transactionProvider.init(),
    budgetProvider.init(),
    stateProvider.init(),
  ]);

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
