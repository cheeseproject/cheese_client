# Cheese

A new Flutter project.

## 環境構築

以下の記事を参考にして環境構築を行う。

https://zenn.dev/kazutxt/books/flutter_practice_introduction/viewer/06_chapter1_environment

## 起動

パッケージのインストール
```
flutter pub get
```

ビルド

```
flutter run
```
ただし、ホットリロードできないので、vscodeから実行することをお薦めるする。
詳しくは以下を参考
https://zenn.dev/kazutxt/books/flutter_practice_introduction/viewer/07_chapter1_helloworld

## クラス作成

`freezed` はFlutterアプリケーションでイミュータブルなデータクラスを簡単に生成するためのパッケージ

以下のコマンドで生成できる.


```
flutter pub run build_runner build
```
