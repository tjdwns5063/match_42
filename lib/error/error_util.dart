import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:match_42/error/http_exception.dart';
import 'package:match_42/router.dart';
import 'package:match_42/viewmodel/login_viewmodel.dart';
import 'package:provider/provider.dart';

bool isExpireTokenError(Exception exception) {
  return exception is HttpException && exception.statusCode == 302;
}

void onHttpError(BuildContext context, Exception exception) async {
  if (isExpireTokenError(exception)) {
    LoginViewModel viewModel = context.read();

    viewModel.logout(redirect: () => context.go(LOGIN_PATH));
  } else {
    await showDialog(
        context: context,
        builder: (context) => AlertDialog(
              content: Text(
                exception.toString(),
                style: const TextStyle(fontSize: 18.0),
              ),
              actions: [
                TextButton(
                  onPressed: () => context.pop(),
                  child: const Text('확인'),
                ),
              ],
            ));
  }
}
