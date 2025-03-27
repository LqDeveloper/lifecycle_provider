import 'package:flutter/material.dart';

import '../controller/lifecycle_mixin.dart';
import 'provider_context_extension.dart';
import 'provider_state_builder.dart';

mixin PageMixin<T extends LifecycleMixin> {
  Widget getProviderWidget(BuildContext context) {
    return ProviderStateBuilder(
      pageIndex: pageIndex,
      create: createController,
      child: Builder(
        builder: (BuildContext context) {
          return providerStateBuild(context, context.rc<T>());
        },
      ),
    );
  }

  int get pageIndex => -1;

  T createController(BuildContext context);

  Widget providerStateBuild(BuildContext context, T controller);
}
