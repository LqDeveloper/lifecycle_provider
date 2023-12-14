import 'package:example/pages/page_one.dart';
import 'package:flutter/material.dart';
import 'package:lifecycle_provider/lifecycle_provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const PageOne(),
      navigatorObservers: [LifecycleRouteObserver()],
    );
  }
}
