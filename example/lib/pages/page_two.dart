import 'package:flutter/material.dart';
import 'package:lifecycle_provider/lifecycle_provider.dart';

class PageTwo extends BasePage<PageTwoController> {
  const PageTwo({super.key});

  @override
  PageTwoController createController(BuildContext context) {
    return PageTwoController();
  }

  @override
  Widget providerStateBuild(
      BuildContext context, PageTwoController controller) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('PageTwo'),
      ),
      body: Center(
        child: TextButton(
          onPressed: () {
            showDialog(
                context: context,
                builder: (cxt) {
                  return AlertDialog(
                    title: const Text('这是Dialog'),
                    actions: [
                      TextButton(onPressed: () {}, child: const Text('弹出弹窗'))
                    ],
                  );
                });
          },
          child: const Text('点击跳转'),
        ),
      ),
    );
  }
}

class PageTwoController extends BaseController {
  @override
  List<String> get shouldNotifyIds => [];

  @override
  void onPageStart() {
    super.onPageStart();
    logMessage("$runtimeType -- onPageStart");
  }

  @override
  void onPageResume() {
    super.onPageResume();
    logMessage("$runtimeType -- onPageResume");
  }

  @override
  void onPagePause() {
    super.onPagePause();
    logMessage("$runtimeType -- onPagePause");
  }

  @override
  void onPageStop() {
    super.onPageStop();
    logMessage("$runtimeType -- onPageStop");
  }
}
