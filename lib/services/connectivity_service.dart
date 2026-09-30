import 'package:connectivity_plus/connectivity_plus.dart';

/// Service to monitor network connectivity.
class ConnectivityService {
  final Connectivity _connectivity = Connectivity();

  /// Check if device is online.
  Future<bool> isOnline() async {
    final result = await _connectivity.checkConnectivity();
    return result != ConnectivityResult.none;
  }

  /// Stream of connectivity changes.
  Stream<List<ConnectivityResult>> get onConnectivityChanged =>
      _connectivity.onConnectivityChanged;
}
