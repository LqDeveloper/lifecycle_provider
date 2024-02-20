import 'package:flutter/material.dart';

import '../controller/base_controller.dart';
import 'selector_ids.dart';

abstract class BaseWidget<T extends BaseController> extends StatelessWidget {
  const BaseWidget({super.key});

  List<String> get observeIds;

  @override
  Widget build(BuildContext context) {
    return SelectorIds<T>(
      ids: observeIds,
      builder: buildWidget,
    );
  }

  Widget buildWidget(
    BuildContext context,
    T controller,
    Widget? child,
  );
}
