import 'package:flutter/material.dart';

class MainLayout extends StatefulWidget {
  const MainLayout({super.key, required this.title, required this.body});

  final String title;
  final Widget body;

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  int _page = 0;

  void _move(int page) {
    setState(() {
      _page = page;
    });
  }

  @override
  Widget build(BuildContext context) {
    ColorScheme colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: colorScheme.background,
        title: Text(
          widget.title,
          style: const TextStyle(fontSize: 24.0, fontWeight: FontWeight.w700),
        ),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.notifications_none,
              size: 32,
            ),
            onPressed: () {},
          )
        ],
      ),
      bottomNavigationBar: Theme(
        data: Theme.of(context).copyWith(splashColor: Colors.transparent),
        child: BottomNavigationBar(
          showUnselectedLabels: false,
          showSelectedLabels: false,
          onTap: _move,
          currentIndex: _page,
          items: const [
            BottomNavigationBarItem(
                icon: Icon(Icons.person_search_rounded), label: 'match'),
            BottomNavigationBarItem(icon: Icon(Icons.chat), label: 'chat'),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: 'my')
          ],
        ),
      ),
      body: widget.body,
    );
  }
}
