import 'package:cheese_client/src/components/ui/common/page_loading.dart';
import 'package:cheese_client/src/constants/logo_image_path.dart';
import 'package:cheese_client/src/hooks/domain/auth/use_sign_in.dart';
import 'package:cheese_client/src/hooks/helper/use_mutation.dart';
import 'package:cheese_client/src/pages/sign_in/sing_in_modal.dart';
import 'package:cheese_client/src/providers/profile_provider.dart';
import 'package:cheese_client/src/router/page_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class SignInPage extends HookConsumerWidget {
  const SignInPage({super.key});

  @override
  Widget build(
    BuildContext context,
    WidgetRef ref,
  ) {
    final emailController = useTextEditingController();
    final passwordController = useTextEditingController();
    final mutation = useSignIn(ref);
    final errorText = useState('');

    Future<void> refreshUser() async {
      await ref.read(userProvider.notifier).refreshUser();
    }

    Future<void> onPressedLogin() async {
      context.pop();
      mutation.mutate(
          params: SignInParams(
              email: emailController.text, password: passwordController.text),
          option: MutationOption(
            onSuccess: (res) async {
              await refreshUser();
              if (context.mounted) context.go(PageRoutes.home);
            },
            onError: (e) {
              errorText.value = e.toString();
            },
          ));
    }

    void clearErrorText() {
      errorText.value = '';
    }

    void onPressedClose() {
      clearErrorText();
      context.pop();
    }

// TODO: stateが更新されても再ビルドされない
    void showModal() {
      showModalBottomSheet(
          context: context,
          // NOTE: trueにしないと、Containerのheightが反映されない
          isScrollControlled: true,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
          ),
          builder: (BuildContext context) {
            // NOTE: Paddingを指定しないと、キーボードが出た時に画面が崩れる
            return Padding(
                padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom * 0.6,
                ),
                child: SignInModal(
                  errorText: errorText.value,
                  onPressedLogin: onPressedLogin,
                  onPressedClose: onPressedClose,
                  emailController: emailController,
                  passwordController: passwordController,
                ));
          });
    }

    // useEffect(() {
    //   if (errorText.value.isNotEmpty) return;
    //   showModal();
    //   return null;
    // }, [errorText.value]);

    // if (mutation.isLoading) return const PageLoading();

    return Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.white,
        body: Container(
          padding: const EdgeInsets.all(32.0),
          child: Center(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(logoPath, width: 150),
              const Text("スワイプしてお気に入りの写真を探してみよう!",
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                  )),
              const SizedBox(height: 64.0),
              // TODO: ボタンコンポーネントの共通化
              SizedBox(
                  width: double.infinity,
                  child: _signUpButton(
                      onPressed: () => context.push(PageRoutes.singUp))),
              const SizedBox(height: 16.0),
              // TODO: ボタンコンポーネントの共通化
              SizedBox(
                  width: double.infinity,
                  child: _singInButton(onPressed: showModal)),
            ],
          )),
        ));
  }

  Widget _signUpButton({required VoidCallback onPressed}) {
    return SizedBox(
        width: double.infinity,
        child: OutlinedButton(
            onPressed: onPressed,
            style: OutlinedButton.styleFrom(
                shape: const StadiumBorder(),
                padding: const EdgeInsets.all(12.0),
                foregroundColor: Colors.black,
                elevation: 0,
                backgroundColor: Colors.grey[100]),
            child: const Text("新規登録",
                style: TextStyle(fontWeight: FontWeight.bold))));
  }

  Widget _singInButton({required VoidCallback onPressed}) {
    return SizedBox(
        width: double.infinity,
        child: ElevatedButton(
            onPressed: onPressed,
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.all(12.0),
              shape: const StadiumBorder(),
            ),
            child: const Text("ログイン",
                style: TextStyle(fontWeight: FontWeight.bold))));
  }
}
