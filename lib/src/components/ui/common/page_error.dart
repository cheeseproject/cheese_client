import 'package:flutter/material.dart';

import '../../../constants/logo_image_path.dart';

class PageError extends StatelessWidget {
  final String message;
  const PageError({Key? key, this.message = 'エラーが発生しました。'}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              logoPath,
              width: 200,
            ),
            const SizedBox(height: 16.0),
            const Text(
              'エラーが発生しました。',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.red,
                fontSize: 16.0,
              ),
            ),
          ],
        )));
  }
}
