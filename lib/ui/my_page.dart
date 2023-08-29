import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:match_42/router.dart';
import 'package:match_42/ui/interest_list.dart';
import 'package:match_42/viewmodel/login_viewmodel.dart';
import 'package:match_42/viewmodel/mypage_viewmodel.dart';
import 'package:provider/provider.dart';

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
      children: [
        Expanded(
          child: SelectedInterest(),
        ),
        Expanded(
          flex: 3,
          child: BlockUser(),
        ),
        Expanded(
          child: Logout(),
        ),
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
          SizedBox(
            width: double.infinity,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16.0, 0, 16.0, 0),
              child: Wrap(
                spacing: 10.0,
                runSpacing: 8.0,
                alignment: WrapAlignment.start,
                children: [
                  for (int i = 0; i < myPageViewModel.interestList.length; ++i)
                    TextButton(
                        onPressed: () => myPageViewModel.onPressed(i),
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
        ]);
  }
}

class BlockUser extends StatefulWidget {
  const BlockUser({super.key});

  @override
  State<BlockUser> createState() => _BlockUserState();
}

class _BlockUserState extends State<BlockUser> {
  var idList = [
    'jiheekan1',
    'jiheekan2',
    'jiheekan3',
    'jiheekan4',
    'jiheekan5',
  ];

  @override
  Widget build(BuildContext context) {
    ColorScheme colorScheme = Theme.of(context).colorScheme;
    return Column(children: [
      Row(
        children: [
          const SizedBox(
            width: 21,
          ),
          const Text(
            '차단한 유저',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          IconButton(
              onPressed: () {},
              icon: Icon(
                Icons.add_circle_outline_rounded,
                size: 25.0,
                color: colorScheme.onBackground.withAlpha(170),
              )),
        ],
      ),
      Expanded(
        child: Scrollbar(
          child: ListView.builder(
            itemCount: idList.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Row(
                  children: [
                    const SizedBox(width: 8),
                    CircleAvatar(child: Image.asset('assets/talk.png')),
                    const SizedBox(width: 15),
                    Text(
                      idList[index],
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: colorScheme.onBackground,
                      ),
                    ),
                  ],
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
        const SizedBox(height: 8),
        TextButton.icon(
          onPressed: () {},
          style: TextButton.styleFrom(
            backgroundColor: colorScheme.primary,
            fixedSize: Size.fromWidth(MediaQuery.of(context).size.width * 0.5),
            elevation: 0,
          ),
          icon: Icon(
            Icons.book,
            color: colorScheme.onPrimary,
          ),
          label: Text(
            '오픈소스 라이선스',
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
