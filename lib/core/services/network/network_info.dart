import 'package:data_connection_checker/data_connection_checker.dart';

abstract class NetworkInfo {
  Future<bool> get isConnected;
}

class NetworkInfoImpl implements NetworkInfo {
  final DataConnectionChecker connectionChecker;

  DataConnectionStatus _connectionStatus;

  NetworkInfoImpl(this.connectionChecker) {
    connectionChecker.onStatusChange.listen((event) {
      _connectionStatus = event;
    });
  }

  @override
  Future<bool> get isConnected {
    if (_connectionStatus == null) {
      return connectionChecker.hasConnection;
    } else {
      return Future<bool>.value(_connectionStatus == DataConnectionStatus.connected);
    }
  }
}
