import 'package:fb/bottom_navigation.dart';
import 'package:fb/pages/accounts.dart';
import 'package:fb/pages/categories.dart';
import 'package:fb/pages/transactions.dart';
import 'package:fb/providers/account.dart';
import 'package:fb/providers/budget.dart';
import 'package:fb/providers/category.dart';
import 'package:fb/db/repository.dart';
import 'package:fb/providers/transaction.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Repository repo = Repository();
  await repo.init();

  CategoryProvider catProvider = CategoryProvider(repo);
  AccountProvider accountProvider = AccountProvider(repo);
  TransactionProvider transactionProvider = TransactionProvider(repo);
  BudgetProvider budgetProvider = BudgetProvider(repo);
  await catProvider.init();
  await accountProvider.init();
  await transactionProvider.init();
  await budgetProvider.init();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => catProvider),
        ChangeNotifierProvider(create: (context) => accountProvider),
        ChangeNotifierProvider(create: (context) => transactionProvider),
        ChangeNotifierProvider(create: (context) => budgetProvider),
      ],
      child: const App(),
    ),
  );
}

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  int pageIndex = 1;
  final List<Widget> _pages = [
    const AccountsPage(),
    const TransactionsPage(),
    const CategoriesTab(),
  ];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gregmus Budget',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: const Color.fromRGBO(42, 45, 66, 1.0),
        appBarTheme: const AppBarTheme(backgroundColor: Colors.blue, foregroundColor: Colors.blue),
        colorScheme: const ColorScheme.dark(
          primary: Colors.blue,
        ),
        textTheme: GoogleFonts.latoTextTheme(
          Theme.of(context).textTheme,
        ),
      ),
      home: Scaffold(
          body: IndexedStack(
            index: pageIndex,
            children: _pages,
          ),
          bottomNavigationBar: BottomNavigation(
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.account_balance_wallet, color: Colors.white),
                label: 'Accounts',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.receipt, color: Colors.white),
                label: 'Transactions',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.list, color: Colors.white),
                label: 'Categories',
              ),
            ],
            pageIndex: pageIndex,
            onSelectTab: (int index) => setState(() => pageIndex = index),
          )),
    );
  }
}
