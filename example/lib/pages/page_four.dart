import 'package:example/root_controller.dart';
import 'package:flutter/material.dart';
import 'package:lifecycle_provider/lifecycle_provider.dart';

import '../base_page_controller.dart';

class PageFour extends StatefulWidget {
  const PageFour({super.key});

  @override
  State<PageFour> createState() => _PageFourState();
}

class _PageFourState extends BasePageState<PageFour, PageFourController> {
  @override
  PageFourController createController(BuildContext context) {
    return PageFourController();
  }

  @override
  int get pageIndex => 3;

  @override
  bool get wantKeepAlive => true;

  @override
  Widget providerStateBuild(
      BuildContext context, PageFourController controller) {
    return const Scaffold(
      body: Center(
        child: _CountWidget(),
      ),
    );
  }
}

enum PageFourEvent { none }

class PageFourController extends BasePageController<PageFourEvent> {}

class _CountWidget extends SelectorIdsView<RootEvent, RootController> {
  const _CountWidget();

  @override
  Widget buildWidget(BuildContext context, RootController controller) {
    return Text('RootController 中Count的值是：${controller.count}');
  }

  @override
  List<RootEvent> get observeIds => [RootEvent.updateStatus];
}
