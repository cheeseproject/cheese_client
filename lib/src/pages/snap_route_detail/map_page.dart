import 'package:cheese_client/src/components/ui/snap_post_marker.dart';
import 'package:cheese_client/src/constants/lat_lng.dart';
import 'package:cheese_client/src/constants/map_url_template.dart';
import 'package:cheese_client/src/entities/search_route/search_route.dart';
import 'package:cheese_client/src/entities/snap_post/snap_post.dart';
import 'package:cheese_client/src/pages/map/custom_marker.dart';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_marker_popup/flutter_map_marker_popup.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:latlong2/latlong.dart';
import '../../router/page_routes.dart';

const routeIconPath = 'assets/images/route.png';

class MapPage extends HookConsumerWidget {
  final SearchRoute searchRoute;
  const MapPage({Key? key, required this.searchRoute}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final PopupController popupLayerController = PopupController();

    void onPressedDetail(String snapPostId) {
      context.push('${PageRoutes.snapPostDetail}/$snapPostId');
    }

    final List<CustomMarker> markers = searchRoute.snapPosts
        .map(
          (e) => CustomMarker(
            markerId: e.snapPostId,
            point: LatLng(e.latitude, e.longitude),
            width: 80.0,
            height: 80.0,
            builder: (_) => SnapPostMarker(image: e.postImages.first.imagePath),
          ),
        )
        .toList();

    return Scaffold(
      body: FlutterMap(
        options: MapOptions(
          center: dummyLatLng,
          zoom: 16.0,
          onTap: (_, __) => popupLayerController.hideAllPopups(),
        ),
        children: <Widget>[
          TileLayer(
            urlTemplate: mapUrlTemplate,
          ),
          PolylineLayer(
            polylines: [
              Polyline(
                points: searchRoute.polylinePoint.decode(),
                color: Colors.blue,
                strokeWidth: 7.0,
              ),
            ],
          ),
          PopupMarkerLayer(
            options: PopupMarkerLayerOptions(
              markers: markers,
              popupController: popupLayerController,
              popupDisplayOptions: PopupDisplayOptions(
                builder: (BuildContext ctx, Marker marker) {
                  if (marker is! CustomMarker) return Container();
                  return _popover(
                    onPressedDetail: () => onPressedDetail(marker.markerId),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _popover({
    required VoidCallback onPressedDetail,
  }) {
    return Container(
      width: 200,
      height: 50,
      color: Colors.white,
      child: Column(
        children: [
          TextButton(
            onPressed: onPressedDetail,
            child: const Text("詳細を見る"),
          )
        ],
      ),
    );
  }
}
