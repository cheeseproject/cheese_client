import 'package:cheese_client/src/entities/search_route/overview_polyline_point.dart';
import 'package:cheese_client/src/entities/snap_post/snap_post.dart';

class SearchRoute {
  final OverviewPolylinePoint polylinePoint;
  final List<int> waypointOrder;
  final List<SnapPost> snapPosts;

  SearchRoute(this.snapPosts,
      {required this.polylinePoint, required this.waypointOrder});

  // waypointOrderに従ってsnapPostsを並び替える
  List<SnapPost> findSnapPostsByWaypointOrder() {
    List<SnapPost> result = [];
    for (int i = 0; i < waypointOrder.length; i++) {
      result.add(snapPosts[waypointOrder[i]]);
    }
    return result;
  }
}
