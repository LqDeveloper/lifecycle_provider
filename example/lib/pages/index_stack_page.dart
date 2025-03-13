import 'package:example/pages/page_four.dart';
import 'package:example/pages/page_one.dart';
import 'package:example/pages/page_three.dart';
import 'package:example/pages/page_two.dart';
import 'package:flutter/material.dart';
import 'package:lifecycle_provider/lifecycle_provider.dart';

class IndexStackPage extends StatefulWidget {
  const IndexStackPage({super.key});

  @override
  State<IndexStackPage> createState() => _IndexStackPageState();
}

class _IndexStackPageState extends State<IndexStackPage> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("IndexStack"),
      ),
      body: CustomIndexedStack(
        index: _currentIndex,
        children: const [
          PageOne(),
          PageTwo(),
          PageThree(),
          PageFour(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.red,
        unselectedItemColor: Colors.green,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
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
