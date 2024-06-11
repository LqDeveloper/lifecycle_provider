import 'package:flutter/material.dart';
import 'package:lifecycle_provider/lifecycle_provider.dart';

class RootEventId {
  RootEventId._();

  static const updateStatus = 'updateStatus';

  static const List<String> events = [updateStatus];
}

class RootController extends BaseController {
  @override
  List<String> get shouldNotifyIds => RootEventId.events;

  int _count = 0;

  int get count => _count;

  void increase() {
    _count++;
    notifySingleListener(RootEventId.updateStatus);
  }

  @override
  void onPageInit() {
    super.onPageInit();
    logMessage("$runtimeType ---onPageInit");
  }

  @override
  void onPageContextReady(BuildContext? context) {
    super.onPageContextReady(context);
    logMessage("$runtimeType ---onPageContextReady");
  }

  @override
  void onPagePostFrame() {
    super.onPagePostFrame();
    logMessage("$runtimeType ---onPagePostFrame");
  }

  @override
  void onPageStart() {
    super.onPageStart();
    logMessage("$runtimeType ---onPageStart");
  }

  @override
  void onPageResume() {
    super.onPageResume();
    logMessage("$runtimeType ---onPageResume");
  }

  @override
  void onPageEnterAnimationEnd() {
    super.onPageEnterAnimationEnd();
    logMessage("$runtimeType ---onPageEnterAnimationEnd");
  }

  @override
  void onPagePause() {
    super.onPagePause();
    logMessage("$runtimeType ---onPagePause");
  }

  @override
  void onPageStop() {
    super.onPageStop();
    logMessage("$runtimeType ---onPageStop");
  }

  @override
  void onPageLeaveAnimationEnd() {
    super.onPageLeaveAnimationEnd();
    logMessage("$runtimeType ---onPageLeaveAnimationEnd");
  }

  @override
  void onPageDispose() {
    super.onPageDispose();
    logMessage("$runtimeType ---onPageDispose");
  }

  @override
  void onAppForeground() {
    super.onAppForeground();
    logMessage("$runtimeType ---onAppForeground");
  }

  @override
  void onAppBackground() {
    super.onAppBackground();
    logMessage("$runtimeType ---onAppBackground");
  }
}
