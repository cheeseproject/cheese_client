import 'package:cheese_client/src/components/ui/common/page_loading.dart';
import 'package:cheese_client/src/pages/snap_route_detail/route_detail_header.dart';
import 'package:cheese_client/src/styles/custom_color.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class SnapRouteDetailPageLoading extends HookConsumerWidget {
  const SnapRouteDetailPageLoading({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return DefaultTabController(
        length: 2,
        child: Scaffold(
          backgroundColor: CheeseColor.bgColor,
          appBar: RouteDetailHeader(
            title: "",
            onPressedAction: () {},
            onPressedBack: () {
              context.pop();
            },
          ),
          body: const TabBarView(
            children: [
              PageLoading(),
              PageLoading(),
            ],
          ),
        ));
  }
}
