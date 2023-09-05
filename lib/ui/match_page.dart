import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:match_42/data/message.dart';
import 'package:match_42/data/user.dart';
import 'package:match_42/service/chat_service.dart';
import 'package:match_42/ui/eat_dialog.dart';
import 'package:match_42/ui/main_layout.dart';
import 'package:match_42/ui/subject_dialog.dart';
import 'package:match_42/ui/talk_dialog.dart';
import 'package:match_42/viewmodel/login_viewmodel.dart';
import 'package:match_42/viewmodel/match_viewmodel.dart';
import 'package:provider/provider.dart';

class MatchPage extends StatefulWidget {
  const MatchPage({super.key});

  @override
  State<MatchPage> createState() => _MatchPageState();
}

class _MatchPageState extends State<MatchPage> {
  final List<String> labels = [
    '밥',
    '수다',
    '과제',
    '밥',
    '수다',
    '과제',
    '밥',
    '수다',
    '과제',
  ];

  final List<bool> selected = [
    false,
    false,
    false,
    false,
    true,
    false,
    false,
    false,
    false
  ];
  late PageController controller;

  Map<String, bool> isQ = {'밥': false, '수다': false, '과제': false};

  @override
  void initState() {
    controller = PageController(initialPage: 4, viewportFraction: 0.5)
      ..addListener(() {
        _infiniteScroll();
      });

    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void _infiniteScroll() {
    if (_isMoreItemPrevious()) {
      _moreItemPrevious();
    } else if (_isMoreItemNext()) {
      _moreItemNext();
    }
  }

  bool _isMoreItemNext() {
    return controller.page!.toInt() >= labels.length - 2;
  }

  bool _isMoreItemPrevious() {
    return controller.page!.toInt() == 1;
  }

  void _moreItemNext() {
    controller.jumpToPage(4);
  }

  void _moreItemPrevious() {
    controller.jumpToPage(5);
    controller.previousPage(
        duration: const Duration(milliseconds: 200), curve: Curves.linear);
  }

  void _onPageChanged(int page) {
    setState(() {
      selected[selected.indexOf(true)] = false;
      selected[page] = true;
    });
  }

  void _onPressed(int index) {
    if (controller.page!.toInt() < index) {
      controller.nextPage(
          duration: const Duration(milliseconds: 200), curve: Curves.linear);
    } else if (controller.page!.toInt() > index) {
      controller.previousPage(
          duration: const Duration(milliseconds: 200), curve: Curves.linear);
    }
  }

  Widget _getDialog() {
    int selectIndex = selected.indexOf(true);

    return switch (labels[selectIndex]) {
      '밥' => const EatDialog(),
      '수다' => const TalkDialog(),
      _ => const SubjectDialog()
    };
  }

  ChatService chatService = ChatService.instance;

  @override
  Widget build(BuildContext context) {
    LoginViewModel loginViewModel = context.read();
    MatchViewModel matchViewModel = context.watch();

    print(loginViewModel.user);
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        const SizedBox(height: 32.0),
        const Center(
          child: Text(
            '어떤 친구가 찾고 싶나요?',
            style: TextStyle(fontSize: 32.0, fontWeight: FontWeight.w700),
          ),
        ),
        Expanded(
          child: MatchPageView(
            controller: controller,
            labels: labels,
            selected: selected,
            isQ: matchViewModel.matching,
            onPageChanged: _onPageChanged,
            onPressed: _onPressed,
          ),
        ),
        ElevatedButton(
          onPressed: () {
            if (!matchViewModel.matching[labels[selected.indexOf(true)]]!) {
              showDialog(
                  context: context,
                  builder: (context) {
                    return ChangeNotifierProvider.value(
                      value: matchViewModel,
                      child: Dialog(
                        surfaceTintColor:
                            Theme.of(context).colorScheme.background,
                        child: _getDialog(),
                      ),
                    );
                  });
            } else {
              if (labels[selected.indexOf(true)] == '밥') {
                matchViewModel.matchStop(type: ChatType.meal);
              } else if (labels[selected.indexOf(true)] == '수다') {
                matchViewModel.matchStop(type: ChatType.chat);
              } else {
                matchViewModel.matchStop(type: ChatType.subject);
              }
            }
          },
          style: ElevatedButton.styleFrom(
              shape: const CircleBorder(), padding: const EdgeInsets.all(30.0)),
          child: Text(
            (!matchViewModel.matching[labels[selected.indexOf(true)]]!)
                ? '시작'
                : '중단',
            style: const TextStyle(fontSize: 24.0, fontWeight: FontWeight.w700),
          ),
        ),
        const SizedBox(height: 32.0),
      ],
    );
  }
}

