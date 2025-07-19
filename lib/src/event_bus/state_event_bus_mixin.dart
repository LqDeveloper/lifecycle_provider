import 'dart:async';

import 'package:flutter/material.dart';

import 'global_event_bus.dart';

mixin StateEventBusMixin<S extends StatefulWidget> on State<S> {
  final List<StreamSubscription> _subscriptions = [];

  Stream<T> _on<T>() {
    return GlobalEventBus.observeEvent<T>();
  }

  @protected
  void observeEvent<T>(void Function(T event) onData) {
    final StreamSubscription<T> sub = _on<T>().listen(onData);
    _subscriptions.add(sub);
  }

  @protected
  void dispatchEvent<T>(T event) {
    GlobalEventBus.dispatchEvent<T>(event);
  }

  @override
  void dispose() {
    for (StreamSubscription sub in _subscriptions) {
      sub.cancel();
    }
    _subscriptions.clear();
    super.dispose();
  }
}
