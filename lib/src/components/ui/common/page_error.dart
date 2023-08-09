import 'package:flutter/material.dart';

class PageError extends StatelessWidget {
  final String message;
  const PageError({Key? key, this.message = 'エラーが発生しました。'}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Center(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Image.asset(
        //   logoPath,
        //   width: 150,
        // ),
        SizedBox(height: 16.0),
        Text(
          'エラーが発生しました。',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red),
        ),
      ],
    ));
  }
}
