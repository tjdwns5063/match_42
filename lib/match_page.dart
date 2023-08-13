import 'package:flutter/material.dart';

class MatchPage extends StatefulWidget {
  const MatchPage({super.key});

  @override
  State<MatchPage> createState() => _MatchPageState();
}

class _MatchPageState extends State<MatchPage> {
  final List<String> labels = [
    '과제',
    '밥',
    '수다',
    '과제',
    '밥',
  ];

  final List<bool> selected = [false, false, true, false, false];
  late PageController controller;

  @override
  void initState() {
    controller = PageController(initialPage: 2, viewportFraction: 0.5);

    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ColorScheme colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: colorScheme.background,
        title: const Text(
          '매칭',
          style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.w700),
        ),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.notifications_none,
              size: 32,
            ),
            onPressed: () {},
          )
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        showUnselectedLabels: false,
        showSelectedLabels: false,
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.person_search_rounded), label: 'match'),
          BottomNavigationBarItem(icon: Icon(Icons.chat), label: 'chat'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'my')
        ],
      ),
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
            child: PageView.builder(
              scrollDirection: Axis.horizontal,
              onPageChanged: (int page) {
                setState(() {
                  selected[selected.indexOf(true)] = false;
                  selected[page] = true;
                });
              },
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: MatchListItem(
                    index: index,
                    label: labels[index],
                    isSelect: selected[index],
                    onPressed: () {
                      if (controller.page!.toInt() < index) {
                        controller.nextPage(
                            duration: const Duration(milliseconds: 200),
                            curve: Curves.linear);
                      } else if (controller.page!.toInt() > index) {
                        controller.previousPage(
                            duration: const Duration(milliseconds: 200),
                            curve: Curves.linear);
                      }
                    },
                  ),
                );
              },
              controller: controller,
              itemCount: labels.length,
            ),
          ),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
                shape: const CircleBorder(),
                padding: const EdgeInsets.all(30.0)),
            child: const Text(
              'Go',
              style: TextStyle(fontSize: 24.0),
            ),
          )
        ],
      ),
    );
  }
}

class MatchListItem extends StatelessWidget {
  const MatchListItem(
      {super.key,
      required this.index,
      required this.label,
      required this.isSelect,
      required this.onPressed})
      : height = isSelect ? 200.0 : 150.0,
        width = isSelect ? 150.0 : 100.0,
        labelSize = isSelect ? 24.0 : 14.0;

  final String label;
  final int index;
  final bool isSelect;
  final double height;
  final double width;
  final double labelSize;
  final VoidCallback onPressed;

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
            decoration: BoxDecoration(
                color: colorScheme.secondaryContainer,
                borderRadius: BorderRadius.circular(30.0)),
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
