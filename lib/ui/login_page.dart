import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:go_router/go_router.dart';
import 'package:match_42/error/error_util.dart';
import 'package:match_42/local_notification.dart';
import 'package:match_42/router.dart';
import 'package:match_42/viewmodel/login_viewmodel.dart';
import 'package:provider/provider.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:match_42/ui/make_topic.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    ColorScheme colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      body: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Center(
          child: Container(
            width: 150,
            height: 150,
            // margin: const EdgeInsets.only(top: 70),
            decoration: BoxDecoration(
              image: const DecorationImage(
                image: AssetImage('assets/logo.png'),
              ),
              color: colorScheme.secondaryContainer,
              shape: BoxShape.circle,
              // borderRadius: const BorderRadius.all(Radius.circular(58.0)),
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
            context.push('/auth');
            // context.go(MAIN_PATH);
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
  const LoginWeb({super.key});

  @override
  Widget build(BuildContext context) {
    LoginViewModel loginViewModel = context.read();

    final WebViewController controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
          NavigationDelegate(onNavigationRequest: (NavigationRequest request) {
        if (loginViewModel.isLoginSuccess(request.url)) {
          loginViewModel.login(request.url);
        }

        return NavigationDecision.navigate;
      }))
      ..loadRequest(Uri.parse('${dotenv.env['ROOT_URL']}/api/v1/login/'));

    return Scaffold(
      body: WebViewWidget(
        controller: controller,
      ),
    );
  }
}
