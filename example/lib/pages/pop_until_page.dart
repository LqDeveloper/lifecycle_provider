import 'package:flutter/material.dart';
import 'package:lifecycle_provider/lifecycle_provider.dart';

import '../base_page_controller.dart';

class PopUntilPage extends BasePage<PopUntilPageController> {
  const PopUntilPage({super.key});

  @override
  PopUntilPageController createController(BuildContext context) {
    return PopUntilPageController();
  }

  @override
  Widget providerStateBuild(
      BuildContext context, PopUntilPageController controller) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('PopUntilPage'),
      ),
      body: InkWell(
        onTap: () {
          Navigator.of(context).popUntil((route) => route.settings.name == '/');
        },
        child: const Center(
          child: Text('PopUntilPage'),
        ),
      ),
    );
  }
}

class PopUntilPageController extends BasePageController {
  @override
  void onPageContextReady(BuildContext? context) {
    super.onPageContextReady(context);
    debugPrint(arguments.toString());
  }
}
