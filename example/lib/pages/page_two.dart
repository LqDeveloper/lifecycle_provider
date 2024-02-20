import 'package:example/pages/login_event.dart';
import 'package:flutter/material.dart';
import 'package:lifecycle_provider/lifecycle_provider.dart';

import '../base_page_controller.dart';

class PageTwo extends StatefulWidget {
  const PageTwo({super.key});

  @override
  State<PageTwo> createState() => _PageTwoState();
}

class _PageTwoState extends BasePageState<PageTwo, PageTwoController> {
  @override
  PageTwoController createController(BuildContext context) {
    return PageTwoController();
  }

  @override
  int get pageIndex => 1;

  @override
  bool get wantKeepAlive => true;

  @override
  Widget providerStateBuild(
      BuildContext context, PageTwoController controller) {
    return Scaffold(
      body: Center(
        child: InkWell(
            onTap: () {
              Navigator.of(context).pushNamed('/popPage');
            },
            child: const Text('PageTwo')),
      ),
    );
  }
}

class PageTwoController extends BasePageController {
  @override
  void onPageInit() {
    super.onPageInit();
    observeEvent<LoginEvent>((event) {
      debugPrint('接收到了登录事件----${event.isLogin} -- $lifecycleState');
    });
    observeEvent<LogoutEvent>((event) {
      debugPrint('接收到了退出登录事件 -- $lifecycleState');
    });
  }
}
