import 'package:flutter/material.dart';

import 'package:meta/meta.dart';

import '../lifecycle/lifecycle_state.dart';

mixin LifecycleMixin on ChangeNotifier {
  String? _routeName;

  String? get routeName => _routeName;

  String? _routePath;

  String? get routePath => _routePath;

  Map<String, dynamic>? _arguments;

  Map<String, dynamic>? get arguments => _arguments;

  bool _isAppeared = false;

  bool get isAppeared => _isAppeared;

  @mustCallSuper
  void onLifecycleChanged(
    LifecycleState state, {
    BuildContext? context,
  }) {
    switch (state) {
      case LifecycleState.onInit:
        onInit();
        break;
      case LifecycleState.onContextReady:
        onContextReady(context);
        break;
      case LifecycleState.onPostFrame:
        onPostFrame();
        break;
      case LifecycleState.onPageStart:
        onPageStart();
        break;
      case LifecycleState.onPageResume:
        onPageResume();
        break;
      case LifecycleState.onPagePause:
        onPagePause();
        break;
      case LifecycleState.onPageStop:
        onPageStop();
        break;
      case LifecycleState.onAppResume:
        onAppResume();
        break;
      case LifecycleState.onAppInactive:
        onAppInactive();
        break;
      case LifecycleState.onAppPause:
        onAppPause();
        break;
      default:
        break;
    }
  }

  @internal
  void setupRouteInfo(
    String? name,
    String? path,
    Map<String, dynamic>? arguments,
  ) {
    _routeName = name;
    _routePath = path;
    _arguments = arguments;
  }

  @protected
  void onInit() {}

  @protected
  void onContextReady(BuildContext? context) {}

  @protected
  void onPostFrame() {}

  @protected
  @mustCallSuper
  void onPageStart() {
    _isAppeared = true;
  }

  @protected
  void onPageResume() {}

  @protected
  void onPagePause() {}

  @protected
  @mustCallSuper
  void onPageStop() {
    _isAppeared = false;
  }

  ///AppLifecycleState.resumed
  @protected
  void onAppResume() {}

  ///AppLifecycleState.inactive
  @protected
  void onAppInactive() {}

  ///AppLifecycleState.paused
  @protected
  void onAppPause() {}
}
