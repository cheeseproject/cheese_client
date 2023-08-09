import 'package:latlong2/latlong.dart';

class OverviewPolylinePoint {
  final String value;

  OverviewPolylinePoint(this.value);

  List<LatLng> decode() {
    var list = value.codeUnits;
    List lList = [];
    int index = 0;
    int len = value.length;
    int c = 0;
    List<LatLng> positions = [];
    // repeating until all attributes are decoded
    do {
      var shift = 0;
      int result = 0;

      // for decoding value of one attribute
      do {
        c = list[index] - 63;
        result |= (c & 0x1F) << (shift * 5);
        index++;
        shift++;
      } while (c >= 32);
      /* if value is negetive then bitwise not the value */
      if (result & 1 == 1) {
        result = ~result;
      }
      var result1 = (result >> 1) * 0.00001;
      lList.add(result1);
    } while (index < len);

    /*adding to previous value as done in encoding */
    for (int i = 2; i < lList.length; i++) {
      lList[i] += lList[i - 2];
    }

    for (int i = 0; i < lList.length; i += 2) {
      positions.add(LatLng(lList[i], lList[i + 1]));
    }

    return positions;
  }
}
