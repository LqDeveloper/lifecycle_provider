import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import '../widget/custom_index_stack.dart';
import 'app_lifecycle_manager.dart';
import 'app_lifecycle_observer.dart';
import 'lifecycle_route_aware.dart';
import 'lifecycle_route_observer.dart';
import 'lifecycle_state.dart';

mixin StateLifecycleMixin<T extends StatefulWidget> on State<T>
    implements AppLifecycleObserver, LifecycleRouteAware {
  bool _didRunOnContextReady = false;
  ModalRoute? _modalRoute;

  String? get routeName => _modalRoute?.settings.name;

  Object? get arguments => _modalRoute?.settings.arguments;

  bool _isInPageView = false;
  RenderSliver? _renderSliver;
  bool _isIndexStack = false;
  CustomRenderIndexedStack? _renderIndexedStack;
  StreamSubscription<int?>? _indexStackSub;

  int get pageIndex => -1;

  int _currentIndex = -1;

  bool _hasAppear = false;
  bool _hasResume = false;
  bool _hasDispose = false;

  ScrollNotificationObserverState? _scrollState;

  final StreamController<LifecycleState> _lifecycleController =
      StreamController.broadcast();

  Stream<LifecycleState> get lifecycleStream => _lifecycleController.stream;

  @override
  void initState() {
    super.initState();
    AppLifecycleManager.instance.addObserver(this);
    onPageInit();
    onLifecycleStateChanged(LifecycleState.onPageInit);
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if (_hasDispose) {
        return;
      }
      onPagePostFrame();
      onLifecycleStateChanged(LifecycleState.onPagePostFrame);
      _initRenderState();
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_didRunOnContextReady) {
      _didRunOnContextReady = true;
      _modalRoute = ModalRoute.of(context);
      if (_modalRoute == null) {
        return;
      }
      LifecycleRouteObserver.instance.subscribe(_modalRoute!, this);
      onPageContextReady(
          _modalRoute?.settings.name, _modalRoute?.settings.arguments);
      onLifecycleStateChanged(LifecycleState.onPageContextReady);
      _modalRoute?.animation?.addStatusListener(_handlerAnimationStatus);
    }
  }

  @override
  void reassemble() {
    super.reassemble();
    if (kDebugMode) {
      onPageReassemble();
      onLifecycleStateChanged(LifecycleState.onPageReassemble);
    }
  }

  @override
  void dispose() {
    _hasDispose = true;
    _renderSliver = null;
    _renderIndexedStack = null;
    _indexStackSub?.cancel();
    _modalRoute?.animation?.removeStatusListener(_handlerAnimationStatus);
    _checkNotifyPageStop();
    AppLifecycleManager.instance.removeObserver(this);
    LifecycleRouteObserver.instance.unsubscribe(this);
    _disposeScrollState();
    _modalRoute = null;
    onPageDispose();
    onLifecycleStateChanged(LifecycleState.onPageDispose);
    super.dispose();
  }

  ///forward -> completed -> reverse -> dismissed
  void _handlerAnimationStatus(AnimationStatus status) {
    if (status == AnimationStatus.completed) {
      onPageEnterAnimationEnd();
      onLifecycleStateChanged(LifecycleState.onPageEnterAnimationEnd);
    } else if (status == AnimationStatus.dismissed) {
      onPageLeaveAnimationEnd();
      onLifecycleStateChanged(LifecycleState.onPageLeaveAnimationEnd);
    }
  }

  void _initRenderState() {
    _findAncestorRenderObj();
    if (_renderSliver != null && _renderSliver is RenderSliverFillViewport) {
      _isInPageView = true;
      assert(pageIndex > -1, "当前页面位于PageView中，必须设置pageIndex ");
      _scrollState = ScrollNotificationObserver.maybeOf(context);
      _scrollState?.addListener(_scrollNotification);
      return;
    } else if (_renderIndexedStack != null ||
        _renderIndexedStack is CustomRenderIndexedStack) {
      _isIndexStack = true;
      assert(pageIndex > -1, "当前页面位于CustomRenderIndexedStack中，必须设置pageIndex ");
      _checkIndexStackIndex();
      return;
    } else {
      _notifyPageStart();
    }
  }

  void _findAncestorRenderObj({int maxCycleCount = 10}) {
    final obj = context.findRenderObject();
    if (obj == null) {
      return;
    }
    int currentCycleCount = 1;
    var parent = obj.parent;
    while (parent != null && currentCycleCount <= maxCycleCount) {
      if (parent is RenderSliver) {
        _renderSliver = parent;
        return;
      } else if (parent is CustomRenderIndexedStack) {
        _renderIndexedStack = parent;
        return;
      }
      parent = parent.parent;
      currentCycleCount++;
    }
  }

  void _checkIndexStackIndex() {
    if (!_isIndexStack) {
      return;
    }
    if (_indexStackSub != null) {
      _indexStackSub?.cancel();
      _indexStackSub = null;
    }
    final index = _renderIndexedStack?.index ?? 0;
    _checkCurrentPageIndex(index);
    _indexStackSub = _renderIndexedStack?.stream.listen((val) {
      if (val == null) {
        return;
      }
      _checkCurrentPageIndex(val);
    });
  }

  void _scrollNotification(ScrollNotification notification) {
    if (notification.depth > 0) {
      return;
    }
    if (notification is ScrollUpdateNotification) {
      _handlePageView(notification: notification);
    }
  }

  void _handlePageView({required ScrollNotification notification}) {
    if (!_isInPageView) {
      return;
    }
    if (notification.metrics is! PageMetrics) {
      return;
    }
    final PageMetrics metrics = notification.metrics as PageMetrics;
    final int index = metrics.page!.round();
    _checkCurrentPageIndex(index);
  }

  void _checkCurrentPageIndex(int index) {
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
    if (_isInPageView || _isIndexStack) {
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
    if (_isInPageView || _isIndexStack) {
      if (_currentIndex != pageIndex) {
        return;
      }
      _notifyPageStop();
    } else {
      _notifyPageStop();
    }
  }

  void _notifyPageStart() {
    if (_hasAppear) {
      return;
    }
    _hasAppear = true;
    onPageStart();
    onLifecycleStateChanged(LifecycleState.onPageStart);
    _notifyPageResume();
  }

  void _notifyPageResume() {
    if (_hasResume) {
      return;
    }
    _hasResume = true;
    onPageResume();
    onLifecycleStateChanged(LifecycleState.onPageResume);
  }

  void _notifyPagePause() {
    if (!_hasResume) {
      return;
    }
    _hasResume = false;
    onPagePause();
    onLifecycleStateChanged(LifecycleState.onPagePause);
  }

  void _notifyPageStop() {
    if (!_hasAppear) {
      return;
    }
    _hasAppear = false;
    _notifyPagePause();
    onPageStop();
    onLifecycleStateChanged(LifecycleState.onPageStop);
  }

  ///*********************************************
  @protected
  void onPageInit() {}

  @protected
  void onPageContextReady(String? routeName, Object? arguments) {}

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

  @protected
  void onAppResume() {}

  @protected
  void onAppInactive() {}

  @protected
  void onAppPause() {}

  @protected
  void onAppForeground() {}

  @protected
  void onAppBackground() {}

  @protected
  @mustCallSuper
  void onLifecycleStateChanged(LifecycleState state) {
    _lifecycleController.add(state);
  }

  @protected
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
  void appLifecycleChanged(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
        onAppResume();
        onLifecycleStateChanged(LifecycleState.onAppResume);
        break;
      case AppLifecycleState.inactive:
        onAppInactive();
        onLifecycleStateChanged(LifecycleState.onAppInactive);
        break;
      case AppLifecycleState.paused:
        onAppPause();
        onLifecycleStateChanged(LifecycleState.onAppPause);
        break;
      default:
        break;
    }
  }

  @override
  void appBackground() {
    onAppBackground();
    onLifecycleStateChanged(LifecycleState.onAppBackground);
  }

  @override
  void appForeground() {
    onAppForeground();
    onLifecycleStateChanged(LifecycleState.onAppForeground);
  }
}
