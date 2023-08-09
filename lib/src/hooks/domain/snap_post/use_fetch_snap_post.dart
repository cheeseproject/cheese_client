import 'package:cheese_client/src/entities/snap_post/snap_post.dart';
import 'package:cheese_client/src/hooks/helper/use_query.dart';
import 'package:cheese_client/src/repositories/snap_post/params/snap_post_params.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../repositories/snap_post/snap_post_repository_provider.dart';

UseQueryResult<List<SnapPost>> useFetchMySnapPosts(WidgetRef ref) {
  final snapPostRepository = ref.watch(snapPostRepositoryProvider);
  final snapshot = useQuery(queryFn: () => snapPostRepository.fetchMy());
  return snapshot;
}

UseQueryResult<List<SnapPost>> useFetchLikedSnapPosts(WidgetRef ref) {
  final snapPostRepository = ref.watch(snapPostRepositoryProvider);
  final snapshot = useQuery(queryFn: () => snapPostRepository.fetchLiked());
  return snapshot;
}

UseQueryResult<SnapPost> useFetchSnapPost(
    WidgetRef ref, FetchSnapPostParams params) {
  final snapPostRepository = ref.watch(snapPostRepositoryProvider);
  final snapshot = useQuery(queryFn: () => snapPostRepository.fetch(params));
  return snapshot;
}
