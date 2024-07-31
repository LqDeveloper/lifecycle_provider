import 'package:flutter/material.dart';

import 'package:meta/meta.dart';

@internal
abstract class AppLifecycleObserver {
  void appLifecycleChanged(AppLifecycleState state) {}

  void appForeground() {}

  void appBackground() {}
}
