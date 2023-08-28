import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:match_42/ui/chat_page.dart';
import 'package:match_42/ui/login_page.dart';
import 'package:match_42/ui/main_layout.dart';
import 'package:match_42/viewmodel/chat_list_viewmodel.dart';
import 'package:match_42/viewmodel/chat_viewmodel.dart';
import 'package:match_42/viewmodel/login_viewmodel.dart';
import 'package:match_42/viewmodel/mypage_viewmodel.dart';
import 'package:provider/provider.dart';

const String LOGIN_PATH = '/login';
const String MAIN_PATH = '/main';
const String CHAT_PATH = '/chat';

class MyRouter {
  static GoRouter router = GoRouter(initialLocation: LOGIN_PATH, routes: [
    GoRoute(
        path: LOGIN_PATH,
        builder: (context, _) {
          return const LoginPage();
        }),
    GoRoute(
        path: '/auth',
        builder: (context, _) {
          return LoginWeb();
        }),
    GoRoute(
        path: MAIN_PATH,
        builder: (context, _) {
          return MultiProvider(
            providers: [
              ChangeNotifierProvider(
                  create: (BuildContext context) => ChatListViewModel()),
              ChangeNotifierProvider(
                  create: (BuildContext context) => MyPageViewModel())
            ],
            child: const MainLayout(),
          );
        }),
    GoRoute(
        path: '$CHAT_PATH/:room_id',
        builder: (context, state) {
          return ChangeNotifierProvider(
              create: (context) => ChatViewModel(
                  roomId: state.pathParameters['room_id']!,
                  user: context.read<LoginViewModel>().user),
              child: const ChatPage());
        }),
  ]);
}
