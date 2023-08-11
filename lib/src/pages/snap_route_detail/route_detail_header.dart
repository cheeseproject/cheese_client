import 'package:flutter/material.dart';

// HACK: このWidgetはRouteDetailPageに依存している
class RouteDetailHeader extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final VoidCallback onPressedAction;
  final VoidCallback onPressedBack;

  const RouteDetailHeader({
    super.key,
    required this.title,
    required this.onPressedAction,
    required this.onPressedBack,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight * 2);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(title,
          style: const TextStyle(
              color: Colors.black, fontWeight: FontWeight.bold, fontSize: 16)),
      backgroundColor: Colors.white,
      elevation: 0,
      leading: IconButton(
        onPressed: onPressedBack,
        icon: const Icon(Icons.arrow_back_ios),
        color: Colors.black,
      ),
      actions: [
        IconButton(
          icon: const Icon(
            Icons.more_vert,
            color: Colors.black,
          ), // 3ドットマークのアイコン
          onPressed: onPressedAction,
        ),
      ],
      bottom: const TabBar(
        tabs: [
          Tab(
            child: Text("地図",
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 16)),
          ),
          Tab(
            child: Text("ルート",
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 16)),
          ),
        ],
      ),
    );
  }
}
