import 'package:cheese_client/src/constants/map_url_template.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:latlong2/latlong.dart';

const userAgentPackageName = 'com.example.app';

class MapModal extends HookConsumerWidget {
  final void Function(LatLng) onPickedLatLng;
  final VoidCallback onPressedClose;
  final LatLng? initialLatLng;

  const MapModal({
    Key? key,
    required this.onPickedLatLng,
    required this.onPressedClose,
    this.initialLatLng,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // NOTE: mapの大きさを指定しないと、カラム内で表示できない
    const headerSize = 48.0;
    const modalRate = 0.82;
    final modalSize = MediaQuery.of(context).size.height * modalRate;
    final mapSize = modalSize - headerSize;

    final latLngState = useState<LatLng?>(initialLatLng);

    void onTap(dynamic tapPosition, LatLng latLng) {
      latLngState.value = latLng;
    }

    void onSubmit() {
      if (latLngState.value == null) return;
      onPickedLatLng(latLngState.value!);
    }

    return SizedBox(
      height: modalSize,
      width: modalSize,
      child: Column(
        children: [
          _header(
            onPressedClose: onPressedClose,
            onSubmit: onSubmit,
          ),
          SizedBox(
            height: mapSize,
            child: FlutterMap(
              options: MapOptions(
                onTap: onTap,
                center: initialLatLng,
                zoom: 16.0,
              ),
              children: [
                TileLayer(
                  urlTemplate: mapUrlTemplate,
                  userAgentPackageName: userAgentPackageName,
                ),
                MarkerLayer(markers: [
                  Marker(
                    width: 80.0,
                    height: 80.0,
                    point: latLngState.value ?? const LatLng(0, 0),
                    builder: (ctx) => const Icon(
                      Icons.location_on,
                      size: 40,
                      color: Colors.red,
                    ),
                  )
                ]),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _header(
      {required VoidCallback onPressedClose, required VoidCallback onSubmit}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          onPressed: onPressedClose,
          icon: const Icon(Icons.close),
        ),
        const Text(
          "スポットを選択して、ピンを立ててください",
          style: TextStyle(
            fontSize: 14.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        TextButton(
          onPressed: onSubmit,
          child: const Text('選択',
              style: TextStyle(
                  color: Colors.lightBlue,
                  fontWeight: FontWeight.bold,
                  fontSize: 16)),
        )
      ],
    );
  }
}
