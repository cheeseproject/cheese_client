import 'package:cheese_client/src/common/option.dart';
import 'package:cheese_client/src/hooks/helper/use_form_key.dart';
import 'package:cheese_client/src/utils/form_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class EditDialog extends HookConsumerWidget {
  final String title;
  final String? comment;
  final void Function({required String title, required String? comment})
      onSubmit;
  final VoidCallback onClose;
  const EditDialog({
    Key? key,
    required this.title,
    required this.comment,
    required this.onClose,
    required this.onSubmit,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final titleController = useTextEditingController(text: title);
    final commentController = useTextEditingController(text: comment);
    final formKey = useFormKey();
    return AlertDialog(
      title: const Text('投稿の編集'),
      content: SizedBox(
          width: 300,
          height: 300,
          child: Form(
            key: formKey,
            child: Column(
              children: [
                TextFormField(
                  controller: titleController,
                  validator: (value) =>
                      FormValidator.validateRequired(value, 'タイトル'),
                  decoration: const InputDecoration(
                    labelText: 'タイトル',
                  ),
                ),
                TextFormField(
                    controller: commentController,
                    decoration: const InputDecoration(
                      labelText: 'コメント',
                    ),
                    maxLines: 4),
              ],
            ),
          )),
      actions: [
        TextButton(
          onPressed: onClose,
          child: const Text(
            'キャンセル',
          ),
        ),
        TextButton(
          onPressed: () {
            if (!formKey.currentState!.validate()) return;
            onSubmit(
                title: titleController.text, comment: commentController.text);
          },
          child: const Text('編集する',
              style:
                  TextStyle(color: Colors.blue, fontWeight: FontWeight.bold)),
        ),
      ],
    );
  }
}
