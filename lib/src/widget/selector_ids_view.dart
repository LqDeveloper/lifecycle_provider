import 'package:flutter/material.dart';

import '../controller/base_controller.dart';
import 'selector_ids.dart';

abstract class SelectorIdsView<E extends Enum, T extends BaseController<E>>
    extends StatelessWidget {
  const SelectorIdsView({super.key});

  List<E> get observeIds;

  @override
  Widget build(BuildContext context) {
    return SelectorIds<E, T>(
      ids: observeIds,
      builder: (cxt, controller, _) {
        return buildWidget(cxt, controller);
      },
    );
  }

  Widget buildWidget(BuildContext context, T controller);
}
