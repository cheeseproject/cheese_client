import 'package:cheese_client/src/components/ui/common/header.dart';
import 'package:cheese_client/src/components/ui/common/page_error.dart';
import 'package:cheese_client/src/components/ui/common/page_loading.dart';
import 'package:cheese_client/src/components/ui/common/snap_post_detail_page_loading.dart';
import 'package:cheese_client/src/hooks/domain/snap_post/use_delete_snap_post.dart';
import 'package:cheese_client/src/hooks/domain/snap_post/use_fetch_snap_post.dart';
import 'package:cheese_client/src/components/ui/snap_post_detail_card.dart';
import 'package:cheese_client/src/hooks/helper/use_mutation.dart';
import 'package:cheese_client/src/pages/profile_snap_post_detail/detail_bottom_sheet.dart';
import 'package:cheese_client/src/repositories/snap_post/params/snap_post_params.dart';
import 'package:cheese_client/src/router/page_routes.dart';
import 'package:cheese_client/src/styles/custom_color.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ProfileSnapPostDetailPage extends HookConsumerWidget {
  final String snapPostId;
  const ProfileSnapPostDetailPage({
    Key? key,
    required this.snapPostId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final snapshot =
        useFetchSnapPost(ref, FetchSnapPostParams(snapPostId: snapPostId));
    final snapPost = snapshot.data;

    final deleteMutation = useDeleteSnapPost(ref);

    Future<void> onBack() async {
      context.pop();
    }

    //TODO: 投稿の編集機能を実装する
    Future<void> onPressedEdit() async {}

    Future<void> onPressedDelete() async {
      await deleteMutation.mutate(
          params: DeleteSnapPostParams(snapPostId: snapPostId),
          option: MutationOption(onSuccess: (data) {
            context.go(PageRoutes.profile);
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
            return DetailBottomSheet(
                onPressedEdit: onPressedEdit, onPressedDelete: onPressedDelete);
          });
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
        actions: [
          IconButton(
            icon: const Icon(
              Icons.more_vert,
              color: Colors.black,
            ), // 3ドットマークのアイコン
            onPressed: onPressedDetail,
          ),
        ],
      ),
      body: Container(
        padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
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
