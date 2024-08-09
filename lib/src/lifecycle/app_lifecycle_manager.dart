import 'dart:async';

import 'package:flutter/material.dart';

import 'app_lifecycle_observer.dart';

class AppLifecycleManager extends WidgetsBindingObserver {
  static final AppLifecycleManager instance = AppLifecycleManager._();

  AppLifecycleManager._();

  factory AppLifecycleManager() => instance;

  bool _hanListen = false;

  bool _isFromAppPause = false;

  final List<AppLifecycleObserver> _observers = [];

  final StreamController<bool> _streamController = StreamController.broadcast();

  Stream<bool> get isForeground => _streamController.stream;

  final StreamController<AppLifecycleState> _lifecycleController =
      StreamController.broadcast();

  Stream<AppLifecycleState> get lifecycle => _lifecycleController.stream;

  void listen() {
    if (_hanListen) {
      return;
    }
    _hanListen = true;
    WidgetsBinding.instance.addObserver(this);
  }

  void cancel() {
    if (!_hanListen) {
      return;
    }
    _hanListen = false;
    WidgetsBinding.instance.removeObserver(this);
  }

  void addObserver(AppLifecycleObserver observer) {
    assert(_hanListen, "请现执行AppLifecycleManager.instance.listen()");
    assert(!_observers.contains(observer), "当前观察者已经添加");
    if (_observers.contains(observer)) {
      return;
    }
    _observers.add(observer);
  }

  void removeObserver(AppLifecycleObserver observer) {
    assert(_hanListen, "请现执行AppLifecycleManager.instance.listen()");
    assert(_observers.contains(observer), "当前观察者没有添加");
    if (!_observers.contains(observer)) {
      return;
    }
    _observers.remove(observer);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    _lifecycleController.add(state);
    for (final observer in _observers) {
      _notifyObserver(state, observer);
    }
  }

  void _notifyObserver(AppLifecycleState state, AppLifecycleObserver observer) {
    observer.appLifecycleChanged(state);
    switch (state) {
      case AppLifecycleState.resumed:
        if (_isFromAppPause) {
          _isFromAppPause = false;
          _streamController.add(true);
          observer.appForeground();
        }
        break;
      case AppLifecycleState.paused:
        _isFromAppPause = true;
        observer.appBackground();
        _streamController.add(false);
        break;
      default:
        break;
    }
  }
}
