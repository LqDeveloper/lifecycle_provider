import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import '../controller/notify_mixin.dart';

typedef CustomSelectorBuilder<T extends NotifyMixin> = Widget Function(
    BuildContext context, T controller, Widget? child);

class SelectorIds<T extends NotifyMixin> extends StatelessWidget {
  final List<String> ids;
  final CustomSelectorBuilder<T> builder;
  final Widget? child;

  const SelectorIds({
    Key? key,
    required this.ids,
    required this.builder,
    this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = context.read<T>();
    assert(controller.containsMultiId(ids), 'ids:$ids中包含没有注册的id ');
    return Selector<T, int>(
        child: child,
        selector: (BuildContext context, controller) =>
            controller.getMultiIdValue(ids),
        builder: (BuildContext context, int value, Widget? child) {
          return builder(context, controller, child);
        });
  }
}
