import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:match_42/router.dart';
import 'package:match_42/error/error_util.dart';
import 'package:match_42/ui/interest_list.dart';
import 'package:match_42/viewmodel/login_viewmodel.dart';
import 'package:match_42/viewmodel/mypage_viewmodel.dart';
import 'package:provider/provider.dart';
import 'package:match_42/ui/add_block_user.dart';

class Interest {
  String title;
  bool isSelect;

  Interest(
    this.title,
    this.isSelect,
  );

  Map<String, dynamic> toFirestore() {
    return {
      'title': title,
      'isSelect': isSelect,
    };
  }

  factory Interest.fromJson(Map<String, dynamic> json) {
    return Interest(json['title'], json['isSelect']);
  }
}

class MyPage extends StatelessWidget {
  const MyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Expanded(
          child: SelectedInterest(),
        ),
        Expanded(
          flex: 2,
          child: BlockUser(),
        ),
        Logout(),
      ],
    );
  }
}

class SelectedInterest extends StatelessWidget {
  const SelectedInterest({super.key});

  @override
  Widget build(BuildContext context) {
    MyPageViewModel myPageViewModel = context.watch();
    ColorScheme colorScheme = Theme.of(context).colorScheme;
    return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Row(
            children: [
              const SizedBox(
                width: 21,
              ),
              const Text(
                '관심사',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              IconButton(
                  onPressed: () {
                    showDialog(
                        context: context,
                        builder: (context) => ChangeNotifierProvider.value(
                            value: myPageViewModel, child: InterestView()));
                  },
                  icon: Icon(
                    Icons.add_circle_outline_rounded,
                    size: 25.0,
                    color: colorScheme.onBackground.withAlpha(170),
                  )),
            ],
          ),
          Expanded(
            child: SizedBox(
              width: double.infinity,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16.0, 0, 16.0, 0),
                child: Wrap(
                  spacing: 10.0,
                  runSpacing: 8.0,
                  alignment: WrapAlignment.start,
                  children: [
                    for (int i = 0;
                        i < myPageViewModel.interestList.length;
                        ++i)
                      TextButton(
                          onPressed: null,
                          style: TextButton.styleFrom(
                            backgroundColor: colorScheme.secondaryContainer,
                            padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
                          ),
                          child: Text(myPageViewModel.interestList[i].title,
                              style: TextStyle(
                                color: colorScheme.onSecondaryContainer,
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                              ))),
                  ],
                ),
              ),
            ),
          ),
        ]);
  }
}

class BlockUser extends StatelessWidget {
  const BlockUser({super.key});

  @override
  Widget build(BuildContext context) {
    MyPageViewModel viewModel = context.watch();
    LoginViewModel loginViewModel = context.read();
    ColorScheme colorScheme = Theme.of(context).colorScheme;
    return Column(children: [
      Row(
        children: [
          const Padding(
            padding: EdgeInsets.only(left: 21.0),
            child: Text(
              '차단한 유저',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          IconButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => ChangeNotifierProvider.value(
                    value: viewModel, child: const AddBlockUser()),
              );
            },
            icon: Icon(
              Icons.add_circle_outline_rounded,
              size: 25.0,
              color: colorScheme.onBackground.withAlpha(170),
            ),
          ),
        ],
      ),
      Expanded(
        child: Scrollbar(
          child: ListView.builder(
            itemCount: viewModel.blockUsers.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.only(left: 7.0),
                child: ListTile(
                  title: Text(
                    viewModel.blockUsers[index],
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: colorScheme.onBackground,
                    ),
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.cancel),
                    onPressed: () {
                      viewModel
                          .requestDeleteBlockUser(
                              index: index, callback: loginViewModel.updateUser)
                          .onError((Exception error, _) =>
                              onHttpError(context, error));
                    },
                  ),
                ),
              );
            },
          ),
        ),
      ),
    ]);
  }
}

class Logout extends StatelessWidget {
  const Logout({super.key});

  @override
  Widget build(BuildContext context) {
    LoginViewModel loginViewModel = context.read();
    ColorScheme colorScheme = Theme.of(context).colorScheme;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        TextButton.icon(
          onPressed: () {
            loginViewModel.logout(redirect: () => context.go(LOGIN_PATH));
          },
          style: TextButton.styleFrom(
            backgroundColor: colorScheme.primary,
            fixedSize: Size.fromWidth(MediaQuery.of(context).size.width * 0.5),
            elevation: 0,
          ),
          icon: Icon(
            Icons.logout,
            color: colorScheme.onPrimary,
          ),
          label: Text(
            '로그아웃',
            style: TextStyle(
              color: colorScheme.onPrimary,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ),
      ],
    );
  }
}
