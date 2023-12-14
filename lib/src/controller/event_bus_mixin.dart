import 'dart:async';

import 'package:flutter/material.dart';

import '../event_bus/global_event_bus.dart';

mixin EventBusMixin on ChangeNotifier {
  final List<StreamSubscription> _subscriptions = [];

  @protected
  Stream<T> on<T>() {
    return GlobalEventBus.on<T>();
  }

  @protected
  void observeEvent<T>(void Function(T event)? onData,
      {Function? onError, void Function()? onDone, bool? cancelOnError}) {
    StreamSubscription<T> sub = on<T>().listen(onData,
        onError: onError, onDone: onDone, cancelOnError: cancelOnError);
    _subscriptions.add(sub);
  }

  @protected
  void fire(event) {
    GlobalEventBus.fire(event);
  }

  @override
  void dispose() {
    for (StreamSubscription sub in _subscriptions) {
      sub.cancel();
    }
    super.dispose();
  }
}
