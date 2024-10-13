import 'package:flutter/material.dart';

import 'event_bus_mixin.dart';
import 'lifecycle_mixin.dart';
import 'notify_mixin.dart';

abstract class BaseController<T extends Enum> extends ChangeNotifier
    with NotifyMixin<T>, LifecycleMixin, EventBusMixin {
  @override
  @mustCallSuper
  void onPageInit() {
    super.onPageInit();
    registerIds(shouldNotifyIds);
  }

  @override
  @mustCallSuper
  void onPageReassemble() {
    super.onPageReassemble();
    registerIds(shouldNotifyIds);
  }

  List<T> get shouldNotifyIds;
}
