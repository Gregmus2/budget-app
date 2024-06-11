import 'package:fb/providers/account.dart';
import 'package:fb/providers/budget.dart';
import 'package:fb/providers/category.dart';
import 'package:fb/providers/state.dart';
import 'package:fb/providers/transaction.dart';
import 'package:fb/utils/sign_in.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:realm/realm.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Login'),
        ),
        body: Center(
          child: IconButton(
              onPressed: () {
                _signIn(context);
              },
              icon: const Icon(Icons.login)),
        ));
  }
}

Future<void> _signIn(BuildContext context) async {
  StateProvider stateProvider = Provider.of<StateProvider>(context, listen: false);
  TransactionProvider transactionProvider = Provider.of<TransactionProvider>(context, listen: false);
  BudgetProvider budgetProvider = Provider.of<BudgetProvider>(context, listen: false);
  CategoryProvider categoryProvider = Provider.of<CategoryProvider>(context, listen: false);
  AccountProvider accountProvider = Provider.of<AccountProvider>(context, listen: false);

  User user = await signInWithGoogle(stateProvider.app);
  await transactionProvider.repo.init(user);
  await Future.wait([
    categoryProvider.init(),
    accountProvider.init(),
    transactionProvider.init(),
    budgetProvider.init(),
  ]);

  // after user updates in state provider, it notify app page about that to rebuild body with HomePage
  stateProvider.user = user;
}
