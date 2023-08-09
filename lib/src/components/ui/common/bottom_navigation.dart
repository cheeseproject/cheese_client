import 'package:cheese_client/src/providers/page_provider.dart';
import 'package:cheese_client/src/router/page_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class BottomNavigation extends HookConsumerWidget {
  final _pages = [
    PageRoutes.home,
    PageRoutes.map,
    PageRoutes.submit,
    PageRoutes.route,
    PageRoutes.profile
  ];

  BottomNavigation({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // HACK: ボトムコンポーネントがページの状態を持っているのは良くない
    final pageState = ref.watch(pageProvider);

    void onItemTapped(BuildContext context, int index) {
      if (pageState == _pages[index]) return;
      ref.read(pageProvider.notifier).setPage(_pages[index]);
      context.go(_pages[index]);
    }

    // TODO: 同じページに遷移した時にボトムナビゲーションの状態が変わらないようにする
    return BottomNavigationBar(
      currentIndex: !_pages.contains(pageState) ? 0 : _pages.indexOf(pageState),
      onTap: (index) => onItemTapped(context, index),
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
            icon: Icon(Icons.collections_outlined), label: 'ホーム'),
        BottomNavigationBarItem(
            icon: Icon(Icons.location_on_outlined), label: 'マップ'),
        BottomNavigationBarItem(
            icon: Icon(Icons.add_box_outlined), label: '投稿'),
        BottomNavigationBarItem(icon: Icon(Icons.density_medium), label: 'ルート'),
        BottomNavigationBarItem(
            icon: Icon(Icons.person_outlined), label: 'マイページ'),
      ],
      type: BottomNavigationBarType.fixed,
    );
  }
}
