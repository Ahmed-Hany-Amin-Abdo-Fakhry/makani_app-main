import 'dart:io' show Platform;
import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';

abstract class RouterTransitions {
  static Page<void> getFadeTransitionPage(
    BuildContext context,
    GoRouterState state,
    Widget child,
  ) {
    if (Platform.isIOS) {
      return CupertinoPage<void>(
        key: state.pageKey,
        child: child,
      );
    }
    return CustomTransitionPage<void>(
      key: state.pageKey,
      child: child,
      transitionsBuilder: (_, animation, __, child) =>
          FadeTransition(opacity: animation, child: child),
    );
  }
}
