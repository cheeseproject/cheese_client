import 'package:cheese_client/src/components/ui/common/aspect_ratio_image.dart';
import 'package:flutter/material.dart';

class SnapPostMarker extends StatelessWidget {
  final String image;

  const SnapPostMarker({super.key, required this.image});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
      ),
      padding: const EdgeInsets.all(4),
      child: AspectRatioImage(
        image: image,
        borderRadius: 100,
      ),
    );
  }
}
