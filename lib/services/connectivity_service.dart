import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';

/// Service to check and monitor internet connectivity.
class ConnectivityService {
  ConnectivityService._();

  static final Connectivity _connectivity = Connectivity();

  /// Check if the device currently has internet access.
  static Future<bool> hasConnection() async {
    final result = await _connectivity.checkConnectivity();
    return !result.contains(ConnectivityResult.none);
  }

  /// Stream that emits connectivity changes.
  static Stream<List<ConnectivityResult>> get onConnectivityChanged {
    return _connectivity.onConnectivityChanged;
  }
}
