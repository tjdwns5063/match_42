import 'package:flutter/material.dart';
import 'package:match_42/error/error_util.dart';
import 'package:match_42/api/firebase/chat_api.dart';
import 'package:match_42/ui/eat_dialog.dart';
import 'package:match_42/ui/subject_dialog.dart';
import 'package:match_42/ui/talk_dialog.dart';
import 'package:match_42/viewmodel/match_viewmodel.dart';
import 'package:provider/provider.dart';

class MatchPage extends StatefulWidget {
  const MatchPage({super.key});

  @override
  State<MatchPage> createState() => _MatchPageState();
}

class _MatchPageState extends State<MatchPage> {
  final List<({String label, bool isSelect})> selected = List.generate(
      100,
      (index) => switch (index % 3) {
            0 => (label: '밥', isSelect: false),
            1 => (label: '수다', isSelect: false),
            _ => (label: '과제', isSelect: false),
          });

  int _index = 49;

  late PageController controller;

  Map<String, bool> isQ = {'밥': false, '수다': false, '과제': false};

  @override
  void initState() {
    selected[_index] = (label: selected[_index].label, isSelect: true);

    controller = PageController(initialPage: _index, viewportFraction: 0.5)
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
    if (_isMoveSelectedIndex()) {
      _moveSelectedIndex();
    }
    if (_isAddItemNext()) {
      _addItemNext();
    }
  }

  bool _isAddItemNext() {
    return controller.page!.toInt() >= selected.length - 2;
  }

  bool _isMoveSelectedIndex() {
    return controller.page!.toInt() == 1;
  }

  void _addItemNext() {
    selected.addAll([
      (label: '밥', isSelect: false),
      (label: '수다', isSelect: false),
      (label: '과제', isSelect: false),
    ]);
  }

  void _moveSelectedIndex() {
    controller.jumpToPage(5);
    controller.previousPage(
        duration: const Duration(milliseconds: 200), curve: Curves.linear);
  }

  void _onPageChanged(int page) {
    setState(() {
      if (page >= 1) {
        selected[page - 1] = (label: selected[page - 1].label, isSelect: false);
      }
      if (page < selected.length - 1) {
        selected[page + 1] = (label: selected[page + 1].label, isSelect: false);
      }
      selected[page] = (label: selected[page].label, isSelect: true);
      _index = page;
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
    return switch (selected[_index].label) {
      '밥' => const EatDialog(),
      '수다' => const TalkDialog(),
      _ => const SubjectDialog()
    };
  }

  ChatApis chatService = ChatApis.instance;

  @override
  Widget build(BuildContext context) {
    MatchViewModel matchViewModel = context.watch();

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
            selected: selected,
            isQ: matchViewModel.matching,
            onPageChanged: _onPageChanged,
            onPressed: _onPressed,
          ),
        ),
        ElevatedButton(
          onPressed: selected[_index].label == '수다'
              ? () {
                  if (!matchViewModel.matching[selected[_index].label]!) {
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
                    matchViewModel
                        .matchStop(
                            type: ChatType.values
                                .where((element) =>
                                    element.typeName == selected[_index].label)
                                .first)
                        .onError(
                            (error, stackTrace) => onHttpError(context, error));
                  }
                }
              : null,
          style: ElevatedButton.styleFrom(
              shape: const CircleBorder(), padding: const EdgeInsets.all(30.0)),
          child: Text(
            (!matchViewModel.matching[selected[_index].label]!) ? '시작' : '중단',
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
      required this.selected,
      required this.isQ,
      required this.onPageChanged,
      required this.onPressed});

  final PageController controller;
  final List<({String label, bool isSelect})> selected;
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
            label: selected[index].label,
            isSelect: selected[index].isSelect,
            isQ: matchViewModel.matching[selected[index].label]!,
            onPressed: () => onPressed(index),
          ),
        );
      },
      controller: controller,
      itemCount: selected.length,
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
                                for (int i = 0;
                                    i <
                                        matchViewModel
                                            .matchStatus[label]!.capacity;
                                    ++i)
                                  Icon(
                                    Icons.person,
                                    size: 13,
                                    color: i <
                                            matchViewModel
                                                .matchStatus[label]!.size
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
                      opacity: (label == '수다')
                          ? null
                          : const AlwaysStoppedAnimation(0.2),
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
