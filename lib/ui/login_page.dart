import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:match_42/router.dart';

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
            context.go('/main');
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
