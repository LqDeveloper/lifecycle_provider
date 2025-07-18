import 'package:flutter/material.dart';

import 'package:meta/meta.dart';

import '../controller/lifecycle_mixin.dart';
import '../lifecycle/lifecycle_state.dart';
import '../lifecycle/state_lifecycle_mixin.dart';

@internal
class LifecycleObserverWidget<T extends LifecycleMixin> extends StatefulWidget {
  final WidgetBuilder builder;
  final int? pageIndex;
  final T controller;

  const LifecycleObserverWidget({
    super.key,
    required this.builder,
    required this.controller,
    this.pageIndex,
  });

  @override
  State<LifecycleObserverWidget> createState() =>
      _LifecycleObserverWidgetState();
}

class _LifecycleObserverWidgetState extends State<LifecycleObserverWidget>
    with StateLifecycleMixin {
  @override
  int get pageIndex => widget.pageIndex ?? -1;

  @override
  Widget build(BuildContext context) {
    return widget.builder(context);
  }

  @override
  void onPageContextReady(String? routeName, Object? arguments) {
    widget.controller.onLifecycleChanged(
      LifecycleState.onPageContextReady,
      context: context,
      routeName: routeName,
      arguments: arguments,
    );
  }

  @override
  void onLifecycleStateChanged(LifecycleState state) {
    super.onLifecycleStateChanged(state);
    if (state != LifecycleState.onPageContextReady) {
      widget.controller.onLifecycleChanged(state);
    }
  }
}
