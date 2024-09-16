import 'package:flutter/material.dart';
import 'package:lifecycle_provider/lifecycle_provider.dart';

import '../base_page_controller.dart';
import 'login_event.dart';

class PageThree extends StatefulWidget {
  const PageThree({super.key});

  @override
  State<PageThree> createState() => _PageThreeState();
}

class _PageThreeState extends BasePageState<PageThree, PageThreeController> {
  @override
  PageThreeController createController(BuildContext context) {
    return PageThreeController();
  }

  @override
  int get pageIndex => 2;

  @override
  bool get wantKeepAlive => true;

  @override
  Widget providerStateBuild(
      BuildContext context, PageThreeController controller) {
    return const Scaffold(
      body: Center(
        child: ObserveWidget(),
      ),
    );
  }
}

enum PageThreeEvent { updateState }

class PageThreeController extends BasePageController<PageThreeEvent> {
  @override
  List<PageThreeEvent> get shouldNotifyIds => PageThreeEvent.values;

  bool _isLogin = false;

  bool get isLogin => _isLogin;

  void _setupIsLogin(bool value) {
    _isLogin = value;
    notifySingleListener(PageThreeEvent.updateState);
  }

  @override
  void onPageInit() {
    super.onPageInit();
    observeEvent<LoginEvent>((event) {
      _setupIsLogin(true);
    });
    observeEvent<LogoutEvent>((event) {
      _setupIsLogin(false);
    });
  }
}

class ObserveWidget
    extends SelectorIdsView<PageThreeEvent, PageThreeController> {
  const ObserveWidget({super.key});

  @override
  Widget buildWidget(BuildContext context, PageThreeController controller) {
    if (controller.isLogin) {
      return const Text('当前是登录状态');
    } else {
      return const Text('当前是未登录状态');
    }
  }

  @override
  List<PageThreeEvent> get observeIds => [PageThreeEvent.updateState];
}
