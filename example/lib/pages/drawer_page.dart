import 'package:flutter/material.dart';
import 'package:lifecycle_provider/lifecycle_provider.dart';

class DrawerPage extends BasePage<DrawerPageController> {
  const DrawerPage({super.key});

  @override
  DrawerPageController createController(BuildContext context) {
    return DrawerPageController();
  }

  @override
  Widget providerStateBuild(
      BuildContext context, DrawerPageController controller) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Drawer'),
      ),
      drawer: Container(
        color: Colors.deepOrange,
        width: 200,
      ),
      endDrawer: Container(
        color: Colors.deepPurple,
        width: 200,
      ),
      onDrawerChanged: (isOpen) {
        debugPrint("drawer:$isOpen");
      },
      onEndDrawerChanged: (isOpen) {
        debugPrint("endDrawer:$isOpen");
      },
    );
  }
}

enum DrawerEvent { none }

class DrawerPageController extends BaseController<DrawerEvent> {
  @override
  List<DrawerEvent> get shouldNotifyIds => DrawerEvent.values;

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
  void onPagePause() {
    super.onPagePause();
    logMessage("$runtimeType ---onPagePause");
  }

  @override
  void onPageStop() {
    super.onPageStop();
    logMessage("$runtimeType ---onPageStop");
  }
}
