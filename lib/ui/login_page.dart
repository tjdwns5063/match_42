import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:match_42/data/user.dart';
import 'package:match_42/router.dart';
import 'package:http/http.dart' as http;
import 'package:match_42/viewmodel/login_viewmodel.dart';
import 'package:provider/provider.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'dart:convert';
import 'package:http/http.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    ColorScheme colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      body: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Center(
          child: Container(
            width: 220,
            height: 220,
            // margin: const EdgeInsets.only(top: 70),
            decoration: BoxDecoration(
              color: colorScheme.secondaryContainer,
              borderRadius: const BorderRadius.all(Radius.circular(60.0)),
            ),
          ),
        ),
        const SizedBox(
          height: 43,
        ),
        Text('Match42',
            style: TextStyle(
                color: colorScheme.onBackground,
                fontSize: 35.0,
                fontWeight: FontWeight.bold)),
        const SizedBox(
          height: 3.0,
        ),
        Text(
          'Match42에서 마음에 맞는 동료를 찾아보세요.',
          style: TextStyle(
            color: colorScheme.onBackground,
            fontSize: 17,
          ),
        ),
        const SizedBox(
          height: 90,
        ),
        TextButton(
          onPressed: () {
            context.go('/auth');
          },
          style: ButtonStyle(
            backgroundColor:
                MaterialStatePropertyAll(colorScheme.secondaryContainer),
            fixedSize: const MaterialStatePropertyAll(Size.fromWidth(320.0)),
          ),
          child: Text('로그인',
              style: TextStyle(
                color: colorScheme.onSecondaryContainer,
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              )),
        ),
      ]),
    );
  }
}

class LoginWeb extends StatelessWidget {
  LoginWeb({super.key});

  final WebViewController controller = WebViewController();

  @override
  Widget build(BuildContext context) {
    LoginViewModel loginViewModel = context.read();

    controller
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(NavigationDelegate(
          onNavigationRequest: (NavigationRequest request) async {
        if (request.url
            .contains('http://115.85.181.92/api/v1/login/success?token')) {
          String token =
              Uri.parse(request.url).queryParameters['token'] as String;
          print(token);
          loginViewModel.updateToken(token);
          // Response response2 = await http.post(
          //     Uri.parse('http://115.85.181.92/api/v1/user/interest'),
          //     headers: {'Authorization': 'Bearer $token'},
          //     body: {'interest2': 'hobby'});

          // print('response2: ${response2.body}');
          Response response = await http.get(
              Uri.parse("http://115.85.181.92/api/v1/user/me"),
              headers: {'Authorization': 'Bearer $token'});

          Map<String, dynamic> json = jsonDecode(response.body);
          User user = User.fromJson(json);
          loginViewModel.updateUser(user);

          context.go(MAIN_PATH);
        }
        print(request.url);

        return NavigationDecision.navigate;
      }))
      ..loadRequest(Uri.parse('http://115.85.181.92/api/v1/login/'));

    return Scaffold(
      body: WebViewWidget(
        controller: controller,
      ),
    );
  }
}
