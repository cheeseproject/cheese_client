import 'package:flutter/material.dart';

class RoundedNumber extends StatelessWidget {
  final int number;
  final double size;
  final Color? backgroundColor;
  final TextStyle textStyle;

  const RoundedNumber({
    super.key,
    required this.number,
    this.size = 50,
    this.backgroundColor = Colors.grey,
    this.textStyle = const TextStyle(color: Colors.white, fontSize: 20),
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: backgroundColor,
      ),
      child: Center(
        child: Text(
          number.toString(),
          style: textStyle,
        ),
      ),
    );
  }
}
