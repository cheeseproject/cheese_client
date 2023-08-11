import 'package:flutter/material.dart';

class DottedLine extends StatelessWidget {
  final double height;
  final Color? color;
  final double dotRadius;
  final double spacing;

  const DottedLine({
    super.key,
    required this.height,
    this.color = Colors.black,
    this.dotRadius = 2,
    this.spacing = 4,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: CustomPaint(
        painter: DottedLinePainter(
            color: color ?? Colors.black,
            dotRadius: dotRadius,
            spacing: spacing),
      ),
    );
  }
}

class DottedLinePainter extends CustomPainter {
  final Color color;
  final double dotRadius;
  final double spacing;

  DottedLinePainter({
    required this.color,
    required this.dotRadius,
    required this.spacing,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1
      ..strokeCap = StrokeCap.round;

    double offsetY = 0;
    while (offsetY < size.height) {
      canvas.drawLine(
          Offset(0, offsetY), Offset(0, offsetY + dotRadius), paint);
      offsetY += dotRadius + spacing;
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
