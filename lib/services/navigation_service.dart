import 'package:flutter/material.dart';

class NavigationService {
  final GlobalKey<NavigatorState> rootNavigatorKey =
      GlobalKey<NavigatorState>();
  final GlobalKey<NavigatorState> homeNavigatorKey =
      GlobalKey<NavigatorState>();
  final GlobalKey<NavigatorState> searchNavigatorKey =
      GlobalKey<NavigatorState>();
  final GlobalKey<NavigatorState> messageNavigatorKey =
      GlobalKey<NavigatorState>();
  final GlobalKey<NavigatorState> notificationNavigatorKey =
      GlobalKey<NavigatorState>();

  Future<dynamic> rootNavigateTo(String routeName) {
    return rootNavigatorKey.currentState.pushNamed(routeName);
  }

  Future<dynamic> homeNavigateTo(String routeName) {
    return homeNavigatorKey.currentState.pushNamed(routeName);
  }

  Future<dynamic> searchNavigatorTo(String routeName) {
    return searchNavigatorKey.currentState.pushNamed(routeName);
  }

  Future<dynamic> messageNavigatorTo(String routeName) {
    return messageNavigatorKey.currentState.pushNamed(routeName);
  }

  Future<dynamic> notificationNavigatorTo(String routeName) {
    return notificationNavigatorKey.currentState.pushNamed(routeName);
  }

  void resetAllNavigators() {
    homeNavigatorKey.currentState.popUntil((route) => route.isFirst);
    searchNavigatorKey.currentState.popUntil((route) => route.isFirst);
    messageNavigatorKey.currentState.popUntil((route) => route.isFirst);
    notificationNavigatorKey.currentState.popUntil((route) => route.isFirst);
    rootNavigatorKey.currentState.popUntil((route) => route.isFirst);
  }
}
