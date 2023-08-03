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
## 主なライブラリ
| ライブラリ名      |　説明 |
| ----------- | ----------- |
| riverpod      | 状態管理  |
| flutter_hooks      | reactのようなhooks  |
| freezed   | データクラス  |


## フォルダ構成

| ライブラリ名      |　説明 |
| ----------- | ----------- |
| repositories      | データアクセス      |
| entities      | アプリで扱うクラス      |
| hooks.domain   | reppsitoriesの関数を呼び出すラッパー。　useQueryかuseMutationから呼び出す |
| hooks.helper   | 汎用hooks      |
| pages   |ページ     |
| conponents.ui   | 汎用的なコンポーネント      |
| utils  | 汎用関数やクラス      |
| styles  | 共通スタイル      |
| router  | ページのルーティング、リダイレクト処理      |

## 設計方針
### 依存ルール
pages -> hooks.domain -> repository


### API通信
repositoriesに記述。テストしやすいようにriverpodでDIしている。

### コンポーネント（ウィジェット）
状態を持つ場合、`HookConsumerWidget`を継承する。持たない場合は、`StatelessWidget`を継承する。
責務を分離して小さなコンポーネントを作成していく。コンポーネントが状態をもったりコード数が多くなった場合は、別ファイルに切り出す。それ以外は`_conponent`と命名してクラス内に関数を定義する。

