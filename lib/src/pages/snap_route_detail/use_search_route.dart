import 'package:cheese_client/src/entities/search_route/search_route.dart';
import 'package:cheese_client/src/entities/snap_route/snap_route.dart';
import 'package:cheese_client/src/hooks/helper/use_query.dart';
import 'package:cheese_client/src/repositories/location/location_repository_provider.dart';
import 'package:cheese_client/src/repositories/search_route/search_route_repository_provider.dart';
import 'package:cheese_client/src/repositories/snap_route/params/snap_route_params.dart';
import 'package:cheese_client/src/repositories/snap_route/snap_route_repository_provider.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:latlong2/latlong.dart';

class SearchRouteResult {
  final SnapRoute snapRoute;
  final SearchRoute searchRoute;

  SearchRouteResult({required this.snapRoute, required this.searchRoute});
}

UseQueryResult<SearchRouteResult> useSearchRoute(
    WidgetRef ref, String snapRouteId) {
  final searchRouteRepository = ref.watch(searchRouteRepositoryProvider);
  final snapRouteRepository = ref.watch(snapRouteRepositoryProvider);
  final locationRepository = ref.watch(locationRepositoryProvider);

  queryFn() async {
    final snapRoutes = await snapRouteRepository
        .fetch(FetchSnapRouteParams(snapRouteId: snapRouteId));
    final snapPosts = snapRoutes.snapPosts;
    final position = await locationRepository.getCurrentPosition();
    final origin = LatLng(position.latitude, position.longitude);
    final destination = LatLng(position.latitude, position.longitude);
    final searchRoute = await searchRouteRepository.get(
        snapPosts: snapPosts, origin: origin, destination: destination);
    return SearchRouteResult(snapRoute: snapRoutes, searchRoute: searchRoute);
  }

  return useQuery<SearchRouteResult>(queryFn: queryFn);
}
