import 'package:flutter/material.dart';
import 'package:match_42/ui/main_layout.dart';

class MyPage extends StatefulWidget {
  const MyPage({super.key});

  @override
  State<MyPage> createState() => _MyPageState();
}

class _MyPageState extends State<MyPage> {
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
    return MainLayout(
      title: '마이페이지',
      body: Column(
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
                  onPressed: () {},
                  icon: Icon(
                    Icons.add_circle_outline_rounded,
                    size: 25.0,
                    color: colorScheme.onBackground.withAlpha(170),
                  )),
            ],
          ),
          ButtonBar(
            alignment: MainAxisAlignment.start,
            children: [
              const SizedBox(
                width: 3,
              ),
              TextButton(
                onPressed: null,
                style: ButtonStyle(
                  backgroundColor:
                      MaterialStatePropertyAll(colorScheme.secondaryContainer),
                  padding: MaterialStateProperty.all(const EdgeInsets.all(1)),
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
                style: ButtonStyle(
                  backgroundColor:
                      MaterialStatePropertyAll(colorScheme.secondaryContainer),
                  padding: MaterialStateProperty.all(const EdgeInsets.all(1)),
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
          const SizedBox(height: 2),
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
          const SizedBox(height: 12),
          TextButton.icon(
            onPressed: () {},
            style: TextButton.styleFrom(
              backgroundColor: colorScheme.primary,
              fixedSize: const Size.fromWidth(210),
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
          const SizedBox(height: 2),
          TextButton.icon(
            onPressed: () {},
            style: TextButton.styleFrom(
              backgroundColor: colorScheme.primary,
              fixedSize: const Size.fromWidth(210),
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
          const SizedBox(height: 12),
        ],
      ),
    );
  }
}
