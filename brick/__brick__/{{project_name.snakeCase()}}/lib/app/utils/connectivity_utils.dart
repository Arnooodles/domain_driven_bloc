import 'dart:async';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:fpdart/fpdart.dart';
import 'package:http/http.dart' as http;
import 'package:injectable/injectable.dart';
import 'package:rxdart/rxdart.dart';
import 'package:{{project_name.snakeCase()}}/app/constants/constant.dart';
import 'package:{{project_name.snakeCase()}}/app/helpers/extensions/int_ext.dart';
import 'package:{{project_name.snakeCase()}}/app/helpers/extensions/status_code_ext.dart';
import 'package:{{project_name.snakeCase()}}/core/domain/entity/enum/connection_status.dart';

@lazySingleton
final class ConnectivityUtils {
  ConnectivityUtils() {
    _connectionSubscription = _connectivity.onConnectivityChanged
        .debounceTime(const Duration(milliseconds: 300))
        .listen((_) => _checkInternetConnection());
    _checkInternetConnection();
  }

  final Connectivity _connectivity = Connectivity();
  final BehaviorSubject<ConnectionStatus> _controller = BehaviorSubject<ConnectionStatus>.seeded(
    ConnectionStatus.online,
  );
  late final StreamSubscription<List<ConnectivityResult>> _connectionSubscription;
  ConnectionStatus _currentStatus = ConnectionStatus.online;

  bool get isConnected => _currentStatus == ConnectionStatus.online;
  bool get isNotConnected => !isConnected;

  Stream<ConnectionStatus> get internetStatus => _controller.stream;

  Future<void> _checkInternetConnection() async {
    final ConnectionStatus status = await checkInternet();
    _updateStatus(status);
  }

  Future<ConnectionStatus> checkInternet() async {
    try {
      final Either<List<InternetAddress>, http.Response> result = kIsWeb
          ? right(await http.get(Uri.parse(Constant.networkLookup)))
          : left(await InternetAddress.lookup(Constant.networkLookup));

      return result.fold(
        (List<InternetAddress> mobile) => mobile.isNotEmpty && mobile.first.rawAddress.isNotEmpty
            ? ConnectionStatus.online
            : ConnectionStatus.offline,
        (http.Response web) => web.statusCode.statusCode.isSuccess ? ConnectionStatus.online : ConnectionStatus.offline,
      );
    } on SocketException {
      return ConnectionStatus.offline;
    }
  }

  void _updateStatus(ConnectionStatus status) {
    if (_currentStatus != status) {
      _currentStatus = status;
      _controller.add(status);
    }
  }

  Future<void> dispose() async {
    await _connectionSubscription.cancel();
    await _controller.close();
  }
}
