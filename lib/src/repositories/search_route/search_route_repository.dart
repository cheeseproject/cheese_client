import 'package:cheese_client/src/entities/search_route/search_route.dart';
import 'package:cheese_client/src/entities/snap_post/snap_post.dart';
import 'package:latlong2/latlong.dart';

abstract class SearchRouteRepository {
  Future<SearchRoute> get(
      {required List<SnapPost> snapPosts,
      required LatLng origin,
      required LatLng destination});
}
