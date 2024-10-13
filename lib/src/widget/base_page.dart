import 'package:flutter/material.dart';

import '../controller/lifecycle_mixin.dart';
import 'page_mixin.dart';

abstract class BasePage<T extends LifecycleMixin> extends StatelessWidget
    with PageMixin<T> {
  const BasePage({super.key});

  @override
  Widget build(BuildContext context) {
    return getProviderWidget(context);
  }
}
