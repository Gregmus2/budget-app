import 'package:fb/providers/transaction.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TransactionsSearchBar extends StatelessWidget {
  const TransactionsSearchBar({super.key});

  @override
  Widget build(BuildContext context) {
    TransactionProvider provider = Provider.of<TransactionProvider>(context, listen: false);

    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.6,
      height: 40,
      child: SearchBar(
        hintText: 'Search transactions',
        onChanged: (value) {
          provider.search = value;
        },
      ),
    );
  }
}
