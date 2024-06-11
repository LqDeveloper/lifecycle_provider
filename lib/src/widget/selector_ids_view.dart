import 'package:flutter/material.dart';

import '../controller/notify_mixin.dart';
import 'selector_ids.dart';

abstract class SelectorIdsView<T extends NotifyMixin> extends StatelessWidget {
  const SelectorIdsView({super.key});

  List<String> get observeIds;

  @override
  Widget build(BuildContext context) {
    return SelectorIds<T>(
      ids: observeIds,
      builder: (cxt, controller, _) {
        return buildWidget(cxt, controller);
      },
    );
  }

  Widget buildWidget(BuildContext context, T controller);
}
