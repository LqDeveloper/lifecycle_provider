import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import 'context_scroll_extension.dart';
import 'lifecycle_route_aware.dart';
import 'lifecycle_route_observer.dart';
import 'lifecycle_state.dart';

mixin StateLifecycleMixin<T extends StatefulWidget> on State<T>
    implements WidgetsBindingObserver, LifecycleRouteAware {
  bool _didRunOnContextReady = false;
  ModalRoute? _modalRoute;

  String? get routeName => _modalRoute?.settings.name;

  Object? get arguments => _modalRoute?.settings.arguments;

  bool _isInPageView = false;

  int get pageIndex => -1;

  int _currentIndex = -1;

  bool _hasAppear = false;
  bool _hasResume = false;

  ScrollNotificationObserverState? _scrollState;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    onInit();
    onLifecycleStateChanged(LifecycleState.onInit);
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      onPostFrame();
      onLifecycleStateChanged(LifecycleState.onPostFrame);
      _initPageViewState();
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_didRunOnContextReady) {
      _didRunOnContextReady = true;
      _modalRoute = ModalRoute.of(context);
      if (_modalRoute == null) return;
      LifecycleRouteObserver.instance.subscribe(_modalRoute!, this);
      onContextReady(
          _modalRoute?.settings.name, _modalRoute?.settings.arguments);
      onLifecycleStateChanged(LifecycleState.onContextReady);
    }
  }

  @override
  void dispose() {
    _checkNotifyPageStop();
    WidgetsBinding.instance.removeObserver(this);
    LifecycleRouteObserver.instance.unsubscribe(this);
    _disposeScrollState();
    _modalRoute = null;
    onPageDispose();
    onLifecycleStateChanged(LifecycleState.onPageDispose);
    super.dispose();
  }

  void _initPageViewState() {
    final renderSliver = context.findAncestorRenderObj<RenderSliver>();
    if (renderSliver is! RenderSliverFillViewport) {
      _notifyPageStart();
      return;
    }
    _isInPageView = true;
    assert(
        pageIndex > -1, "pageIndex must set,when page is PageView's subpage");
    //添加滚动监听 混入这个mixin的StatefulWidget 必须存在于 Scaffold 中，否则就无法监听滚动
    //或者在PageView父节点中使用ScrollNotificationObserver包裹住
    _scrollState = ScrollNotificationObserver.maybeOf(context);
    _scrollState?.addListener(_scrollNotification);
  }

  void _scrollNotification(ScrollNotification notification) {
    //ScrollNotification冒泡通过的Viewport的个数必须为0,才会去响应
    if (notification.depth > 0) return;
    if (notification is ScrollUpdateNotification) {
      _handlePageView(notification: notification);
    }
  }

  void _handlePageView({required ScrollNotification notification}) {
    if (!_isInPageView) return;
    if (notification.metrics is! PageMetrics) return;
    final PageMetrics metrics = notification.metrics as PageMetrics;
    final int index = metrics.page!.round();
    if (index != _currentIndex) {
      if (index == pageIndex) {
        Future.delayed(Duration.zero, () {
          _notifyPageStart();
        });
      } else {
        _notifyPageStop();
      }
      if (_currentIndex != -1) {
        onPageViewChanged(_currentIndex, index);
      }
      _currentIndex = index;
    }
  }

  void _disposeScrollState() {
    _scrollState?.removeListener(_scrollNotification);
    _scrollState = null;
  }

  void _checkNotifyPageStart() {
    if (_isInPageView) {
      if (_currentIndex != pageIndex) {
        return;
      }
      _notifyPageStart();
    } else {
      _notifyPageStart();
    }
  }

  void _checkNotifyPageResume() {
    if (_hasAppear) {
      _notifyPageResume();
    }
  }

  void _checkNotifyPagePause() {
    if (_hasAppear) {
      _notifyPagePause();
    }
  }

  void _checkNotifyPageStop() {
    if (_isInPageView) {
      if (_currentIndex != pageIndex) {
        return;
      }
      _notifyPageStop();
    } else {
      _notifyPageStop();
    }
  }

  void _notifyPageStart() {
    if (_hasAppear) return;
    _hasAppear = true;
    onPageStart();
    onLifecycleStateChanged(LifecycleState.onPageStart);
    _notifyPageResume();
  }

  void _notifyPageResume() {
    if (_hasResume) return;
    _hasResume = true;
    onPageResume();
    onLifecycleStateChanged(LifecycleState.onPageResume);
  }

  void _notifyPagePause() {
    if (!_hasResume) return;
    _hasResume = false;
    onPagePause();
    onLifecycleStateChanged(LifecycleState.onPagePause);
  }

  void _notifyPageStop() {
    if (!_hasAppear) return;
    _hasAppear = false;
    _notifyPagePause();
    onPageStop();
    onLifecycleStateChanged(LifecycleState.onPageStop);
  }

  ///*********************************************
  void onInit() {}

  void onContextReady(String? routeName, Object? arguments) {}

  void onPostFrame() {}

  void onPageStart() {}

  void onPageResume() {}

  void onPagePause() {}

  void onPageStop() {}

  void onPageDispose() {}

  void onAppResume() {}

  void onAppInactive() {}

  void onAppPause() {}

  void onLifecycleStateChanged(LifecycleState state) {}

  void onPageViewChanged(int from, int to) {}

  ///*********************RouteAware*************************
  @override
  void routePageStart() {
    _checkNotifyPageStart();
  }

  @override
  void routePageResume() {
    _checkNotifyPageResume();
  }

  @override
  void routePagePause() {
    _checkNotifyPagePause();
  }

  @override
  void routePageStop() {
    _checkNotifyPageStop();
  }

  @override
  void didChangeAccessibilityFeatures() {}

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
        onAppResume();
        onLifecycleStateChanged(LifecycleState.onAppResume);
        break;
      case AppLifecycleState.paused:
        onAppPause();
        onLifecycleStateChanged(LifecycleState.onAppPause);
        break;
      case AppLifecycleState.inactive:
        onAppInactive();
        onLifecycleStateChanged(LifecycleState.onAppInactive);
        break;
      default:
        break;
    }
  }

  @override
  void didChangeLocales(List<Locale>? locales) {}

  @override
  void didChangeMetrics() {}

  @override
  void didChangePlatformBrightness() {}

  @override
  void didChangeTextScaleFactor() {}

  @override
  void didHaveMemoryPressure() {}

  @override
  Future<bool> didPopRoute() => Future<bool>.value(false);

  @override
  Future<bool> didPushRoute(String route) => Future<bool>.value(false);

  @override
  Future<bool> didPushRouteInformation(RouteInformation routeInformation) =>
      didPushRoute(routeInformation.location!);
}
