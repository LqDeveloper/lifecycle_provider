import 'package:example/page_view/bottom_nav_page.dart';
import 'package:example/page_view/tab_page.dart';
import 'package:example/pages/dialog_page.dart';
import 'package:example/pages/drawer_page.dart';
import 'package:example/pages/index_stack_page.dart';
import 'package:example/pages/pop_page.dart';
import 'package:example/pages/pop_until_page.dart';
import 'package:example/pages/replace_page.dart';
import 'package:example/pages/update_page.dart';
import 'package:flutter/material.dart';
import 'package:lifecycle_provider/lifecycle_provider.dart';

import 'home_page.dart';
import 'root_controller.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  ControllerConfig.instance.controllerLog = true;
  ControllerConfig.instance.globalStateLog = false;
  AppLifecycleManager.instance.listen();
  runApp(const MyApp());
}

class MyApp extends BasePage<RootController> {
  const MyApp({super.key});

  @override
  RootController createController(BuildContext context) {
    return RootController();
  }

  @override
  Widget providerStateBuild(BuildContext context, RootController controller) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(primarySwatch: Colors.blue, useMaterial3: false),
      routes: {
        "/tabPage": (_) => const TabPage(),
        "/bottomNav": (_) => const BottomNavPage(),
        "/drawer": (_) => const DrawerPage(),
        "/popPage": (_) => const PopPage(),
        "/popUntilPage": (_) => const PopUntilPage(),
        "/replace": (_) => const ReplacePage(),
        "/dialog": (_) => const DialogPage(),
        "/updatePage": (_) => const UpdatePage(),
        "/indexStack": (_) => const IndexStackPage(),
      },
      home: const HomePage(),
      navigatorObservers: [LifecycleRouteObserver()],
    );
  }
}
