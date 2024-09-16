import 'package:flutter/material.dart';
import 'package:lifecycle_provider/lifecycle_provider.dart';

import '../base_page_controller.dart';

class DialogPage extends StatefulWidget {
  const DialogPage({super.key});

  @override
  State<DialogPage> createState() => _DialogPageState();
}

class _DialogPageState extends BasePageState<DialogPage, DialogPageController> {
  @override
  DialogPageController createController(BuildContext context) {
    return DialogPageController();
  }

  @override
  Widget providerStateBuild(
      BuildContext context, DialogPageController controller) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('DialogPage'),
      ),
      body: InkWell(
        onTap: () {
          showDialog(
              context: context,
              builder: (cxt) {
                return AlertDialog(
                  title: const Text('这是弹窗'),
                  actions: [
                    TextButton(
                        onPressed: () {
                          Navigator.of(context)
                              .popUntil((route) => route.settings.name == '/');
                        },
                        child: const Text('dismiss'))
                  ],
                );
              });
        },
        child: const Center(
          child: Text('DialogPage'),
        ),
      ),
    );
  }
}

class DialogPageController extends BasePageController {
  @override
  void onPageResume() {
    super.onPageResume();
    logMessage("$runtimeType ---onPageResume");
  }

  @override
  void onPagePause() {
    super.onPagePause();
    logMessage("$runtimeType ---onPagePause");
  }
}
