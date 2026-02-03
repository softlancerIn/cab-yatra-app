import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class Nav {
  /// GoRouter: Push with custom transition
  static push(BuildContext context, String route, {Object? extra}) =>
      context.push(route, extra: extra);

  static pushReplace(BuildContext context, String route, {Object? extra}) =>
      context.pushReplacement(route, extra: extra);

  static go(BuildContext context, String route, {Object? extra}) =>
      context.go(route, extra: extra);

  static goToHomeAndClear(BuildContext context, String route, {Object? extra}) {
    context.go(route, extra: extra);
  }

  static goAndClear(BuildContext context, String route, {Object? extra}) =>
      context.go(route, extra: extra);

  static pop(BuildContext context) {
    if (Navigator.canPop(context)) Navigator.pop(context);
  }

  /// Material transitions
  static pushSlide(BuildContext context, Widget page) {
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (_, __, ___) => page,
        transitionsBuilder: (_, anim, __, child) {
          return SlideTransition(
            position: Tween(begin: const Offset(1, 0), end: Offset.zero)
                .animate(anim),
            child: child,
          );
        },
      ),
    );
  }

  static pushFade(BuildContext context, Widget page) {
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (_, __, ___) => page,
        transitionsBuilder: (_, anim, __, child) {
          return FadeTransition(opacity: anim, child: child);
        },
      ),
    );
  }

  static pushBottomToTop(BuildContext context, Widget page) {
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (_, __, ___) => page,
        transitionsBuilder: (_, anim, __, child) {
          return SlideTransition(
            position: Tween(begin: const Offset(0, 1), end: Offset.zero)
                .animate(anim),
            child: child,
          );
        },
      ),
    );
  }
}
