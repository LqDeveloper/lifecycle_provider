import 'package:flutter/material.dart';
import 'package:lifecycle_provider/lifecycle_provider.dart';

import '../base_page_controller.dart';

class ReplacePage extends BasePage<ReplacePageController> {
  const ReplacePage({super.key});

  @override
  ReplacePageController createController(BuildContext context) {
    return ReplacePageController();
  }

  @override
  Widget providerStateBuild(
      BuildContext context, ReplacePageController controller) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ReplacePage'),
      ),
      body: InkWell(
        onTap: () {
          Navigator.of(context).pushReplacementNamed("/popPage");
        },
        child: const Center(
          child: Text('ReplacePage'),
        ),
      ),
    );
  }
}

class ReplacePageController extends BasePageController {
  @override
  void onPageEnterAnimationEnd() {
    super.onPageEnterAnimationEnd();
    logMessage("$runtimeType ---onPageEnterAnimationEnd");
  }

  @override
  void onPageLeaveAnimationEnd() {
    super.onPageLeaveAnimationEnd();
    logMessage("$runtimeType ---onPageLeaveAnimationEnd");
  }
}
