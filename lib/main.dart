import 'dart:async';
import 'dart:io';

import 'package:fb/config.dart';
import 'package:fb/db/repository.dart';
import 'package:fb/providers/account.dart';
import 'package:fb/providers/budget.dart';
import 'package:fb/providers/category.dart';
import 'package:fb/providers/state.dart';
import 'package:fb/providers/transaction.dart';
import 'package:fb/quick_transaction.dart';
import 'package:flutter/material.dart';
import 'package:home_widget/home_widget.dart';
import 'package:http/io_client.dart';
import 'package:provider/provider.dart';
import 'package:realm/realm.dart' as realm;

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
  final realmApp = realm.App(realm.AppConfiguration(GlobalConfig().realmAppID, httpClient: IOClient(HttpClient())));
  app = const App();

  StateProvider stateProvider = StateProvider(realmApp);
  Repository repo = Repository(stateProvider);
  CategoryProvider categoryProvider = CategoryProvider(repo);
  AccountProvider accountProvider = AccountProvider(repo);
  TransactionProvider transactionProvider = TransactionProvider(repo, accountProvider, categoryProvider, stateProvider);
  BudgetProvider budgetProvider = BudgetProvider(repo, stateProvider);

  await stateProvider.init();
  if (realmApp.currentUser != null) {
    await repo.init(realmApp.currentUser!);
    await Future.wait([
      categoryProvider.init(),
      accountProvider.init(),
      transactionProvider.init(),
      budgetProvider.init(),
    ]);
  } else {
    app = const App();
  }

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
