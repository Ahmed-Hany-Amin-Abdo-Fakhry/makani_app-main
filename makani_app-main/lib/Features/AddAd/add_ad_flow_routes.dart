import 'package:flutter/material.dart';

/// Route names for the nested Navigator inside [SellTab].
abstract final class AddAdFlowRoutes {
  static const String type = '/sellFlow/type';
  static const String location = '/sellFlow/location';
  static const String details = '/sellFlow/details';
  static const String photos = '/sellFlow/photos';
  static const String review = '/sellFlow/review';
  static const String publishSuccess = '/sellFlow/publishSuccess';
}

extension AddAdFlowNavigation on BuildContext {
  void pushAddAdFlow(String routeName) {
    Navigator.of(this).pushNamed(routeName);
  }

  void popAddAdFlow() {
    final nav = Navigator.of(this);
    if (nav.canPop()) nav.pop();
  }

  void popAddAdFlowToType() {
    Navigator.of(this).popUntil(
      (route) =>
          route.settings.name == AddAdFlowRoutes.type || route.isFirst,
    );
  }
}
