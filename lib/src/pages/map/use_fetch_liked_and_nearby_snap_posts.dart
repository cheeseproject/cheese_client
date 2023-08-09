import 'package:cheese_client/src/entities/snap_post/snap_post.dart';
import 'package:cheese_client/src/hooks/domain/snap_post/use_fetch_snap_post.dart';
import 'package:cheese_client/src/hooks/domain/snap_post/use_fetch_snap_posts_by_current_position.dart';

import 'package:hooks_riverpod/hooks_riverpod.dart';

class UseFetchLikedAndNearbySnapPosts {
  final bool isLoading;
  final bool hasError;
  final List<SnapPost> likedSnapPosts;
  final List<SnapPost> nearbySnapPosts;

  UseFetchLikedAndNearbySnapPosts({
    required this.isLoading,
    required this.hasError,
    required this.likedSnapPosts,
    required this.nearbySnapPosts,
  });
}

UseFetchLikedAndNearbySnapPosts useFetchLikedAndNearbySnapPosts(WidgetRef ref) {
  final likedSnapPosts = useFetchLikedSnapPosts(ref);
  final nearbySnapPosts = useFetchSnapPostsByCurrentPosition(ref);

  return UseFetchLikedAndNearbySnapPosts(
    isLoading: likedSnapPosts.isLoading || nearbySnapPosts.isLoading,
    hasError: likedSnapPosts.hasError || nearbySnapPosts.hasError,
    likedSnapPosts: likedSnapPosts.data ?? [],
    nearbySnapPosts: nearbySnapPosts.data ?? [],
  );
}
