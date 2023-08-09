import 'package:cheese_client/src/repositories/search_route/search_route_repository.dart';
import 'package:cheese_client/src/repositories/search_route/search_route_repository_impl.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final searchRouteRepositoryProvider = Provider<SearchRouteRepository>((ref) {
  return SearchRouteRepositoryImpl();
});
