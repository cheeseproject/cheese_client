import 'package:cheese_client/src/components/ui/common/page_error.dart';
import 'package:cheese_client/src/components/ui/common/page_loading.dart';
import 'package:cheese_client/src/hooks/domain/snap_route/use_delete_snap_route.dart';
import 'package:cheese_client/src/hooks/domain/snap_route/use_fetch_snap_post.dart';
import 'package:cheese_client/src/hooks/helper/use_mutation.dart';
import 'package:cheese_client/src/pages/snap_route_detail/delete_bottom_sheet.dart';
import 'package:cheese_client/src/pages/snap_route_detail/map_page.dart';
import 'package:cheese_client/src/pages/snap_route_detail/route_detail_header.dart';
import 'package:cheese_client/src/pages/snap_route_detail/route_page.dart';
import 'package:cheese_client/src/pages/snap_route_detail/snap_route_detail_page_loading.dart';
import 'package:cheese_client/src/pages/snap_route_detail/use_search_route.dart';
import 'package:cheese_client/src/repositories/snap_route/params/snap_route_params.dart';
import 'package:cheese_client/src/router/page_routes.dart';
import 'package:cheese_client/src/styles/custom_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_use_geolocation/flutter_use_geolocation.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:latlong2/latlong.dart';

class SnapRouteDetailPage extends HookConsumerWidget {
  final String snapRouteId;
  const SnapRouteDetailPage({Key? key, required this.snapRouteId})
      : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final snapshot = useSearchRoute(ref, snapRouteId);
    final deleteMutation = useDeleteSnapRoute(ref);
    final geolocation = useGeolocation();
    final snapRoute = snapshot.data?.snapRoute;
    final searchRoute = snapshot.data?.searchRoute;
    Future<void> onBack() async {
      context.pop();
    }

    Future<void> onPressedDelete() async {
      await deleteMutation.mutate(
          params: DeleteSnapRouteParams(snapRouteId: snapRouteId),
          option: MutationOption(onSuccess: (data) {
            context.go(PageRoutes.route);
          }, onError: (error) {
            print('error');
          }));
    }

    void onPressedDetail() {
      showModalBottomSheet(
          context: context,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
          ),
          builder: (BuildContext context) {
            return DelateBottomSheet(onPressedDelete: onPressedDelete);
          });
    }

    if (snapshot.hasError) {
      return PageError(
        message: snapshot.error.toString(),
      );
    }
    if (snapshot.isLoading ||
        snapRoute == null ||
        searchRoute == null ||
        geolocation.position == null) {
      return const SnapRouteDetailPageLoading();
    }

    return DefaultTabController(
        length: 2,
        child: Scaffold(
          backgroundColor: CheeseColor.bgColor,
          appBar: RouteDetailHeader(
            title: snapRoute.title,
            onPressedAction: onPressedDetail,
            onPressedBack: onBack,
          ),
          body: TabBarView(
            children: [
              MapPage(
                  searchRoute: searchRoute,
                  latLng: LatLng(geolocation.position!.latitude,
                      geolocation.position!.longitude)),
              RoutePage(
                searchRoute: searchRoute,
              ),
            ],
          ),
        ));
  }
}
