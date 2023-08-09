import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class CustomMarker extends Marker {
  final String markerId;

  final LatLng point;
  final double width;
  final double height;
  final Widget Function(BuildContext) builder;

  CustomMarker({
    required this.point,
    required this.width,
    required this.height,
    required this.builder,
    required this.markerId,
  }) : super(
          point: point,
          width: width,
          height: height,
          builder: builder,
        );
}
