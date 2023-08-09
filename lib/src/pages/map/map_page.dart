import 'package:cheese_client/src/components/ui/common/page_error.dart';
import 'package:cheese_client/src/components/ui/common/page_loading.dart';
import 'package:cheese_client/src/components/ui/snap_post_marker.dart';
import 'package:cheese_client/src/constants/lat_lng.dart';
import 'package:cheese_client/src/constants/map_url_template.dart';
import 'package:cheese_client/src/pages/map/custom_marker.dart';
import 'package:cheese_client/src/pages/map/use_fetch_liked_and_nearby_snap_posts.dart';
import 'package:cheese_client/src/providers/session_snap_post_provider.dart';
import 'package:cheese_client/src/providers/snap_post_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_marker_popup/flutter_map_marker_popup.dart';
import 'package:flutter_use_geolocation/flutter_use_geolocation.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:latlong2/latlong.dart';
import '../../router/page_routes.dart';

enum SnapPostType { liked, nearby, session }

const routeIconPath = 'assets/images/route.png';

class MapPage extends HookConsumerWidget {
  const MapPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedSnapPosts = ref.watch(snapPostProvider);
    final geolocation = useGeolocation();
    final snapshot = useFetchLikedAndNearbySnapPosts(ref);
    final sessionSnapPosts = ref.watch(sessionSnapPostProvider);
    final selectedType = useState<SnapPostType>(
        sessionSnapPosts.isEmpty ? SnapPostType.liked : SnapPostType.session);

    final PopupController popupLayerController = PopupController();

    final displayedSnapPosts = useMemoized(() {
      switch (selectedType.value) {
        case SnapPostType.liked:
          return snapshot.likedSnapPosts;
        case SnapPostType.nearby:
          return snapshot.nearbySnapPosts;
        case SnapPostType.session:
          return sessionSnapPosts;
      }
    }, [selectedType.value, snapshot.likedSnapPosts, snapshot.nearbySnapPosts]);

    void onPressedCreateRoute() {
      context.push(PageRoutes.routeSubmit);
    }

    void onPressedDelete(String snapPostId) {
      ref.read(snapPostProvider.notifier).remove(snapPostId);
    }

    void onPressedDetail(String snapPostId) {
      context.push('${PageRoutes.snapPostDetail}/$snapPostId');
    }

    void onPressedAdd(String snapPostId) {
      final snapPost =
          displayedSnapPosts.firstWhere((e) => e.snapPostId == snapPostId);
      ref.read(snapPostProvider.notifier).add(snapPost);
    }

    void onPressedTab(SnapPostType type) {
      selectedType.value = type;
    }

    bool isSelected(String snapPostId) {
      return ref.read(snapPostProvider.notifier).contains(snapPostId);
    }

    final List<CustomMarker> markers = displayedSnapPosts
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

    //NOTE: ページを離れるときにsessionを削除。本当はページ分けた方が責務的には良い
    useEffect(() {
      return () {
        // ref.read(sessionSnapPostProvider.notifier).reset();
      };
    }, []);

    if (snapshot.isLoading || geolocation.position == null) {
      return const PageLoading();
    }
    if (snapshot.hasError) return const PageError();

    return Scaffold(
      body: Stack(
        children: [
          FlutterMap(
            options: MapOptions(
              center: LatLng(geolocation.position!.latitude,
                  geolocation.position!.longitude),
              zoom: 15.5,
              onTap: (_, __) => popupLayerController.hideAllPopups(),
            ),
            children: <Widget>[
              TileLayer(
                urlTemplate: mapUrlTemplate,
              ),
              PopupMarkerLayer(
                options: PopupMarkerLayerOptions(
                  markers: markers,
                  popupController: popupLayerController,
                  popupDisplayOptions: PopupDisplayOptions(
                    builder: (BuildContext ctx, Marker marker) {
                      if (marker is! CustomMarker) return Container();
                      return _popover(
                          onPressedDetail: () =>
                              onPressedDetail(marker.markerId),
                          onPressedAdd: () => onPressedAdd(marker.markerId),
                          onPressedDelete: () =>
                              onPressedDelete(marker.markerId),
                          isSelected: isSelected(marker.markerId));
                    },
                  ),
                ),
              ),
            ],
          ),
          Positioned(
              top: 64.0,
              left: 16.0,
              child: Row(
                children: [
                  _tabButton(
                      text: "すべて",
                      onPressed: () => onPressedTab(SnapPostType.nearby),
                      isActive: selectedType.value == SnapPostType.nearby),
                  const SizedBox(width: 16),
                  _tabButton(
                      text: "いいね",
                      onPressed: () => onPressedTab(SnapPostType.liked),
                      isActive: selectedType.value == SnapPostType.liked),
                  const SizedBox(width: 16),
                  _tabButton(
                      text: "セッション",
                      onPressed: () => onPressedTab(SnapPostType.session),
                      isActive: selectedType.value == SnapPostType.session),
                ],
              )),
        ],
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: onPressedCreateRoute,
          backgroundColor: Colors.white,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                routeIconPath,
                width: 24,
                height: 24,
              ),
              const Text(
                "ルート作成",
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 8,
                    fontWeight: FontWeight.bold),
              )
            ],
          )),
    );
  }

  Widget _tabButton(
      {required String text,
      required VoidCallback onPressed,
      required bool isActive}) {
    return ElevatedButton(
      onPressed: onPressed,
      // NOTE: 選択されているときはデフォルトの色(null)
      style: ButtonStyle(
        backgroundColor:
            isActive ? null : MaterialStateProperty.all<Color>(Colors.white),
        foregroundColor: isActive
            ? null // 選択されているときの文字色
            : MaterialStateProperty.all<Color>(Colors.black),
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0), // 丸さの半径
          ),
        ),
      ),
      child: Text(text),
    );
  }

  Widget _popover({
    required VoidCallback onPressedDetail,
    required VoidCallback onPressedAdd,
    required VoidCallback onPressedDelete,
    required bool isSelected,
  }) {
    return Container(
      width: 200,
      height: 100,
      color: Colors.white,
      child: Column(
        children: [
          isSelected
              ? TextButton(
                  onPressed: onPressedDelete,
                  child: const Text("ルートから削除"),
                )
              : TextButton(
                  onPressed: onPressedAdd,
                  child: const Text("ルートに追加"),
                ),
          TextButton(
            onPressed: onPressedDetail,
            child: const Text("詳細を見る"),
          )
        ],
      ),
    );
  }
}
