import 'package:internet_connection_checker/internet_connection_checker.dart';

abstract interface class INetworkInfo {
  Future<bool> get isConnected;
}

class NetworkInfoImpl implements INetworkInfo {
  final InternetConnectionChecker? internetConnectionChecker;

  NetworkInfoImpl({required this.internetConnectionChecker});

  @override
  Future<bool> get isConnected => internetConnectionChecker!.hasConnection;
}
