import 'package:cheese_client/src/components/ui/common/aspect_ratio_image.dart';
import 'package:cheese_client/src/components/ui/common/header.dart';
import 'package:cheese_client/src/components/ui/common/page_error.dart';
import 'package:cheese_client/src/components/ui/common/page_loading.dart';
import 'package:cheese_client/src/entities/snap_route/snap_route.dart';
import 'package:cheese_client/src/hooks/domain/snap_route/use_fetch_snap_post.dart';
import 'package:cheese_client/src/providers/snap_post_provider.dart';
import 'package:cheese_client/src/router/page_routes.dart';
import 'package:cheese_client/src/styles/custom_color.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class RoutePage extends HookConsumerWidget {
  const RoutePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final snapshot = useFetchMySnapRoutes(ref);
    final snapRoute = snapshot.data ?? [];

    void onPressedAdd() {
      // NOTE: マップ画面で選択されていたものをクリアする
      ref.read(snapPostProvider.notifier).clear();
      context.push(PageRoutes.routeSubmit);
    }

    Future<void> onTapedRoute(String snapRouteId) async {
      context.push('${PageRoutes.routeDetail}/$snapRouteId');
    }

    if (snapshot.isLoading) return const PageLoading();

    if (snapshot.hasError) return const PageError();

    return Scaffold(
      backgroundColor: CheeseColor.bgColor,
      appBar: const Header(title: "ルート一覧"),
      body: Container(
        padding: const EdgeInsets.all(8.0),
        child:
            _snapRouteCardList(routes: snapRoute, onTapedRoute: onTapedRoute),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: onPressedAdd,
        backgroundColor: Colors.black,
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _snapRouteCardList(
      {required List<SnapRoute> routes,
      required void Function(String) onTapedRoute}) {
    return ListView.builder(
      itemCount: routes.length,
      itemBuilder: (context, index) {
        final topImage =
            routes[index].snapPosts.first.postImages.first.imagePath;
        return Container(
          padding: const EdgeInsets.all(8.0),
          child: _snapRouteCard(
              title: routes[index].title,
              image: topImage,
              onPressed: () {
                onTapedRoute(routes[index].snapRouteId);
              }),
        );
      },
    );
  }

  Widget _snapRouteCard({
    required String title,
    required String image,
    required VoidCallback onPressed,
  }) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(8.0)),
      ),
      child: Row(children: [
        AspectRatioImage(
          image: image,
          size: 120,
        ),
        const SizedBox(width: 16.0),
        // NOTE: タイトルが一行で収まるようにラップしている
        SizedBox(
          width: 172,
          child: Text(
            title,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
        ),
        const Spacer(),
        IconButton(
          icon: const Icon(
            Icons.more_vert,
          ),
          onPressed: onPressed,
        )
      ]),
    );
  }
}
