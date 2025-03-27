import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import '../controller/lifecycle_mixin.dart';
import 'lifecycle_observer_widget.dart';
import 'provider_context_extension.dart';

class ProviderStateBuilder<T extends LifecycleMixin> extends StatelessWidget {
  final int? pageIndex;
  final T Function(BuildContext context) create;
  final Widget Function(BuildContext context, T controller)? builder;
  final Widget? child;

  const ProviderStateBuilder({
    Key? key,
    this.pageIndex,
    required this.create,
    this.child,
    this.builder,
  }) : assert(
         (child == null && builder != null) ||
             (child != null && builder == null),
         'child 和 builder 不能同时为空或者同时不为空',
       ),
       super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<T>(
      create: create,
      child: Builder(
        builder: (cxt) {
          final controller = cxt.rc<T>();
          return LifecycleObserverWidget<T>(
            pageIndex: pageIndex,
            controller: controller,
            builder: (BuildContext context) {
              if (child != null) {
                return child!;
              } else {
                return builder!.call(context, controller);
              }
            },
          );
        },
      ),
    );
  }
}
