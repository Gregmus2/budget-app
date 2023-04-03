import 'package:fb/pages/account_create.dart';
import 'package:flutter/material.dart';

class AccountsPage extends StatelessWidget {
  const AccountsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => AccountCreatePage()));
              },
              icon: const Icon(Icons.add))
        ],
      ),
      body: const Center(
        child: Text('Accounts'),
      ),
    );
  }
}
