import 'dart:math' as math;

import 'package:fb/models/category.dart';
import 'package:fb/providers/budget.dart';
import 'package:fb/providers/state.dart';
import 'package:fb/providers/transaction.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CategoryCard extends StatelessWidget {
  final Category category;
  final Function()? onPressed;

  const CategoryCard({super.key, required this.category, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: ButtonStyle(
        padding: WidgetStateProperty.all(const EdgeInsets.all(0)),
      ),
      onPressed: onPressed,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(category.name,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: Colors.white,
              )),
          CategoryWithProgress(
            category: category,
            // optimization purpose
            preRenderedIcon: CategoryIcon(category: category),
          )
        ],
      ),
    );
  }
}

class CategoryIcon extends StatelessWidget {
  const CategoryIcon({
    super.key,
    required this.category,
  });

  final Category category;

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: diameter / 2,
      backgroundColor: category.color.withOpacity(0.5),
      child: Icon(category.icon, size: diameter / 2.2, color: Colors.white),
    );
  }
}

class CategoryWithProgress extends StatelessWidget {
  final Category category;
  final Widget preRenderedIcon;

  const CategoryWithProgress({super.key, required this.category, required this.preRenderedIcon});

  @override
  Widget build(BuildContext context) {
    final StateProvider stateProvider = Provider.of<StateProvider>(context);
    final TransactionProvider transactionProvider = Provider.of<TransactionProvider>(context);
    final BudgetProvider budgetProvider = Provider.of<BudgetProvider>(context);

    double spent = transactionProvider.getRangeExpenses(category.id);
    double? total;
    // budgeting works only with standard monthly ranges
    if (stateProvider.isMonthlyRange) {
      total =
          budgetProvider.getBudgetAmount(category.id, stateProvider.range.start.month, stateProvider.range.start.year);
    }
    double progress = (total == null || spent > total) ? 100 : (100 * spent / total);

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "${(total != null ? total - spent : 0).toStringAsFixed(2)} ${category.currency.symbol}",
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            color: Color(category.color.value).withOpacity(0.5),
          ),
        ),
        const SizedBox(
          height: 4,
        ),
        Stack(children: [
          ProgressCircle(progress: progress, primaryColor: category.color),
          preRenderedIcon,
        ]),
        const SizedBox(
          height: 4,
        ),
        Text(
          "${spent.toStringAsFixed(2)} ${category.currency.symbol}",
          style: TextStyle(color: category.color),
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}

const double diameter = 50;

class ProgressCircle extends StatelessWidget {
  final double progress;
  final Color primaryColor;

  const ProgressCircle({super.key, required this.progress, required this.primaryColor});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: ProgressCirclePainter(progress: progress, color: primaryColor),
      foregroundPainter: ProgressCirclePainter(progress: 100, color: primaryColor, stroke: true),
      child: const SizedBox(
        height: diameter,
        width: diameter,
      ),
    );
  }
}

class ProgressCirclePainter extends CustomPainter {
  final double progress;
  final Color color;
  final bool stroke;

  const ProgressCirclePainter({super.repaint, required this.progress, required this.color, this.stroke = false});

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
