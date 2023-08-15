import 'package:fb/db/category.dart';
import 'package:fb/models.dart';
import 'package:fb/providers/budget.dart';
import 'package:fb/providers/category.dart';
import 'package:fb/providers/state.dart';
import 'package:fb/providers/transaction.dart';
import 'package:flutter/material.dart';
import 'package:money2/money2.dart';
import 'package:provider/provider.dart';
import 'dart:math' as math;

List<Widget> buildCategoryCards(
    BuildContext context, Function(Category) onPressed,
    {List<int> exclude = const []}) {
  List<CategoryStat> categoriesStat = [];
  final CategoryProvider provider = Provider.of<CategoryProvider>(context);
  final TransactionProvider transactionProvider =
      Provider.of<TransactionProvider>(context);
  final StateProvider stateProvider = Provider.of<StateProvider>(context);
  final BudgetProvider budgetProvider = Provider.of<BudgetProvider>(context);
  Map<int, double> totals = transactionProvider.getMonthlyExpense(
      stateProvider.month, stateProvider.year);

  for (var i = 0; i < provider.length; i++) {
    if (exclude.contains(provider.get(i).id)) {
      continue;
    }

    double? budget = budgetProvider.getBudgetAmount(
        provider.get(i).id, stateProvider.month, stateProvider.year);
    categoriesStat.add(CategoryStat(
        provider.get(i),
        totals[provider.get(i).id] ?? 0,
        budget,
        provider.get(i).currency.symbol));
  }

  return List.generate(
      categoriesStat.length,
      (index) => CategoryCard(
            key: ValueKey(index),
            color: categoriesStat[index].category.color,
            name: categoriesStat[index].category.name,
            spent: categoriesStat[index].spent,
            total: categoriesStat[index].total,
            icon: categoriesStat[index].category.icon,
            currency: categoriesStat[index].category.currency,
            onPressed: () {
              onPressed(categoriesStat[index].category);
            },
            progress: categoriesStat[index].total == null ||
                    categoriesStat[index].spent > categoriesStat[index].total!
                ? 100
                : 100 *
                    categoriesStat[index].spent /
                    categoriesStat[index].total!,
          ));
}

class CategoryCard extends StatelessWidget {
  final double progress;
  final Color color;
  final String name;
  final double spent;
  final double? total;
  final IconData icon;
  final Currency currency;
  final Function()? onPressed;

  CategoryCard(
      {super.key,
      required this.progress,
      required this.color,
      required this.name,
      required this.spent,
      required this.total,
      required this.icon,
      required this.currency,
      this.onPressed}) {
    assert(progress >= 0 && progress <= 100);
    assert(spent >= 0);
    assert(total == null || total! >= 0);
  }

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: ButtonStyle(
        padding: MaterialStateProperty.all(const EdgeInsets.all(0)),
      ),
      onPressed: onPressed,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(name,
              style: const TextStyle(
                color: Colors.white,
              )),
          const SizedBox(
            height: 4,
          ),
          Text(
            "${(total != null ? total! - spent : 0).toStringAsFixed(2)} ${currency.symbol}",
            style: TextStyle(
              color: color.withOpacity(0.5),
            ),
          ),
          const SizedBox(
            height: 4,
          ),
          CategoryCircle(progress: progress, primaryColor: color, icon: icon),
          const SizedBox(
            height: 4,
          ),
          Text("${spent.toStringAsFixed(2)} ${currency.symbol}",
              style: TextStyle(color: color)),
        ],
      ),
    );
  }
}

class CategoryCircle extends StatelessWidget {
  final double diameter;
  final double progress;
  final Color primaryColor;
  final IconData icon;

  const CategoryCircle(
      {super.key,
      this.diameter = 50,
      required this.progress,
      required this.primaryColor,
      required this.icon});

  @override
  Widget build(BuildContext context) {
    double iconSize = diameter / 2.2;

    return CircleAvatar(
      maxRadius: diameter / 2,
      backgroundColor: primaryColor.withOpacity(0.5),
      child: CustomPaint(
        painter: ProgressCirclePainter(
            progress: 100, color: primaryColor, stroke: true),
        child: CustomPaint(
          painter:
              ProgressCirclePainter(progress: progress, color: primaryColor),
          child: Padding(
            padding: EdgeInsets.all((diameter - iconSize) / 2),
            child: Icon(icon, size: iconSize, color: Colors.white),
          ),
        ),
      ),
    );
  }
}

class ProgressCirclePainter extends CustomPainter {
  final double progress;
  final Color color;
  final bool stroke;

  const ProgressCirclePainter(
      {super.repaint,
      required this.progress,
      required this.color,
      this.stroke = false});

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()..color = color;
    if (stroke) {
      paint.style = PaintingStyle.stroke;
      paint.strokeWidth = 1;
    }

    canvas.drawArc(
      Rect.fromCenter(
        center: Offset(size.height / 2, size.width / 2),
        height: size.height,
        width: size.width,
      ),
      // 90 to -90 start angle
      (90 - progress * 1.8) * math.pi / 180,
      // 0 to 360 sweep angle
      progress * 3.6 * math.pi / 180,
      false,
      paint,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
