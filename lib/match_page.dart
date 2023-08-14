import 'package:flutter/material.dart';
import 'package:match_42/main_layout.dart';

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
  ];

  final List<bool> selected = [false, false, false, false, true, false];
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

  bool _isMoreItemPrevious() {
    return controller.page!.toInt() >= labels.length - 1;
  }

  bool _isMoreItemNext() {
    return controller.page!.toInt() == 0;
  }

  void _moreItemPrevious() {
    setState(() {
      labels.addAll(const ['밥', '수다', '과제']);
      selected.addAll(const [false, false, false]);
      for (int i = 0; i < 3; ++i) {
        labels.removeAt(0);
        selected.removeAt(0);
      }
    });
    controller.jumpToPage(2);
    controller.nextPage(
        duration: const Duration(milliseconds: 200), curve: Curves.linear);
  }

  void _moreItemNext() {
    setState(() {
      labels.insertAll(0, const ['밥', '수다', '과제']);
      selected.insertAll(0, const [false, false, false]);
      for (int i = 0; i < 3; ++i) {
        labels.removeLast();
        selected.removeLast();
      }
    });
    controller.jumpToPage(4);
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
          const Center(
            child: Text(
              '어떤 친구가 찾고 싶나요?',
              style: TextStyle(fontSize: 32.0, fontWeight: FontWeight.w700),
            ),
          ),
          SizedBox(
              height: 250.0,
              width: double.infinity,
              child: MatchPageView(
                controller: controller,
                labels: labels,
                selected: selected,
                onPageChanged: _onPageChanged,
                onPressed: _onPressed,
              )),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
                shape: const CircleBorder(),
                padding: const EdgeInsets.all(30.0)),
            child: const Text(
              '시작',
              style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.w700),
            ),
          )
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
      : height = isSelect ? 200.0 : 150.0,
        width = isSelect ? 150.0 : 100.0,
        labelSize = isSelect ? 24.0 : 14.0,
        imagePath = switch (label) {
          '밥' => 'assets/eat.png',
          '수다' => 'assets/talk.png',
          '과제' => 'assets/subject.png',
          _ => 'assets/eat.png'
        };

  final String label;
  final bool isSelect;
  final double height;
  final double width;
  final double labelSize;
  final VoidCallback onPressed;
  final String imagePath;

  @override
  Widget build(BuildContext context) {
    ColorScheme colorScheme = Theme.of(context).colorScheme;

    return GestureDetector(
      onTap: onPressed,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Container(
            height: height,
            width: width,
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
            style: TextStyle(fontSize: labelSize),
          ),
        ],
      ),
    );
  }
}
