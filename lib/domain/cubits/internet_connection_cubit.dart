import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

enum InternetConnectionState {
  initial,
  isConnected,
  isNotConnected,
}

class InternetConnectionCubit extends Cubit<InternetConnectionState> {
  bool connectionStatus = true;
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<ConnectivityResult> _connectivitySubscription;

  InternetConnectionCubit() : super(InternetConnectionState.initial) {
    _initialize();
  }

  Future<void> _initialize() async {
    // notifies about any connection changes
    _connectivitySubscription = _connectivity.onConnectivityChanged.listen(
      (result) async {

        if (result == ConnectivityResult.none) {
          connectionStatus = false;
          emit(InternetConnectionState.isNotConnected);
        } else {
          connectionStatus = true;
          emit(InternetConnectionState.isConnected);
        }
      },
    );
  }

  @override
  Future<void> close() async {
    await _connectivitySubscription.cancel();
    return super.close();
  }
}
