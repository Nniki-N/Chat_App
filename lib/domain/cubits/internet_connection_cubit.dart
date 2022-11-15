import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

enum InternetConnectionState {
  initial,
  isConnected,
  isNotConnected,
}

class InternetConnectionCubit extends Cubit<InternetConnectionState> {
  ConnectivityResult _connectionStatus = ConnectivityResult.none;
  bool connectionStatus = false;
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<ConnectivityResult> _connectivitySubscription;

  InternetConnectionCubit() : super(InternetConnectionState.initial) {
    _initialize();
  }

  Future<void> _initialize() async {
    // init first connection state
    initConnectivity();

    // listen connection changes
    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen((result) async {
      _connectionStatus = result;

      if (result == ConnectivityResult.none) {
        connectionStatus = false;
        emit(InternetConnectionState.isNotConnected);
      } else {
        connectionStatus = true;
        emit(InternetConnectionState.isConnected);
      }

      print(
          '------------------------------------------------------------------------------- ------------------------ 1');
    });
  }

  Future<void> initConnectivity() async {
    ConnectivityResult result;

    try {
      result = await _connectivity.checkConnectivity();
    } on Exception {
      return;
    }

    // _updateConnectionStatus(result);
  }

  // void _updateConnectionStatus(ConnectivityResult result) {
  //   _connectionStatus = result;

  //   if (_connectionStatus == ConnectivityResult.none) {
  //     emit(InternetConnectionState.isNotConnected);
  //   } else {
  //     emit(InternetConnectionState.isConnected);
  //   }

  //   print(
  //       '------------------------------------------------------------------------------- ------------------------ 1');
  // }

  @override
  Future<void> close() async {
    await _connectivitySubscription.cancel();
    return super.close();
  }
}
