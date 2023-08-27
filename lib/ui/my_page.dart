import 'package:flutter/material.dart';
import 'package:match_42/ui/interest_list.dart';

class Interest {
  String title;
  bool isSelect;

  Interest(
    this.title,
    this.isSelect,
  );
}

class MyPage extends StatefulWidget {
  const MyPage({super.key});

  @override
  State<MyPage> createState() => _MyPageState();
}

class _MyPageState extends State<MyPage> {
  List<Interest> interestList = [
    Interest('운동', false),
    Interest('코딩', false),
    Interest('반려동물', false),
  ];

  void onPressed(int index) {
    setState(() {
      interestList[index].isSelect = !interestList[index].isSelect;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: SelectedInterest(interestList, onPressed),
        ),
        const Expanded(
          flex: 3,
          child: BlockUser(),
        ),
        const Expanded(
          child: Logout(),
        ),
      ],
    );
  }
}

class SelectedInterest extends StatelessWidget {
  List<Interest> interestList;
  final Function onPressed;
  SelectedInterest(this.interestList, this.onPressed, {super.key});

  @override
  Widget build(BuildContext context) {
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
                        builder: (context) =>
                            InterestView(interestList, onPressed));
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
                  TextButton(
                    onPressed: null,
                    style: TextButton.styleFrom(
                      backgroundColor: colorScheme.secondaryContainer,
                      padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
                    ),
                    child: Text(
                      '운동',
                      style: TextStyle(
                        color: colorScheme.onSecondaryContainer.withAlpha(240),
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: null,
                    style: TextButton.styleFrom(
                      backgroundColor: colorScheme.secondaryContainer,
                      padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
                    ),
                    child: Text(
                      '독서',
                      style: TextStyle(
                        color: colorScheme.onSecondaryContainer.withAlpha(240),
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
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
    ColorScheme colorScheme = Theme.of(context).colorScheme;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        TextButton.icon(
          onPressed: () {},
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
