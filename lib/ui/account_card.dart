import 'package:fb/db/account.dart';
import 'package:fb/ext/double.dart';
import 'package:flutter/material.dart';

class AccountCard extends StatelessWidget {
  final Account account;
  final Function()? onPressed;

  const AccountCard({super.key, required this.account, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Card(
      // Wrap with a Card widget for visual separation
      margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10), // Add some margin
      elevation: 2, // Add a subtle shadow
      shape: RoundedRectangleBorder(
        // Slightly round the corners
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: InkWell(
        // Make the entire card tappable
        onTap: onPressed,
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(account.icon, color: account.color, size: 30), // Slightly smaller icon
                  const SizedBox(width: 15),
                  Text(account.name,
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500), // Slightly bolder font
                      overflow: TextOverflow.ellipsis),
                ],
              ),
              Text("${account.balance.toPrecision(2)} ${account.currency.symbol}",
                  style: TextStyle(
                    color: account.balance >= 0 ? Colors.green : Colors.red,
                    fontSize: 16,
                    fontWeight: FontWeight.w500, // Slightly bolder font
                  ),
                  overflow: TextOverflow.ellipsis),
            ],
          ),
        ),
      ),
    );
  }
}
