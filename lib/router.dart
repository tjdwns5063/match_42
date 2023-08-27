import 'package:go_router/go_router.dart';
import 'package:match_42/ui/chat_page.dart';
import 'package:match_42/ui/login_page.dart';
import 'package:match_42/ui/main_layout.dart';

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
        path: MAIN_PATH,
        builder: (context, _) {
          return const MainLayout();
        }),
    GoRoute(
        path: '$CHAT_PATH/:room_id',
        builder: (context, state) {
          return ChatPage(roomId: state.pathParameters['room_id']!);
        }),
  ]);
}
