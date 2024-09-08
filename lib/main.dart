import 'dart:async';

import 'package:fb/db/repository.dart';
import 'package:fb/firebase_options.dart';
import 'package:fb/providers/account.dart';
import 'package:fb/providers/budget.dart';
import 'package:fb/providers/category.dart';
import 'package:fb/providers/state.dart';
import 'package:fb/providers/transaction.dart';
import 'package:fb/quick_transaction.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:home_widget/home_widget.dart';
import 'package:provider/provider.dart';

import 'app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  HomeWidget.initiallyLaunchedFromHomeWidget().then((value) {
    if (value != null) {
      _runApp(const QuickTransaction());
    } else {
      _runApp(const App());
    }
  });
}

Future<void> _runApp(Widget app) async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  StateProvider stateProvider = StateProvider();
  Repository repo = Repository();
  CategoryProvider categoryProvider = CategoryProvider(repo);
  AccountProvider accountProvider = AccountProvider(repo);
  TransactionProvider transactionProvider = TransactionProvider(repo, accountProvider, categoryProvider, stateProvider);
  BudgetProvider budgetProvider = BudgetProvider(repo, stateProvider);

  await stateProvider.init();
  await repo.init();
  await Future.wait([
    categoryProvider.init(),
    accountProvider.init(),
    transactionProvider.init(),
    budgetProvider.init(),
  ]);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => categoryProvider),
        ChangeNotifierProvider(create: (context) => accountProvider),
        ChangeNotifierProvider(create: (context) => transactionProvider),
        ChangeNotifierProvider(create: (context) => budgetProvider),
        ChangeNotifierProvider(create: (context) => stateProvider),
      ],
      child: app,
    ),
  );
}
