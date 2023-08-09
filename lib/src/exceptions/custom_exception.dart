class CustomException implements Exception {
  final String message;

  CustomException({required this.message});

  @override
  String toString() => message;

  static Exception passwordNotMatch() =>
      CustomException(message: 'パスワードが一致しません');

  static Exception emailAlreadyInUse() =>
      CustomException(message: 'このメールアドレスは既に使用されています');

  static Exception invalidEmail() =>
      CustomException(message: 'メールアドレスの形式が正しくありません');

  static Exception networkRequestFailed() =>
      CustomException(message: 'ネットワークリクエストに失敗しました');

  static Exception weakPassword() => CustomException(message: 'パスワードが短すぎます');

  static Exception userNotFound() => CustomException(message: 'ユーザーが見つかりません');

  static Exception wrongPassword() => CustomException(message: 'パスワードが間違っています');

  static Exception tooManyRequests() => CustomException(message: 'リクエストが多すぎます');

  static Exception userDisabled() => CustomException(message: 'ユーザーが無効です');

  static Exception unauthenticated() => CustomException(message: '認証されていません');

  static Exception invalidArgument() => CustomException(message: '引数が無効です');

  static Exception notFound() => CustomException(message: '見つかりません');

  static Exception alreadyExists() => CustomException(message: '既に存在します');

  static Exception permissionDenied() => CustomException(message: '許可されていません');

  static Exception unknown() => CustomException(message: '不明なエラーが発生しました');

  static Exception noData() => CustomException(message: 'データがありません');

  static Exception noConnection() =>
      CustomException(message: 'ネットワークに接続されていません');

  static Exception timeout() => CustomException(message: 'タイムアウトしました');

  static Exception noLocationPermission() =>
      CustomException(message: '位置情報の許可がありません');

  static Exception noLocationService() =>
      CustomException(message: '位置情報が有効になっていません');

  static Exception noCameraPermission() =>
      CustomException(message: 'カメラの許可がありません');

  static Exception noStoragePermission() =>
      CustomException(message: 'ストレージの許可がありません');

  static Exception noNotificationPermission() =>
      CustomException(message: '通知の許可がありません');

  static Exception objectNotFound() =>
      CustomException(message: 'オブジェクトが見つかりません');

  static Exception cancelled() => CustomException(message: 'キャンセルされました');

  static Exception failedRequest() => CustomException(message: 'リクエストに失敗しました');
}
