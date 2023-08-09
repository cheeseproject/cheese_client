import 'package:cheese_client/src/components/ui/common/header.dart';
import 'package:cheese_client/src/components/ui/common/page_error.dart';
import 'package:cheese_client/src/components/ui/common/page_loading.dart';
import 'package:cheese_client/src/hooks/domain/snap_post/use_fetch_snap_post.dart';
import 'package:cheese_client/src/components/ui/snap_post_detail_card.dart';
import 'package:cheese_client/src/components/ui/common/snap_post_detail_page_loading.dart';
import 'package:cheese_client/src/repositories/snap_post/params/snap_post_params.dart';
import 'package:cheese_client/src/styles/custom_color.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class SnapPostDetailPage extends HookConsumerWidget {
  final String snapPostId;
  const SnapPostDetailPage({
    Key? key,
    required this.snapPostId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final snapshot =
        useFetchSnapPost(ref, FetchSnapPostParams(snapPostId: snapPostId));
    final snapPost = snapshot.data;
    Future<void> onBack() async {
      context.pop();
    }

    if (snapshot.hasError) return const PageError();
    if (snapshot.isLoading || snapPost == null) {
      return const SnapPostDetailPageLoading();
    }

    return Scaffold(
      backgroundColor: CheeseColor.bgColor,
      appBar: Header(
        title: "詳細",
        leading: IconButton(
          onPressed: onBack,
          icon: const Icon(Icons.arrow_back_ios),
          color: Colors.black,
        ),
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
        child: SnapPostDetailCard(
          title: snapPost.title,
          comment: snapPost.comment,
          address: snapPost.address,
          images: snapPost.postImages.map((e) => e.imagePath).toList(),
        ),
      ),
    );
  }
}