class MatchPageView extends StatelessWidget {
  const MatchPageView(
      {super.key,
      required this.controller,
      required this.labels,
      required this.selected,
      required this.isQ,
      required this.onPageChanged,
      required this.onPressed});

  final PageController controller;
  final List<String> labels;
  final List<bool> selected;
  final Map<String, bool> isQ;
  final ValueChanged<int> onPageChanged;
  final ValueChanged<int> onPressed;

  @override
  Widget build(BuildContext context) {
    MatchViewModel matchViewModel = context.watch();
    return PageView.builder(
      scrollDirection: Axis.horizontal,
      onPageChanged: onPageChanged,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: MatchListItem(
            label: labels[index],
            isSelect: selected[index],
            isQ: matchViewModel.matching[labels[index]]!,
            onPressed: () => onPressed(index),
          ),
        );
      },
      controller: controller,
      itemCount: labels.length,
    );
  }
}

class MatchListItem extends StatelessWidget {
  MatchListItem(
      {super.key,
      required this.label,
      required this.isSelect,
      required this.isQ,
      required this.onPressed})
      : imagePath = switch (label) {
          '밥' => 'assets/eat.png',
          '수다' => 'assets/talk.png',
          '과제' => 'assets/subject.png',
          _ => 'assets/eat.png'
        };

  final String label;
  final bool isSelect;
  final VoidCallback onPressed;
  final String imagePath;
  final bool isQ;

  @override
  Widget build(BuildContext context) {
    ColorScheme colorScheme = Theme.of(context).colorScheme;
    MatchViewModel matchViewModel = context.watch();

    return AnimatedScale(
      scale: isSelect ? 1.5 : 1.0,
      duration: const Duration(milliseconds: 200),
      child: GestureDetector(
        onTap: onPressed,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            matchViewModel.matching[label]!
                ? Container(
                    height: 140.0,
                    width: 120.0,
                    margin: const EdgeInsets.fromLTRB(0, 0, 0, 8.0),
                    padding: const EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                        color: colorScheme.secondaryContainer,
                        borderRadius: BorderRadius.circular(30.0)),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Image.asset(
                          imagePath,
                          fit: BoxFit.contain,
                          opacity: const AlwaysStoppedAnimation(.1),
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            const Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Text(
                                  '매치 중',
                                  style: TextStyle(
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.w700),
                                ),
                                SizedBox(
                                    height: 14,
                                    width: 14,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 3.0,
                                    )),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                for (int i = 0; i < 4; ++i)
                                  Icon(
                                    Icons.circle,
                                    size: 13,
                                    color: i == 0
                                        ? colorScheme.primary
                                        : Colors.grey,
                                  )
                              ],
                            ),
                          ],
                        )
                      ],
                    ),
                  )
                : Container(
                    height: 140.0,
                    width: 120.0,
                    margin: const EdgeInsets.fromLTRB(0, 0, 0, 8.0),
                    padding: const EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                        color: colorScheme.secondaryContainer,
                        borderRadius: BorderRadius.circular(30.0)),
                    child: Image.asset(
                      imagePath,
                      fit: BoxFit.contain,
                    ),
                  ),
            Text(
              label,
              style: const TextStyle(fontSize: 14.0),
            ),
          ],
        ),
      ),
    );
  }
}
