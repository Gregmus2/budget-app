import 'package:fb/db/account.dart';
import 'package:flutter/material.dart';

class AccountCard extends StatelessWidget {
  final Account account;
  final Function() onPressed;

  const AccountCard({super.key, required this.account, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
            child: TextButton(
                onPressed: onPressed,
                style: const ButtonStyle(
                    alignment: AlignmentDirectional.centerStart,
                    shape: MaterialStatePropertyAll(RoundedRectangleBorder()),
                    padding: MaterialStatePropertyAll(EdgeInsets.symmetric(vertical: 20, horizontal: 10))),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(account.icon, color: account.color, size: 40),
                        const SizedBox(
                          width: 10,
                        ),
                        Text(account.name, style: const TextStyle(color: Colors.white, fontSize: 18)),
                      ],
                    ),
                    Text("${account.balance.toString()} ${account.currency.symbol}",
                        style: TextStyle(color: account.balance >= 0 ? Colors.green : Colors.red, fontSize: 18)),
                  ],
                ))),
      ],
    );
  }
}
