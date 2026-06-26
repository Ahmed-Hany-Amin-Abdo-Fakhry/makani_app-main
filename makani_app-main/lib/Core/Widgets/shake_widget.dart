import 'package:flutter/material.dart';

/// Wraps [child] and plays a horizontal shake when [controller] is forwarded.
/// Create an [AnimationController] with duration ~300ms and call
/// [controller.forward] (e.g. from a BlocListener on error) to trigger.
class ShakeWidget extends AnimatedWidget {
  const ShakeWidget({
    super.key,
    required this.controller,
    required this.child,
  }) : super(listenable: controller);

  final AnimationController controller;
  final Widget child;

  static final Animatable<double> _shakeCurve = TweenSequence<double>([
    TweenSequenceItem(tween: Tween(begin: 0.0, end: 1.0), weight: 25),
    TweenSequenceItem(tween: Tween(begin: 1.0, end: -1.0), weight: 25),
    TweenSequenceItem(tween: Tween(begin: -1.0, end: 1.0), weight: 25),
    TweenSequenceItem(tween: Tween(begin: 1.0, end: 0.0), weight: 25),
  ]);

  @override
  Widget build(BuildContext context) {
    final animation = _shakeCurve.animate(controller);
    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(animation.value * 8, 0),
          child: child,
        );
      },
      child: child,
    );
  }
}
