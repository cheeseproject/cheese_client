import 'package:cheese_client/src/repositories/location/location_repository_impl.dart';
import 'package:cheese_client/src/repositories/location/location_repository.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final locationRepositoryProvider = Provider<LocationRepository>((ref) {
  return LocationRepositoryImpl();
});
