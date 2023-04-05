import 'package:flutter/material.dart';
import 'package:money2/money2.dart';

class AccountCard extends StatelessWidget {
  final Color color;
  final String name;
  final double balance;
  final IconData icon;
  final Currency currency;

  const AccountCard(
      {super.key,
      required this.color,
      required this.name,
      required this.balance,
      required this.icon,
      required this.currency});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 50,
          height: 40,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4),
            color: color,
            border: Border.all(color: Colors.white.withOpacity(0.5)),
          ),
          child: Icon(icon, color: Colors.white),
        ),
        const SizedBox(height: 10),
        Text(name, style: const TextStyle(color: Colors.white)),
        const SizedBox(height: 4),
        Text("${balance.toString()} ${currency.symbol}",
            style: const TextStyle(color: Colors.green)),
      ],
    );
  }
}
