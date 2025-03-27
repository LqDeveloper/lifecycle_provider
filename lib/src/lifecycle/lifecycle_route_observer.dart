import 'package:flutter/material.dart';

import 'package:meta/meta.dart';

import 'lifecycle_route_aware.dart';

class LifecycleRouteObserver extends NavigatorObserver {
  static final LifecycleRouteObserver instance = LifecycleRouteObserver._();

  factory LifecycleRouteObserver() => instance;

  LifecycleRouteObserver._();

  final Map<Route<dynamic>, Set<LifecycleRouteAware>> _listeners =
      <Route<dynamic>, Set<LifecycleRouteAware>>{};

  @internal
  void subscribe(ModalRoute route, LifecycleRouteAware routeAware) {
    final Set<LifecycleRouteAware> subscribers = _listeners.putIfAbsent(
      route,
      () => <LifecycleRouteAware>{},
    );
    subscribers.add(routeAware);
  }

  @internal
  void unsubscribe(LifecycleRouteAware routeAware) {
    final List<Route<dynamic>> routes = _listeners.keys.toList();
    for (final Route<dynamic> route in routes) {
      final Set<LifecycleRouteAware>? subscribers = _listeners[route];
      if (subscribers != null) {
        subscribers.remove(routeAware);
        if (subscribers.isEmpty) {
          _listeners.remove(route);
        }
      }
    }
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    final List<LifecycleRouteAware>? subscribers = _listeners[route]?.toList();
    if (subscribers != null) {
      for (final LifecycleRouteAware routeAware in subscribers) {
        routeAware.routePageStop();
      }
    }

    final bool isPop = route is PopupRoute;
    final List<LifecycleRouteAware>? previousSubscribers =
        _listeners[previousRoute]?.toList();
    if (previousSubscribers != null) {
      for (final LifecycleRouteAware routeAware in previousSubscribers) {
        if (isPop) {
          routeAware.routePageResume();
        } else {
          routeAware.routePageStart();
        }
      }
    }
  }

  @override
  void didRemove(Route route, Route? previousRoute) {
    super.didRemove(route, previousRoute);
    final List<LifecycleRouteAware>? subscribers = _listeners[route]?.toList();
    if (subscribers != null) {
      for (final LifecycleRouteAware routeAware in subscribers) {
        routeAware.routePageStop();
      }
    }

    final List<LifecycleRouteAware>? previousSubscribers =
        _listeners[previousRoute]?.toList();
    if (previousSubscribers != null) {
      for (final LifecycleRouteAware routeAware in previousSubscribers) {
        routeAware.routePageStart();
      }
    }
  }

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    final Set<LifecycleRouteAware>? previousSubscribers =
        _listeners[previousRoute];
    final bool isPop = route is PopupRoute;
    if (previousSubscribers != null) {
      for (final LifecycleRouteAware routeAware in previousSubscribers) {
        if (isPop) {
          routeAware.routePagePause();
        } else {
          routeAware.routePageStop();
        }
      }
    }
  }
}
