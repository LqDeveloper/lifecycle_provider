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
    Key? key,
    required this.builder,
    required this.controller,
    this.pageIndex,
  }) : super(key: key);

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
  void onContextReady(String? routeName, Object? arguments) {
    widget.controller.onLifecycleChanged(
      LifecycleState.onContextReady,
      context: context,
    );
  }

  @override
  void onLifecycleStateChanged(LifecycleState state) {
    if (state != LifecycleState.onContextReady) {
      widget.controller.onLifecycleChanged(state);
    }
  }
}
