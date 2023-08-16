import 'package:flutter/material.dart';
import 'package:match_42/ui/eat_dialog.dart';
import 'package:match_42/ui/main_layout.dart';
import 'package:match_42/ui/subject_dialog.dart';

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

  @override
  void initState() {
    controller = PageController(initialPage: 4, viewportFraction: 0.4)
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
    controller.nextPage(
        duration: const Duration(milliseconds: 200), curve: Curves.linear);
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

  @override
  Widget build(BuildContext context) {
    return MainLayout(
      title: '매칭',
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          const SizedBox(
            height: 32.0,
          ),
          const Center(
            child: Text(
              '어떤 친구가 찾고 싶나요?',
              style: TextStyle(fontSize: 32.0, fontWeight: FontWeight.w700),
            ),
          ),
          const SizedBox(
            height: 32.0,
          ),
          Expanded(
            child: MatchPageView(
              controller: controller,
              labels: labels,
              selected: selected,
              onPageChanged: _onPageChanged,
              onPressed: _onPressed,
            ),
          ),
          const SizedBox(
            height: 32.0,
          ),
          ElevatedButton(
            onPressed: () {
              showDialog(
                  context: context,
                  builder: (context) {
                    return Dialog(
                      surfaceTintColor:
                          Theme.of(context).colorScheme.background,
                      child: EatDialog(),
                    );
                  });
            },
            style: ElevatedButton.styleFrom(
                shape: const CircleBorder(),
                padding: const EdgeInsets.all(30.0)),
            child: const Text(
              '시작',
              style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.w700),
            ),
          ),
          const SizedBox(
            height: 32.0,
          ),
        ],
      ),
    );
  }
}

class MatchPageView extends StatelessWidget {
  const MatchPageView(
      {super.key,
      required this.controller,
      required this.labels,
      required this.selected,
      required this.onPageChanged,
      required this.onPressed});

  final PageController controller;
  final List<String> labels;
  final List<bool> selected;
  final ValueChanged<int> onPageChanged;
  final ValueChanged<int> onPressed;

  @override
  Widget build(BuildContext context) {
    return PageView.builder(
      scrollDirection: Axis.horizontal,
      onPageChanged: onPageChanged,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: MatchListItem(
            label: labels[index],
            isSelect: selected[index],
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

  @override
  Widget build(BuildContext context) {
    ColorScheme colorScheme = Theme.of(context).colorScheme;

    return AnimatedScale(
      scale: isSelect ? 1.5 : 1.0,
      duration: const Duration(milliseconds: 200),
      child: GestureDetector(
        onTap: onPressed,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: 120.0,
              width: 100.0,
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
