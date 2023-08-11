import 'dart:convert';

import 'package:cheese_client/src/constants/config.dart';
import 'package:cheese_client/src/entities/search_route/overview_polyline_point.dart';
import 'package:cheese_client/src/entities/search_route/search_route.dart';
import 'package:cheese_client/src/entities/snap_post/snap_post.dart';
import 'package:cheese_client/src/exceptions/custom_exception.dart';
import 'package:cheese_client/src/repositories/search_route/search_route_repository.dart';
import 'package:latlong2/latlong.dart';
import 'package:http/http.dart' as http;

class SearchRouteRepositoryImpl implements SearchRouteRepository {
  final _apiKey = Config.googlePlatformApiKey;
  final _url = 'https://maps.googleapis.com/maps/api/directions/json';
  SearchRouteRepositoryImpl();

  @override
  Future<SearchRoute> get(
      {required List<SnapPost> snapPosts,
      required LatLng origin,
      required LatLng destination}) async {
    final url =
        toUrl(snapPosts: snapPosts, origin: origin, destination: destination);

    final data = await _search(url);
    final route = data['routes'][0];

    final overviewPolylinePoint =
        OverviewPolylinePoint(route['overview_polyline']['points']);
    final waypointOrder = route['waypoint_order'].cast<int>();

    return SearchRoute(snapPosts,
        polylinePoint: overviewPolylinePoint, waypointOrder: waypointOrder);
  }

  Future<dynamic> _search(String url) async {
    final response = await http.get(Uri.parse(url));
    if (response.statusCode != 200) {
      throw CustomException.failedRequest();
    }
    final data = jsonDecode(response.body);
    if (data['status'] != 'OK') {
      throw CustomException.noData();
    }
    return data;
  }

  String toUrl(
          {required List<SnapPost> snapPosts,
          required LatLng origin,
          required LatLng destination}) =>
      '$_url?origin=${origin.latitude},${origin.longitude}&destination=${destination.latitude},${destination.longitude}&waypoints=optimize:true|${snapPosts.map((e) => '${e.latitude},${e.longitude}').join('|')}&mode=walking&key=$_apiKey';
}
