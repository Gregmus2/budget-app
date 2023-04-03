import 'package:flutter/material.dart';

class AccountCard extends StatelessWidget {
  final Color color;
  final String name;
  final double balance;
  final IconData icon;

  const AccountCard({super.key, required this.color, required this.name, required this.balance, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: color,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(name, style: const TextStyle(color: Colors.white)),
          const SizedBox(height: 4),
          Text(balance.toString(), style: TextStyle(color: color.withOpacity(0.5))),
          const SizedBox(height: 4),
          Icon(icon, color: Colors.white),
        ],
      ),
    );
  }
}