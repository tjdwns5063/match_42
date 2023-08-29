import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:match_42/router.dart';
import 'package:match_42/viewmodel/login_viewmodel.dart';
import 'package:provider/provider.dart';

void onHttpError(BuildContext context) {
  LoginViewModel viewModel = context.read();

  viewModel.logout(redirect: () => context.go(LOGIN_PATH));
}
