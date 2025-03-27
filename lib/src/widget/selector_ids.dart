import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import '../controller/base_controller.dart';
import 'provider_context_extension.dart';

typedef CustomSelectorBuilder<E extends Enum, T extends BaseController<E>> =
    Widget Function(BuildContext context, T controller, Widget? child);

class SelectorIds<E extends Enum, T extends BaseController<E>>
    extends StatelessWidget {
  final List<E> ids;
  final CustomSelectorBuilder<E, T> builder;
  final Widget? child;

  const SelectorIds({
    super.key,
    required this.ids,
    required this.builder,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    final controller = context.rc<T>();
    assert(controller.containsMultiId(ids), 'ids:$ids中包含没有注册的id ');
    return Selector<T, int>(
      child: child,
      selector:
          (BuildContext context, controller) =>
              controller.updateMultiIdValue(ids),
      builder: (BuildContext context, int value, Widget? child) {
        return builder(context, controller, child);
      },
    );
  }
}
