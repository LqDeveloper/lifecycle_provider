import 'package:example/pages/page_four.dart';
import 'package:example/pages/page_one.dart';
import 'package:example/pages/page_three.dart';
import 'package:example/pages/page_two.dart';
import 'package:flutter/material.dart';

///TabBarView 需要特别注意，因为是可以通过点击Tab进行页面切换，所以当跨页面切换的时候会缓存前一个或者后一个
///直接使用PageView就不会
class TabPage extends StatelessWidget {
  const TabPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('TabPage'),
      ),
      body: const DefaultTabController(
        length: 4,
        child: Column(
          children: [
            TabBar(
              tabs: [
                Tab(text: 'PageOne'),
                Tab(text: 'PageTwo'),
                Tab(text: 'PageThree'),
                Tab(text: 'PageFour'),
              ],
              labelColor: Colors.red,
              unselectedLabelColor: Colors.green,
            ),
            Expanded(
              child: TabBarView(
                children: [
                  PageOne(),
                  PageTwo(),
                  PageThree(),
                  PageFour(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
