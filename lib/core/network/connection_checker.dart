import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

abstract interface class ConnectionChecker {
  Future<bool> get isConnected;
}

class ConnectionCheckerImpl implements ConnectionChecker {
  final InternetConnection internetConnection;
  ConnectionCheckerImpl(this.internetConnection);

//can use the stream part of the plugin  to know if the internet is going to connected or going to disconnected
  @override
  Future<bool> get isConnected async =>
      await internetConnection.hasInternetAccess;
}
