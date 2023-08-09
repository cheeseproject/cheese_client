import 'package:cheese_client/src/components/ui/common/header.dart';
import 'package:cheese_client/src/entities/snap_post/snap_post.dart';
import 'package:cheese_client/src/entities/snap_post/tag_options.dart';
import 'package:cheese_client/src/hooks/domain/snap_route/use_create_snap_route.dart';
import 'package:cheese_client/src/hooks/helper/use_form_key.dart';
import 'package:cheese_client/src/hooks/helper/use_mutation.dart';
import 'package:cheese_client/src/pages/profile/snap_post_card.dart';
import 'package:cheese_client/src/providers/snap_post_provider.dart';
import 'package:cheese_client/src/repositories/snap_route/params/snap_route_params.dart';
import 'package:cheese_client/src/router/page_routes.dart';
import 'package:cheese_client/src/styles/custom_color.dart';
import 'package:cheese_client/src/utils/form_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

const favoriteIconPath = 'assets/images/favorite.png';
const mapIconPath = 'assets/images/map.png';

const dummyId = [
  'b3ab2d33-8917-4382-a7e8-37c2810fd192',
  '56dc4e7d-8ed7-4d3c-b86d-20c06f9d4070',
  '523447b9-6d92-4e70-8831-9f91018b7812',
  'cbab3969-e8ce-453c-abc7-a6f6a6df1ef4',
];

class SnapRouteSubmitPage extends HookConsumerWidget {
  const SnapRouteSubmitPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mutation = useCreateSnapRoute(ref);
    final selectedSnapPosts = ref.watch(snapPostProvider);
    final titleController = useTextEditingController();
    final formKey = useFormKey();
    Future<void> onBack() async {
      context.pop();
    }

    Future<void> onSubmit() async {
      if (!formKey.currentState!.validate()) return;
      if (selectedSnapPosts.isEmpty) return;
      final params = CreateSnapRouteParams(
          title: titleController.text,
          snapPostIds: selectedSnapPosts.map((e) => e.snapPostId).toList());
      mutation.mutate(
          params: params,
          option: MutationOption(onSuccess: (_) {
            // NOTE: 作成に成功したらグローバルで管理していた状態を全て削除
            ref.read(snapPostProvider.notifier).clear();
            context.go(PageRoutes.route);
          }, onError: (e) {
            print(e);
          }));
    }

    void onTapCard(String snapPostId) {
      context.push('${PageRoutes.snapPostDetail}/$snapPostId');
    }

    void onTapSelectingFromMap() {
      context.push(PageRoutes.map);     
    }

    return Scaffold(
        backgroundColor: CheeseColor.bgColor,
        appBar: Header(
          title: '投稿',
          leading: IconButton(
            onPressed: onBack,
            icon: const Icon(Icons.arrow_back_ios),
            color: Colors.black,
          ),
          actions: [
            TextButton(
              onPressed: onSubmit,
              child: const Text('保存',
                  style: TextStyle(
                      color: Colors.lightBlue,
                      fontWeight: FontWeight.bold,
                      fontSize: 16)),
            )
          ],
        ),
        body: SingleChildScrollView(
            child: Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 24.0, horizontal: 8.0),
                child: Column(
                  children: [
                    Form(
                      key: formKey,
                      child: _titleForm(controller: titleController),
                    ),
                    const SizedBox(height: 24.0),
                    _postSelectLabels(
                        controller: titleController,
                        onTapSelectingFromMap: onTapSelectingFromMap),
                    const SizedBox(height: 24.0),
                    const Divider(
                      height: 1,
                    ),
                    _snapPostCardList(
                        onTapCard: onTapCard, snapPosts: selectedSnapPosts)
                  ],
                ))));
  }

  Widget _titleForm({required TextEditingController controller}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'タイトル',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8.0),
          _titleInputField(controller: controller),
        ],
      ),
    );
  }

  Widget _postSelectLabels({
    required TextEditingController controller,
    required VoidCallback onTapSelectingFromMap,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'スポットを追加',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              InkWell(
                onTap: onTapSelectingFromMap,
                child: _postSelectLabel(
                    text: "マップから選択", imagePath: favoriteIconPath),
              ),
              _postSelectLabel(text: "リストから選択", imagePath: mapIconPath),
            ],
          ),
        ],
      ),
    );
  }

  Widget _titleInputField({required TextEditingController controller}) {
    return TextFormField(
      controller: controller,
      validator: (v) => FormValidator.validateRequired(v, 'タイトル'),
      decoration: const InputDecoration(
        border: InputBorder.none,
        hintText: 'タイトル',
        filled: true,
        fillColor: Colors.white,
      ),
    );
  }

  Widget _postSelectLabel({required String text, required String imagePath}) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 32.0),
      child: Column(children: [
        Image.asset(imagePath),
        const SizedBox(height: 8.0),
        Text(
          text,
          style: TextStyle(fontWeight: FontWeight.bold),
        )
      ]),
    );
  }

  Widget _snapPostCardList(
      {required List<SnapPost> snapPosts,
      required void Function(String) onTapCard}) {
    return GridView.count(
      // NOTE: GridViewの中でのアイテムのサイズを指定
      childAspectRatio: 0.7,
      // NOTE: GridViewの中でのアイテムの数を指定
      crossAxisCount: 2,
      shrinkWrap: true,

      // NOTE: GridViewのスクロールを無効化
      physics: const NeverScrollableScrollPhysics(),
      children: snapPosts
          .map((post) => InkWell(
                onTap: () => onTapCard(post.snapPostId),
                child: SnapPostCard(
                  title: post.title,
                  tags:
                      post.tags.map((e) => tagOptions.valueToLabel(e)).toList(),
                  imageUrl: post.postImages.first.imagePath,
                ),
              ))
          .toList(),
    );
  }
}
