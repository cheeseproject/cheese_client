import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import '../../styles/custom_color.dart';
import '../../utils/form_validator.dart';

class SignInModal extends HookWidget {
  final VoidCallback onPressedLogin;
  final VoidCallback onPressedClose;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final String? errorText;

  const SignInModal({
    Key? key,
    required this.onPressedLogin,
    required this.onPressedClose,
    required this.emailController,
    required this.passwordController,
    this.errorText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final formKey = useMemoized(GlobalKey<FormState>.new);

    return SizedBox(
        height: MediaQuery.of(context).size.height * 0.6,
        child: Container(
          padding: const EdgeInsets.all(32.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16.0),
          ),
          child: Column(
            children: [
              _header(onPressedClose: onPressedClose),
              const Divider(
                thickness: 1,
              ),
              Form(
                  key: formKey,
                  child: Column(
                    children: [
                      const SizedBox(height: 32.0),
                      _emailInputField(controller: emailController),
                      const SizedBox(height: 16.0),
                      _passwordInputField(controller: passwordController),
                      const SizedBox(height: 16.0),
                      Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          "パスワードを忘れた方",
                          textAlign: TextAlign.right,
                          style: TextStyle(
                              color: Colors.grey[600],
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      const SizedBox(height: 16.0),
                      // TODO: ボタンコンポーネントの共通化
                      SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                              onPressed: () {
                                if (!formKey.currentState!.validate()) return;
                                onPressedLogin();
                              },
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.all(12.0),
                                shape: const StadiumBorder(),
                              ),
                              child: const Text("ログイン",
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)))),
                      const SizedBox(height: 16.0),
                      Text(
                        errorText ?? '',
                        style: TextStyle(color: CheeseColor.error),
                      ),
                    ],
                  )),
            ],
          ),
        ));
  }

  Widget _header({required VoidCallback onPressedClose}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // TODO: ログインのテキストを真ん中に寄せる
        const Text(
          "ログイン",
          style: TextStyle(
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        IconButton(
          onPressed: onPressedClose,
          icon: const Icon(Icons.close),
        ),
      ],
    );
  }

  Widget _emailInputField({required TextEditingController controller}) {
    return TextFormField(
      controller: controller,
      validator: FormValidator.validateEmail,
      decoration: const InputDecoration(
        border: InputBorder.none,
        hintText: 'メールアドレス',
        fillColor: CheeseColor.input,
        filled: true,
      ),
    );
  }

  Widget _passwordInputField({required TextEditingController controller}) {
    return TextFormField(
      controller: controller,
      validator: FormValidator.validatePassword,
      obscureText: true,
      decoration: const InputDecoration(
        border: InputBorder.none,
        hintText: 'パスワード',
        fillColor: CheeseColor.input,
        filled: true,
      ),
    );
  }
}
