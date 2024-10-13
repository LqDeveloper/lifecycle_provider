import 'package:flutter/material.dart';

import '../pages/page_four.dart';
import '../pages/page_one.dart';
import '../pages/page_three.dart';
import '../pages/page_two.dart';

class BottomNavPage extends StatefulWidget {
  const BottomNavPage({super.key});

  @override
  State<BottomNavPage> createState() => _BottomNavPageState();
}

class _BottomNavPageState extends State<BottomNavPage> {
  final List<Widget> _pages = const [
    PageOne(),
    PageTwo(),
    PageThree(),
    PageFour(),
  ];

  final PageController controller = PageController();

  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('BottomNavPage'),
      ),
      // body: PageView.builder(
      //   controller: controller,
      //   itemBuilder: (_, index) => _pages[index],
      // ),
      body: PageView(
        controller: controller,
        children: _pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.red,
        unselectedItemColor: Colors.green,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
          controller.jumpToPage(index);
        },
        currentIndex: _currentIndex,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'PageOne'),
          BottomNavigationBarItem(icon: Icon(Icons.ac_unit), label: 'PageTwo'),
          BottomNavigationBarItem(
              icon: Icon(Icons.access_alarm), label: 'PageThree'),
          BottomNavigationBarItem(
              icon: Icon(Icons.accessibility_new), label: 'PageFour'),
        ],
      ),
    );
  }
}
