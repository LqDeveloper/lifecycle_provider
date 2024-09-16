import 'package:flutter/material.dart';

import 'package:meta/meta.dart';
import 'package:page_lifecycle/page_lifecycle.dart';

mixin LifecycleMixin on ChangeNotifier {
  String? _routeName;

  String? get routeName => _routeName;

  Object? _arguments;

  Object? get arguments => _arguments;

  LifecycleState _lifecycleState = LifecycleState.onPageInit;

  LifecycleState get lifecycleState => _lifecycleState;

  bool get isPageResume => _lifecycleState.isPageResume;

  bool get isPagePause => _lifecycleState.isPagePause;

  @internal
  @mustCallSuper
  void onLifecycleChanged(
    LifecycleState state, {
    BuildContext? context,
    String? routeName,
    Object? arguments,
  }) {
    _lifecycleState = state;
    switch (state) {
      case LifecycleState.onPageInit:
        onPageInit();
        break;
      case LifecycleState.onPageContextReady:
        setupRouteInfo(routeName, arguments);
        onPageContextReady(context);
        break;
      case LifecycleState.onPagePostFrame:
        onPagePostFrame();
        break;
      case LifecycleState.onPageReassemble:
        onPageReassemble();
        break;
      case LifecycleState.onPageStart:
        onPageStart();
        break;
      case LifecycleState.onPageResume:
        onPageResume();
        break;
      case LifecycleState.onPageEnterAnimationEnd:
        onPageEnterAnimationEnd();
        break;
      case LifecycleState.onPagePause:
        onPagePause();
        break;
      case LifecycleState.onPageStop:
        onPageStop();
        break;
      case LifecycleState.onPageLeaveAnimationEnd:
        onPageLeaveAnimationEnd();
        break;
      case LifecycleState.onPageDispose:
        onPageDispose();
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
      case LifecycleState.onAppForeground:
        onAppForeground();
        break;
      case LifecycleState.onAppBackground:
        onAppBackground();
        break;
      default:
        break;
    }
  }

  void setupRouteInfo(
    String? name,
    Object? arguments,
  ) {
    _routeName = name;
    _arguments = arguments;
  }

  @protected
  void onPageInit() {}

  @protected
  void onPageContextReady(BuildContext? context) {}

  @protected
  void onPagePostFrame() {}

  @protected
  void onPageReassemble() {}

  @protected
  void onPageStart() {}

  @protected
  void onPageResume() {}

  @protected
  void onPageEnterAnimationEnd() {}

  @protected
  void onPagePause() {}

  @protected
  void onPageStop() {}

  @protected
  void onPageLeaveAnimationEnd() {}

  @protected
  void onPageDispose() {}

  ///AppLifecycleState.resumed
  @protected
  void onAppResume() {}

  ///AppLifecycleState.inactive
  @protected
  void onAppInactive() {}

  ///AppLifecycleState.paused
  @protected
  void onAppPause() {}

  @protected
  void onAppForeground() {}

  @protected
  void onAppBackground() {}
}
