import 'package:cheese_client/src/exceptions/custom_exception.dart';
import 'package:cheese_client/src/repositories/location/location_repository.dart';
import 'package:geolocator/geolocator.dart';

class LocationRepositoryImpl implements LocationRepository {
  @override
  Future<Position> getCurrentPosition() async {
    try {
      await Geolocator.checkPermission();
    } catch (e) {
      throw CustomException.noLocationPermission();
    }
    try {
      await Geolocator.isLocationServiceEnabled();
    } catch (e) {
      throw CustomException.noLocationService();
    }
    try {
      return await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high,
          timeLimit: const Duration(seconds: 5));
    } catch (e) {
      throw CustomException.timeout();
    }
  }
}
