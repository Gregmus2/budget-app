import 'package:fb/db/account.dart';
import 'package:fb/ext/double.dart';
import 'package:flutter/material.dart';

class AccountCard extends StatelessWidget {
  final Account account;
  final Function()? onPressed;

  const AccountCard({super.key, required this.account, this.onPressed});

  @override
  Widget build(BuildContext context) {
    ColorScheme colorScheme = Theme.of(context).colorScheme;

    return InkWell(
      onTap: onPressed,
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(account.icon, color: account.color, size: 30),
                const SizedBox(width: 15),
                Text(account.name,
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                    overflow: TextOverflow.ellipsis),
              ],
            ),
            Text("${account.balance.toPrecision(2)} ${account.currency.symbol}",
                style: TextStyle(
                  color: account.balance >= 0 ? colorScheme.primary : colorScheme.error,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
                overflow: TextOverflow.ellipsis),
          ],
        ),
      ),
    );
  }
}
