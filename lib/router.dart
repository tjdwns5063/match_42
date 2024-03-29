import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:match_42/api/http_apis.dart';
import 'package:match_42/api/firebase/chat_api.dart';
import 'package:match_42/api/token_apis.dart';
import 'package:match_42/ui/ban_page.dart';
import 'package:match_42/ui/chat/chat_page.dart';
import 'package:match_42/ui/login_page.dart';
import 'package:match_42/ui/main_layout.dart';
import 'package:match_42/viewmodel/chat_list_viewmodel.dart';
import 'package:match_42/viewmodel/chat_viewmodel.dart';
import 'package:match_42/viewmodel/login_viewmodel.dart';
import 'package:match_42/viewmodel/match_viewmodel.dart';
import 'package:match_42/viewmodel/mypage_viewmodel.dart';
import 'package:provider/provider.dart';

const String LOGIN_PATH = '/login';
const String MAIN_PATH = '/main';
const String CHAT_PATH = '/chat';

class MyRouter {
  MyRouter({required this.context})
      : router = GoRouter(
            initialLocation: LOGIN_PATH,
            refreshListenable: context.read<LoginViewModel>(),
            routes: [
              GoRoute(
                  path: LOGIN_PATH,
                  builder: (context, _) {
                    return const LoginPage();
                  }),
              GoRoute(
                  path: '/auth',
                  builder: (context, _) {
                    return const LoginWeb();
                  },
                  redirect: (context, state) {
                    LoginViewModel loginViewModel = context.read();

                    if (loginViewModel.user != null) {
                      return MAIN_PATH;
                    }
                    return '/auth';
                  }),
              GoRoute(
                  path: MAIN_PATH,
                  builder: (context, _) {
                    LoginViewModel loginViewModel = context.read();
                    return MultiProvider(
                      providers: [
                        ChangeNotifierProvider(
                          create: (BuildContext context) => ChatListViewModel(
                              loginViewModel.user!, ChatApis.instance),
                        ),
                        ChangeNotifierProvider(
                            create: (BuildContext context) => MyPageViewModel(
                                  HttpApis.instance(TokenApis.instance),
                                  user: loginViewModel.user!,
                                )),
                        ChangeNotifierProvider(
                            create: (BuildContext context) =>
                                MatchViewModel(loginViewModel.user!)),
                      ],
                      child: const MainLayout(),
                    );
                  },
                  redirect: (context, state) {
                    LoginViewModel loginViewModel = context.read();
                    if (loginViewModel.user!.reportCount >= 5) return '/ban';
                    return MAIN_PATH;
                  }),
              GoRoute(
                  path: '$CHAT_PATH/:room_id',
                  builder: (context, state) {
                    LoginViewModel loginViewModel = context.read();
                    return ChangeNotifierProvider(
                        create: (context) {
                          return ChatViewModel(
                              roomId: state.pathParameters['room_id']!,
                              user: loginViewModel.user!,
                              chatService: ChatApis.instance,
                              httpApis: HttpApis.instance(TokenApis.instance));
                        },
                        child: const ChatPage());
                  }),
              GoRoute(
                  path: '/ban',
                  builder: (context, state) {
                    return ChangeNotifierProvider.value(
                        value: context.read<LoginViewModel>(),
                        child: const BanPage());
                  })
            ]);

  final BuildContext context;

  final GoRouter router;
}
