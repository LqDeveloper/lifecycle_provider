import 'package:flutter/material.dart';
import 'package:lifecycle_provider/lifecycle_provider.dart';

import '../base_page_controller.dart';

class UpdatePage extends BasePage<UpdatePageController> {
  const UpdatePage({super.key});

  @override
  UpdatePageController createController(BuildContext context) {
    return UpdatePageController();
  }

  @override
  Widget providerStateBuild(
      BuildContext context, UpdatePageController controller) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('UpdatePage'),
      ),
      body: Center(
        child: SelectorIds<UpdatePageController>(
            ids: const [UpdatePageEvent.update],
            builder: (_, controller, __) {
              return Text('当前的值是：${controller.count}');
            }),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => controller.increase(),
        child: const Icon(Icons.add),
      ),
    );
  }
}

class UpdatePageEvent {
  UpdatePageEvent._();

  static const update = "updateValue";
  static const List<String> _events = [update];
}

class UpdatePageController extends BasePageController {
  @override
  List<String> get shouldNotifyIds => UpdatePageEvent._events;

  int _count = 0;

  int get count => _count;

  void increase() {
    _count++;
    notifySingleListener(UpdatePageEvent.update);
  }
}
