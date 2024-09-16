import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('状态管理'),
      ),
      body: ListView(
        children: [
          ListItem(
              title: "TabBar场景",
              onTap: () {
                _push(context, '/tabPage');
              }),
          ListItem(
              title: "PageView场景",
              onTap: () {
                _push(context, '/bottomNav');
              }),
          ListItem(
              title: "Drawer场景",
              onTap: () {
                _push(context, '/drawer');
              }),
          ListItem(
              title: "Pop场景",
              onTap: () {
                _push(context, '/popPage');
              }),
          ListItem(
              title: "PopUntil场景",
              onTap: () {
                _push(context, '/popPage');
              }),
          ListItem(
              title: "Replace场景",
              onTap: () {
                _push(context, '/replace');
              }),
          ListItem(
              title: "Dialog场景",
              onTap: () {
                _push(context, '/dialog');
              }),
          ListItem(
              title: "更新组件场景",
              onTap: () {
                _push(context, '/updatePage');
              }),
        ],
      ),
    );
  }

  void _push(BuildContext context, String routeName) {
    Navigator.of(context).pushNamed(routeName);
  }
}

class ListItem extends StatelessWidget {
  final String title;
  final GestureTapCallback onTap;

  const ListItem({
    super.key,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 60,
      child: InkWell(
        onTap: onTap,
        child: ListTile(
          title: Text(title),
        ),
      ),
    );
  }
}
