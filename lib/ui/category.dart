import 'package:flutter/material.dart';
import 'dart:math' as math;

class CategoryCard extends StatelessWidget {
  final double progress;
  final Color color;
  final String category;
  final String left;
  final String total;
  final IconData icon;

  const CategoryCard(
      {super.key,
      required this.progress,
      required this.color,
      required this.category,
      this.left = '',
      this.total = '', required this.icon});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(category,
            style: const TextStyle(
              color: Colors.white,
            )),
        const SizedBox(
          height: 4,
        ),
        Text(
          left,
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
        Text(total,
            style: TextStyle(color: color, fontWeight: FontWeight.bold)),
      ],
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
            child: Icon(icon,
                size: iconSize, color: Colors.white),
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
