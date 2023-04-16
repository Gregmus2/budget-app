import 'package:flutter/material.dart';
import 'package:money2/money2.dart';

class AccountCard extends StatelessWidget {
  final Color color;
  final String name;
  final double balance;
  final IconData icon;
  final Currency currency;
  final Function() onPressed;

  const AccountCard(
      {super.key,
      required this.color,
      required this.name,
      required this.balance,
      required this.icon,
      required this.currency,
      required this.onPressed});

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
                    padding: MaterialStatePropertyAll(
                        EdgeInsets.symmetric(vertical: 20, horizontal: 10))),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(icon, color: color, size: 40),
                        const SizedBox(width: 10,),
                        Text(name, style: const TextStyle(color: Colors.white, fontSize: 18)),
                      ],
                    ),
                    Text("${balance.toString()} ${currency.symbol}",
                        style: const TextStyle(color: Colors.green, fontSize: 18)),
                  ],
                ))),
      ],
    );
  }
}
