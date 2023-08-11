import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class DelateBottomSheet extends HookConsumerWidget {
  final VoidCallback onPressedDelete;
  const DelateBottomSheet({
    Key? key,
    required this.onPressedDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
        padding: const EdgeInsets.only(top: 32.0),
        height: 96,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            InkWell(
              onTap: onPressedDelete,
              child: Container(
                padding: const EdgeInsets.only(left: 32.0),
                child: const Row(
                  children: [
                    Icon(
                      Icons.delete_outline,
                      color: Colors.red,
                    ),
                    SizedBox(
                      width: 16.0,
                    ),
                    Text("ルートを削除",
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.red)),
                  ],
                ),
              ),
            )
          ],
        ));
  }
}
