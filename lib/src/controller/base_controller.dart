import 'package:flutter/material.dart';

import 'lifecycle_mixin.dart';
import 'notify_mixin.dart';

abstract class BaseController extends ChangeNotifier
    with NotifyMixin, LifecycleMixin {
  @override
  @mustCallSuper
  void onInit() {
    super.onInit();
    registerIds(shouldNotifyIds);
  }

  List<String> get shouldNotifyIds;
}
