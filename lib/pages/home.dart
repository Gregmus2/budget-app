import 'package:fb/app.dart';
import 'package:fb/pages/accounts.dart';
import 'package:fb/pages/budget.dart';
import 'package:fb/pages/categories.dart';
import 'package:fb/pages/page.dart' as page;
import 'package:fb/pages/transactions/transactions.dart';
import 'package:fb/providers/state.dart';
import 'package:fb/ui/bottom_navigation.dart';
import 'package:fb/ui/drawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:home_widget/home_widget.dart';
import 'package:provider/provider.dart';

import '../quick_transaction.dart';
import '../ui/date_bar.dart';

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
    const CategoriesPage(),
    const BudgetPage(),
  ];

  @override
  Widget build(BuildContext context) {
    StateProvider stateProvider = Provider.of<StateProvider>(context, listen: false);
    ColorScheme colorScheme = Theme.of(context).colorScheme;

    // run quick transaction from home widget
    HomeWidget.widgetClicked.listen((event) {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const QuickTransaction()));
    });

    return App(
      builder: EasyLoading.init(),
      page: Scaffold(
          drawer: const BudgetDrawer(),
          appBar: _pages[pageIndex].ownAppBar()
              ? null
              : AppBar(
                  bottom: const DateBar(),
                  actions: _pages[pageIndex].getActions(context),
                ),
          body: IndexedStack(
            index: pageIndex,
            children: _pages,
          ),
          bottomNavigationBar: BottomNavigation(
            items: List.generate(
                _pages.length,
                (index) => NavigationDestination(
                    icon: Icon(_pages[index].getIcon(),
                        color: _pages[index].isDisabled(context) ? colorScheme.outline : null,
                    ),
                    label: _pages[index].getLabel())),
            pageIndex: pageIndex,
            onSelectTab: (int index) => setState(() {
              if (_pages[index] is BudgetPage && !stateProvider.isMonthlyRange) {
                return;
              }

              pageIndex = index;
            }),
          )),
    );
  }
}
