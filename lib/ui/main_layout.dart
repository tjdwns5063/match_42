import 'package:flutter/material.dart';
import 'package:match_42/ui/chat_list_page.dart';
import 'package:match_42/ui/match_page.dart';
import 'package:match_42/ui/my_page.dart';

class MainLayout extends StatefulWidget {
  const MainLayout({super.key});

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> with TickerProviderStateMixin {
  final List<Widget> _pages = const [MatchPage(), ChatListPage(), MyPage()];
  final List<String> _titles = const ['매칭', '채팅 목록', '채팅 목록'];
  late TabController controller;
  late String _title;

  @override
  void initState() {
    controller = TabController(length: 3, vsync: this)
      ..addListener(() {
        setState(() {
          _title = _titles[controller.index];
        });
      });
    _title = _titles[controller.index];
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ColorScheme colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: colorScheme.background,
        surfaceTintColor: Colors.transparent,
        scrolledUnderElevation: 0.0,
        centerTitle: false,
        title: Text(
          _title,
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
      bottomNavigationBar: SafeArea(
        child: TabBar(
          controller: controller,
          tabs: const [
            Tab(
              icon: Icon(Icons.person_search_rounded),
            ),
            Tab(
              icon: Icon(Icons.chat),
            ),
            Tab(
              icon: Icon(Icons.person),
            )
          ],
        ),
      ),
      body: TabBarView(
        physics: const NeverScrollableScrollPhysics(),
        controller: controller,
        children: _pages,
      ),
    );
  }
}
