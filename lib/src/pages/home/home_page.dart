import 'package:cheese_client/src/components/ui/common/header.dart';
import 'package:cheese_client/src/components/ui/common/page_error.dart';
import 'package:cheese_client/src/components/ui/common/page_loading.dart';
import 'package:cheese_client/src/hooks/domain/snap_post/use_fetch_snap_posts_by_current_position.dart';
import 'package:cheese_client/src/pages/home/home_page_loading.dart';
import 'package:cheese_client/src/pages/home/swipe_snap_post_card.dart';
import 'package:cheese_client/src/pages/home/use_submit_likes.dart';
import 'package:cheese_client/src/styles/custom_color.dart';
import 'package:flutter/material.dart';
import 'package:appinio_swiper/appinio_swiper.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class HomePage extends HookConsumerWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AppinioSwiperController controller =
        useMemoized(() => AppinioSwiperController(), []);
    final snapshot = useFetchSnapPostsByCurrentPosition(ref);
    final snapPosts = snapshot.data ?? [];

    final likeController = useSubmitLikes(context, ref, snapPosts);

    void onSwipe(int index, AppinioSwiperDirection direction) {
      if (direction == AppinioSwiperDirection.right) {
        return likeController.like(snapPosts[index - 1]);
      }
      if (direction == AppinioSwiperDirection.left) return;
      // TODO: 上や下にスワイプした場合の処理をかく
    }

    Future<void> onEnd() async {
      likeController.submitLikes();
    }

    void onPressedLike(int index) {
      controller.swipeRight();
    }

    void onPressedDislike() {
      controller.swipeLeft();
    }

    if (snapshot.isLoading) return const HomePageLoading();

    if (snapshot.hasError) return const PageError();

    return Scaffold(
      backgroundColor: CheeseColor.bgColor,
      appBar: const Header(title: ""),
      body: AppinioSwiper(
        controller: controller,
        cardsCount: snapPosts.length,
        backgroundCardsCount: snapPosts.length,
        padding: const EdgeInsets.all(16.0),
        onSwipe: onSwipe,
        onEnd: onEnd,
        maxAngle: 0,
        cardsBuilder: (BuildContext context, int index) {
          final images =
              snapPosts[index].postImages.map((e) => e.imagePath).toList();
          return SwipeSnapPostCard(
              onPressedLike: () => onPressedLike(index),
              onPressedDislike: onPressedDislike,
              title: snapPosts[index].title,
              address: snapPosts[index].address,
              // firstImage: images.first,
              images: images);
        },
      ),
    );
  }
}
