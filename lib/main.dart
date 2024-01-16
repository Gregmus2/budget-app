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
import 'package:money2/money2.dart';
import 'package:provider/provider.dart';

import 'app.dart';

// todo do refactoring to extract widgets and functions as much as possible (globally)

// todo Obfuscate Dart code as part of CI/CD and https://codewithandrea.com/articles/flutter-api-keys-dart-define-env-files/

// todo performance issues

Future<void> main() async {
  // todo download and add font with license https://github.com/material-foundation/flutter-packages/blob/main/packages/google_fonts/README.md#bundling-fonts-when-releasing
  /*LicenseRegistry.addLicense(() async* {
    final license = await rootBundle.loadString('google_fonts/OFL.txt');
    yield LicenseEntryWithLineBreaks(['google_fonts'], license);
  });*/

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
        symbol: 'د.إ', name: 'The United Arab Emirates dirham', country: 'The United Arab Emirate', unit: 'dirham'),
  ]);

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
  TransactionProvider transactionProvider = TransactionProvider(repo, accountProvider, stateProvider);
  BudgetProvider budgetProvider = BudgetProvider(repo);

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
