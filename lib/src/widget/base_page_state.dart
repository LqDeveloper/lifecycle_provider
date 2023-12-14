import 'package:flutter/material.dart';

import '../controller/lifecycle_mixin.dart';
import 'page_mixin.dart';

abstract class BasePageState<T extends LifecycleMixin, S extends StatefulWidget>
    extends State<S> with PageMixin<T>, AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => false;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return getProviderWidget(context);
  }
}
