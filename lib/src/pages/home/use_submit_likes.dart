import 'package:cheese_client/src/entities/snap_post/snap_post.dart';
import 'package:cheese_client/src/hooks/domain/snap_post/use_like_snap_post.dart';
import 'package:cheese_client/src/hooks/helper/use_mutation.dart';
import 'package:cheese_client/src/providers/session_snap_post_provider.dart';
import 'package:cheese_client/src/repositories/snap_post/params/snap_post_params.dart';
import 'package:cheese_client/src/router/page_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

UseSubmitLikes useSubmitLikes(
    BuildContext context, WidgetRef ref, List<SnapPost> snapPosts) {
  final likedSnapPosts = useState<List<SnapPost>>([]);
  final mutation = useLikeSnapPost(ref);

  void like(SnapPost likedSnapPost) {
    likedSnapPosts.value = [...likedSnapPosts.value, likedSnapPost];
  }

  Future<void> submitLikes() async {
    final params = LikeSnapPostParams(
        snapPostIds: likedSnapPosts.value.map((e) => e.snapPostId).toList());
    mutation.mutate(
        params: params,
        option: MutationOption(
          // NoTE: いいねのした投稿をマップが表示するためにグローバルで管理する
          onSuccess: (_) {
            ref
                .read(sessionSnapPostProvider.notifier)
                .set(likedSnapPosts.value);
            context.go(PageRoutes.map);
          },
          onError: (e) => print(e),
        ));
  }

  return UseSubmitLikes(submitLikes: submitLikes, like: like);
}

class UseSubmitLikes {
  final Future<void> Function() submitLikes;
  final void Function(SnapPost) like;
  UseSubmitLikes({required this.submitLikes, required this.like});
}
