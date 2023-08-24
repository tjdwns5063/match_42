import 'package:go_router/go_router.dart';
import 'package:match_42/ui/chat_list_page.dart';
import 'package:match_42/ui/chat_page.dart';
import 'package:match_42/ui/login_page.dart';
import 'package:match_42/ui/match_page.dart';

const String LOGIN_PATH = '/login';
const String MATCH_PATH = '/match';
const String CHAT_LIST_PATH = '/chat_list';
const String CHAT_PATH = '/chat';

class MyRouter {
  static GoRouter router = GoRouter(initialLocation: LOGIN_PATH, routes: [
    GoRoute(
        path: LOGIN_PATH,
        builder: (context, _) {
          return const LoginPage();
        }),
    GoRoute(
        path: MATCH_PATH,
        builder: (context, _) {
          return const MatchPage();
        }),
    GoRoute(
        path: CHAT_LIST_PATH,
        builder: (context, _) {
          return const ChatListPage();
        }),
    GoRoute(
        path: CHAT_PATH,
        builder: (context, _) {
          return const ChatPage();
        }),
  ]);
}
