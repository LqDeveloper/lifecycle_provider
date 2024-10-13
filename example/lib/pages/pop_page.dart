import 'package:flutter/material.dart';
import 'package:lifecycle_provider/lifecycle_provider.dart';

class PopPage extends BasePage<PopPageController> {
  const PopPage({super.key});

  @override
  PopPageController createController(BuildContext context) {
    return PopPageController();
  }

  @override
  Widget providerStateBuild(
      BuildContext context, PopPageController controller) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('PopPage'),
      ),
      body: InkWell(
        onTap: () {
          Navigator.of(context).pushNamed(
            "/popUntilPage",
            arguments: {
              'name': '这是你传递的参数',
            },
          );
        },
        child: const Center(
          child: Text('PopPage'),
        ),
      ),
    );
  }
}

enum PageOneEvent { none }

class PopPageController extends BaseController<PageOneEvent> {
  @override
  List<PageOneEvent> get shouldNotifyIds => [];

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
  void onAppResume() {
    super.onAppResume();
    logMessage("$runtimeType ---onAppResume");
  }

  @override
  void onAppPause() {
    super.onAppPause();
    logMessage("$runtimeType ---onAppPause");
  }
}
