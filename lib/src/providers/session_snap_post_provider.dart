import 'package:cheese_client/src/entities/snap_post/snap_post.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

// NOTE: スワイプ画面でいいねした投稿を保持する。マップ画面でいいねした投稿を表示するために使用する。
class SessionSnapPostNotifier extends StateNotifier<List<SnapPost>> {
  SessionSnapPostNotifier(super.state);

  void set(List<SnapPost> snapPosts) {
    state = snapPosts;
  }

  void reset() {
    state = [];
  }
}

final sessionSnapPostProvider =
    StateNotifierProvider<SessionSnapPostNotifier, List<SnapPost>>(
  (ref) => SessionSnapPostNotifier([]),
);
