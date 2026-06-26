import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// App-wide BlocObserver for logging transitions and errors (debug).
class AppBlocObserver extends BlocObserver {
  const AppBlocObserver();

  @override
  void onChange(BlocBase<dynamic> bloc, Change<dynamic> change) {
    super.onChange(bloc, change);
    if (kDebugMode) {
      // ignore: avoid_print
      print(
        'BlocObserver ${bloc.runtimeType} onChange: '
        'current=${change.currentState.runtimeType} '
        'next=${change.nextState.runtimeType}',
      );
    }
  }

  @override
  void onError(BlocBase<dynamic> bloc, Object error, StackTrace stackTrace) {
    if (kDebugMode) {
      // ignore: avoid_print
      print('BlocObserver ${bloc.runtimeType} onError: $error');
    }
    super.onError(bloc, error, stackTrace);
  }
}
