import 'package:cheese_client/src/components/ui/common/aspect_ratio_image.dart';
import 'package:cheese_client/src/entities/snap_post/snap_post.dart';
import 'package:cheese_client/src/pages/snap_route_detail/dot_line.dart';
import 'package:cheese_client/src/pages/snap_route_detail/rounded_number.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../entities/search_route/search_route.dart';

class RoutePage extends HookConsumerWidget {
  final SearchRoute searchRoute;
  const RoutePage({Key? key, required this.searchRoute}) : super(key: key);
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      padding: const EdgeInsets.only(top: 32.0),
      child:
          _snapPostPanelList(posts: searchRoute.findSnapPostsByWaypointOrder()),
    );
  }

  Widget _snapPostPanelList({
    required List<SnapPost> posts,
  }) {
    return ListView.builder(
      itemCount: posts.length,
      itemBuilder: (context, index) {
        final topImage = posts[index].postImages.first.imagePath;
        return Container(
          padding: const EdgeInsets.all(8.0),
          child: _snapPostPanel(
            title: posts[index].title,
            comment: posts[index].comment,
            image: topImage,
            orderNumber: index + 1,
          ),
        );
      },

      // Dividerをいれたいので、paddingを入れている
    );
  }

  Widget _snapPostPanel(
      {required String? comment,
      required String image,
      required String title,
      required int orderNumber}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Spacer(),
        Column(
          children: [
            RoundedNumber(
              number: orderNumber,
              size: 32,
              backgroundColor: Colors.grey[300],
              textStyle: const TextStyle(color: Colors.black, fontSize: 16),
            ),
            DottedLine(
              height: 120,
              color: Colors.grey[500],
              dotRadius: 4,
              spacing: 4,
            )
          ],
        ),
        const SizedBox(width: 16.0),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            const SizedBox(height: 8.0),
            _snapPostCard(
              comment: comment,
              image: image,
            )
          ],
        ),
        const Spacer(),
      ],
    );
  }

  Widget _snapPostCard({
    required String? comment,
    required String image,
  }) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(8.0)),
      ),
      child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        AspectRatioImage(
          image: image,
          size: 120,
        ),
        const SizedBox(width: 16.0),
        // NOTE: タイトルが一行で収まるようにラップしている
        Container(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          width: 152,
          child: Text(
            comment ?? '',
            maxLines: 4,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ]),
    );
  }
}
