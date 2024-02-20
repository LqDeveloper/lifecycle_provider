import 'package:flutter/material.dart';

import 'event_bus_mixin.dart';
import 'lifecycle_mixin.dart';
import 'notify_mixin.dart';

abstract class BaseController extends ChangeNotifier
    with NotifyMixin, LifecycleMixin, EventBusMixin {
  @override
  @mustCallSuper
  void onPageInit() {
    super.onPageInit();
    registerIds(shouldNotifyIds);
  }

  List<String> get shouldNotifyIds;
}
