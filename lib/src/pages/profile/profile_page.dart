import 'package:cheese_client/src/components/ui/common/header.dart';
import 'package:cheese_client/src/components/ui/common/page_loading.dart';
import 'package:cheese_client/src/entities/snap_post/snap_post.dart';
import 'package:cheese_client/src/entities/snap_post/tag_options.dart';
import 'package:cheese_client/src/hooks/domain/auth/use_sign_out.dart';
import 'package:cheese_client/src/hooks/domain/user/use_update_user.dart';
import 'package:cheese_client/src/hooks/helper/use_mutation.dart';
import 'package:cheese_client/src/pages/profile/profile_page_loading.dart';
import 'package:cheese_client/src/pages/profile/profile_setting_modal.dart';
import 'package:cheese_client/src/pages/profile/snap_post_card.dart';
import 'package:cheese_client/src/pages/profile/use_fetch_profile.dart';
import 'package:cheese_client/src/providers/profile_provider.dart';
import 'package:cheese_client/src/repositories/user/params/user_params.dart';
import 'package:cheese_client/src/router/page_routes.dart';
import 'package:cheese_client/src/styles/custom_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';

import 'package:hooks_riverpod/hooks_riverpod.dart';

enum Tab { mine, like }

class ProfilePage extends HookConsumerWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final snapshot = useFetchProfile(ref);
    final updateMutation = useUpdateUser(ref);
    final signOutMutation = useSignOut(ref);
    final selectedTab = useState(Tab.mine);
    final displayedPosts = useMemoized(
        () => selectedTab.value == Tab.mine
            ? snapshot.mySnapPosts
            : snapshot.favoriteSnapPosts,
        [snapshot.favoriteSnapPosts, snapshot.mySnapPosts, selectedTab.value]);

    final user = snapshot.user;

    void onPressedMine() {
      selectedTab.value = Tab.mine;
    }

    void onPressedLike() {
      selectedTab.value = Tab.like;
    }

    void onTapCard(String snapPostId) {
      if (selectedTab.value == Tab.mine) {
        context.push('${PageRoutes.profilePostDetail}/$snapPostId');
      } else {
        print("call");
        context.push('${PageRoutes.snapPostDetail}/$snapPostId');
      }
    }

    Future<void> onSubmitProfile(
        {required String name,
        required String imageUrl,
        required double searchedRadiusInM}) async {
      final params = UpdateUserParams(
        name: name,
        iconPath: imageUrl,
        searchedRadiusInM: searchedRadiusInM,
      );
      await updateMutation.mutate(
          params: params,
          option: MutationOption(
            onSuccess: (res) async {
              snapshot.refetch();
              if (context.mounted) context.pop();
            },
            onError: (e) async {
              print(e);
            },
          ));
    }

    Future<void> onPressedSignOut() async {
      await signOutMutation.mutate();
      // NOTE: ログアウトしたらグローバルで管理しているプロフィールの状態をクリア
      await ref.read(userProvider.notifier).clearUser();
      if (context.mounted) context.go(PageRoutes.singIn);
    }

    Future<void> onPressedEditProfile(
        {required String name,
        required String imageUrl,
        required double searchedRadiusInM}) async {
      await showModalBottomSheet(
          context: context,
          // NOTE: trueにしないと、Containerのheightが反映されない
          isScrollControlled: true,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
          ),
          builder: (context) {
            return ProfileSettingModal(
                onPressedClose: () => context.pop(),
                onPressedSignOut: onPressedSignOut,
                onSubmit: onSubmitProfile,
                imageUrl: imageUrl,
                userName: name,
                searchedRadiusInM: searchedRadiusInM.toInt());
          });
    }

    if (snapshot.isLoading || user == null) return const ProfilePageLoading();

    return Scaffold(
        appBar: const Header(title: "マイページ"),
        backgroundColor: Colors.white,
        // NOTE: 画面全体をスクロースするように設定
        body: SingleChildScrollView(
          child: Column(children: [
            _profile(userName: user.name, imageUrl: user.iconPath),
            const SizedBox(height: 8.0),
            _editButton(
                onPressed: () => onPressedEditProfile(
                      name: user.name,
                      imageUrl: user.iconPath,
                      searchedRadiusInM: user.searchedRadiusInM.toDouble(),
                    )),
            const SizedBox(height: 16.0),
            _tabButtons(
              selectedTab: selectedTab.value,
              onPressedMine: onPressedMine,
              onPressedLike: onPressedLike,
            ),
            Container(
              color: CheeseColor.bgColor,
              child: _snapPostCardList(
                  snapPosts: displayedPosts, onTapCard: onTapCard),
            ),
          ]),
        ));
  }

  Widget _profile({required String userName, required String imageUrl}) {
    return Column(children: [
      const SizedBox(height: 16.0),
      CircleAvatar(radius: 42, backgroundImage: NetworkImage(imageUrl)),
      const SizedBox(height: 16.0),
      Text(
        userName,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
    ]);
  }

  Widget _editButton({required VoidCallback onPressed}) {
    return ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.grey[100],
          foregroundColor: Colors.black,
          elevation: 0,
        ),
        child: const Text(
          "プロフィール編集・設定",
        ));
  }

  Widget _tabButtons({
    required VoidCallback onPressedMine,
    required VoidCallback onPressedLike,
    required Tab selectedTab,
  }) {
    return Row(
      children: [
        Expanded(
            child: _tabButton(
                isActive: selectedTab == Tab.mine, onPressed: onPressedMine)),
        Expanded(
            child: _tabButton(
                isActive: selectedTab == Tab.like, onPressed: onPressedLike)),
      ],
    );
  }

  Widget _tabButton({required isActive, required VoidCallback onPressed}) {
    const BorderRadius borderRadius = BorderRadius.only(
      topRight: Radius.circular(4.0),
      bottomRight: Radius.circular(0.0),
      topLeft: Radius.circular(4.0),
      bottomLeft: Radius.circular(0.0),
    );
    return isActive
        ? ElevatedButton(
            onPressed: onPressed,
            style: ElevatedButton.styleFrom(
              elevation: 0,
              shape: const RoundedRectangleBorder(
                side: BorderSide(color: Colors.black),
                borderRadius: borderRadius,
              ),
            ),
            child: const Icon(Icons.apps_sharp, color: Colors.white),
          )
        : OutlinedButton(
            onPressed: onPressed,
            style: OutlinedButton.styleFrom(
              elevation: 0,
              shape: const RoundedRectangleBorder(
                // アンダーラインを引く
                side: BorderSide(color: Colors.black),
                borderRadius: borderRadius,
              ),
            ),
            child: const Icon(Icons.favorite_outline),
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
