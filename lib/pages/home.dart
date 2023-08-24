import 'package:fb/bottom_navigation.dart';
import 'package:fb/pages/accounts.dart';
import 'package:fb/pages/budget.dart';
import 'package:fb/pages/categories.dart';
import 'package:fb/pages/transactions.dart';
import 'package:flutter/material.dart';
import 'package:home_widget/home_widget.dart';
import 'package:fb/pages/page.dart' as page;

import '../ui/date_bar.dart';
import 'quick_transaction.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int pageIndex = 1;
  final List<page.Page> _pages = [
    const AccountsPage(),
    const TransactionsPage(),
    const CategoriesTab(),
    const BudgetPage(),
  ];

  @override
  Widget build(BuildContext context) {
    HomeWidget.widgetClicked.listen((event) {
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (context) => const QuickTransaction()));
    });

    return Scaffold(
        appBar: !_pages[pageIndex].ownAppBar()
            ? AppBar(
          bottom: const DateBar(),
                actions: _pages[pageIndex].getActions(context),
                foregroundColor: Colors.white,
              )
            : null,
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
            BottomNavigationBarItem(
              icon: Icon(Icons.savings, color: Colors.white),
              label: 'Budget',
            ),
          ],
          pageIndex: pageIndex,
          onSelectTab: (int index) => setState(() => pageIndex = index),
        ));
  }
}
