import 'package:cheese_client/firebase_options.dart';
import 'package:cheese_client/src/constants/config.dart';
import 'package:cheese_client/src/utils/firebase/firebase_connect_to_emlator.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'src/app.dart';
import 'package:firebase_core/firebase_core.dart';

Future<void> main() async {
  // NOTE: firebaseの初期化
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // NOTE: 環境変数の読み込み
  await Config.init();

  // NOTE: ローカル環境でfirebase emulatorを使うための設定
  // if (kDebugMode) connectToEmulator();

  // await FirebaseAuth.instance.useAuthEmulator('localhost', 9099);
  runApp(const ProviderScope(child: MyApp()));
}
