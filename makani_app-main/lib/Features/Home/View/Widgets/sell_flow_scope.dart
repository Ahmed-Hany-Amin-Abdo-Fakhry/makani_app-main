import 'package:flutter/material.dart';

/// Provides [onGoHome] for the nested add-listing flow inside Sell tab.
class SellFlowScope extends InheritedWidget {
  const SellFlowScope({
    super.key,
    required this.onGoHome,
    required super.child,
  });

  /// Switch main shell to Home tab (e.g. back from step 1 or after publish).
  final VoidCallback onGoHome;

  static SellFlowScope? maybeOf(BuildContext context) {
    return context.getInheritedWidgetOfExactType<SellFlowScope>();
  }

  @override
  bool updateShouldNotify(covariant SellFlowScope oldWidget) {
    return onGoHome != oldWidget.onGoHome;
  }
}
