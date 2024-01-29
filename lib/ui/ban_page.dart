import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:match_42/viewmodel/login_viewmodel.dart';
import 'package:provider/provider.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../router.dart';

class BanPage extends StatelessWidget {
  const BanPage({super.key});

  @override
  Widget build(BuildContext context) {
    LoginViewModel loginViewModel = context.read();
    return Scaffold(
      appBar: AppBar(title: Text('계정 정지')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            RichText(
                text: TextSpan(
                    text: '5번 이상 신고가 누적되어 계정이 정지 됐습니다.\n',
                    style: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.black),
                    children: [
                  TextSpan(
                    text: '문의사항은 42.4.seongjki@gmail.com으로 연락주세요.',
                    style: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.black),
                  )
                ])),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      minimumSize: Size.fromHeight(48),
                      foregroundColor: Colors.grey,
                      backgroundColor: Theme.of(context).primaryColor),
                  onPressed: () {
                    loginViewModel.logout(
                        redirect: () => context.go(LOGIN_PATH));
                    WebViewCookieManager().clearCookies();
                  },
                  child: Text(
                    '로그아웃',
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  )),
            )
          ],
        ),
      ),
    );
  }
}
