import 'package:cheese_client/src/entities/snap_post/snap_post.dart';
import 'package:cheese_client/src/hooks/helper/use_query.dart';
import 'package:cheese_client/src/repositories/location/location_repository_provider.dart';
import 'package:cheese_client/src/repositories/snap_post/params/snap_post_params.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../../repositories/snap_post/snap_post_repository_provider.dart';

UseQueryResult<List<SnapPost>> useFetchSnapPostsByCurrentPosition(
    WidgetRef ref) {
  final snapPostRepository = ref.watch(snapPostRepositoryProvider);
  final locationRepository = ref.watch(locationRepositoryProvider);

  queryFn() async {
    final position = await locationRepository.getCurrentPosition();
    final params = FetchNearbySnapPostsParams(
      latitude: position.latitude,
      longitude: position.longitude,
    );
    final snapPosts = snapPostRepository.fetchNearby(params);
    return snapPosts;
  }

  final snapshot = useQuery(queryFn: queryFn);
  return snapshot;
}
