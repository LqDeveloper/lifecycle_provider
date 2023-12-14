import 'package:example/pages/page_two.dart';
import 'package:flutter/material.dart';
import 'package:lifecycle_provider/lifecycle_provider.dart';

class PageOne extends BasePage<PageOneController> {
  const PageOne({super.key});

  @override
  PageOneController createController(BuildContext context) {
    return PageOneController();
  }

  @override
  Widget providerStateBuild(
      BuildContext context, PageOneController controller) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('PageOne'),
      ),
      body: Center(
        child: TextButton(
          onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(builder: (_) {
              return const PageTwo();
            }));
          },
          child: const Text('点击跳转'),
        ),
      ),
    );
  }
}

class PageOneController extends BaseController {
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
