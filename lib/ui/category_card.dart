import 'package:fb/db/category.dart';
import 'package:fb/models.dart';
import 'package:fb/providers/category.dart';
import 'package:flutter/material.dart';
import 'package:money2/money2.dart';
import 'package:provider/provider.dart';
import 'dart:math' as math;

List<Widget> buildCategoryCards(
    BuildContext context, Function(Category) onPressed) {
  List<CategoryStat> categoriesStat = [];
  final CategoryProvider provider = Provider.of<CategoryProvider>(context);
  final math.Random random = math.Random();

  // todo remove mock data
  for (var i = 0; i < provider.length; i++) {
    double total = random.nextDouble() * 1000;
    categoriesStat.add(CategoryStat(
        provider.get(i),
        total - random.nextDouble() * total,
        total,
        provider.get(i).currency.symbol));
  }

  return List.generate(
      provider.length,
      (index) => CategoryCard(
            key: ValueKey(index),
            color: categoriesStat[index].category.color,
            name: categoriesStat[index].category.name,
            left: categoriesStat[index].left,
            total: categoriesStat[index].total,
            icon: categoriesStat[index].category.icon,
            currency: categoriesStat[index].category.currency,
            onPressed: () {
              onPressed(categoriesStat[index].category);
            },
            progress:
                100 * categoriesStat[index].left / categoriesStat[index].total,
          ));
}

class CategoryCard extends StatelessWidget {
  final double progress;
  final Color color;
  final String name;
  final double left;
  final double total;
  final IconData icon;
  final Currency currency;
  final Function()? onPressed;

  CategoryCard(
      {super.key,
      required this.progress,
      required this.color,
      required this.name,
      required this.left,
      required this.total,
      required this.icon,
      required this.currency,
      this.onPressed}) {
    assert(progress >= 0 && progress <= 100);
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
            "${left.toStringAsFixed(2)} ${currency.symbol}",
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
          Text("${total.toStringAsFixed(2)} ${currency.symbol}",
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
