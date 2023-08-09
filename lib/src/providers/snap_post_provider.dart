import 'package:cheese_client/src/entities/snap_post/snap_post.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

// NOTE: 投稿を追加するためのStateNotifier。画面遷移を多用するのでグローバルで管理する
class SnapPostNotifier extends StateNotifier<List<SnapPost>> {
  SnapPostNotifier(super.state);

  void add(SnapPost snapPost) {
    if (contains(snapPost.snapPostId)) return;
    state = [...state, snapPost];
  }

  void remove(String snapPostId) {
    state = state.where((e) => e.snapPostId != snapPostId).toList();
  }

  bool contains(String snapPostId) {
    return state.any((e) => e.snapPostId == snapPostId);
  }

  void clear() {
    state = [];
  }
}

final snapPostProvider =
    StateNotifierProvider<SnapPostNotifier, List<SnapPost>>(
  (ref) => SnapPostNotifier([]),
);
