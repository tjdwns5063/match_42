import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:match_42/local_notification.dart';
import 'package:match_42/ui/chat_list_page.dart';
import 'package:match_42/ui/match_page.dart';
import 'package:match_42/ui/my_page.dart';
import 'package:match_42/viewmodel/chat_list_viewmodel.dart';
import 'package:match_42/viewmodel/login_viewmodel.dart';
import 'package:match_42/viewmodel/mypage_viewmodel.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:match_42/ui/alarm_page.dart';

class MainLayout extends StatefulWidget {
  const MainLayout({super.key});

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> with TickerProviderStateMixin {
  final List<Widget> _pages = [
    const MatchPage(),
    const ChatListPage(),
    const MyPage(),
  ];
  final List<String> _titles = const ['매칭', '채팅', '마이페이지'];
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
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) async {
      NotificationSettings settings =
          await FirebaseMessaging.instance.requestPermission(
        alert: true,
        announcement: true,
        badge: true,
        carPlay: false,
        criticalAlert: true,
        provisional: true,
        sound: true,
      );
    });
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
    ChatListViewModel chatListViewModel = context.watch();

    return Scaffold(
      resizeToAvoidBottomInset: false,
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
            onPressed: () {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const AlarmPage()));
            },
          )
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: TabBar(
          controller: controller,
          tabs: [
            const Tab(
              icon: Icon(Icons.person_search_rounded),
            ),
            Tab(
              icon: ChatIcon(
                unread: chatListViewModel.totalUnread,
              ),
            ),
            const Tab(
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

class ChatIcon extends StatelessWidget {
  const ChatIcon({super.key, required this.unread});

  final int unread;

  @override
  Widget build(BuildContext context) {
    return (unread == 0)
        ? const Icon(Icons.chat)
        : Stack(
            alignment: Alignment.topRight,
            children: [
              const Align(
                alignment: Alignment.center,
                widthFactor: 1.5,
                child: Icon(
                  Icons.chat,
                  size: 25.0,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 2.0),
                child: Container(
                  alignment: Alignment.center,
                  height: 18,
                  width: 18,
                  decoration: const BoxDecoration(
                      shape: BoxShape.circle, color: Colors.red),
                  child: Text(
                    '${unread > 99 ? 99 : unread}',
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 11.0,
                        overflow: TextOverflow.ellipsis),
                  ),
                ),
              )
            ],
          );
  }
}
