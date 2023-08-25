import 'package:flutter/material.dart';
import 'package:match_42/ui/main_layout.dart';

class ChatListPage extends StatefulWidget {
  const ChatListPage({super.key});

  @override
  State<ChatListPage> createState() => _ChatListPageState();
}

class _ChatListPageState extends State<ChatListPage> {
  late List<String> chatList = [for (int i = 0; i < 10; ++i) generateType(i)];

  String generateType(int i) {
    return switch (i % 3) { 0 => 'talk', 1 => 'subject', _ => 'eat' };
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            children: [
              const Text(
                '채팅',
                style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.w700),
              ),
              const SizedBox(
                width: 8.0,
              ),
              IconButton(
                  onPressed: () {},
                  icon: const Icon(
                    Icons.filter_list_outlined,
                    size: 28.0,
                  )),
            ],
          ),
        ),
        Expanded(
          child: Scrollbar(
            child: ListView.builder(
              itemBuilder: (BuildContext _, int index) {
                return ChatListItem(
                  type: chatList[index],
                  title: '안드',
                  description: '안녕하세요',
                  unreadMessageCount: index < 3 ? 3 : 0,
                );
              },
              itemCount: chatList.length,
            ),
          ),
        ),
      ],
    );
  }
}

class ChatListItem extends StatelessWidget {
  const ChatListItem(
      {super.key,
      required this.type,
      required this.title,
      required this.description,
      required this.unreadMessageCount});

  final String type;
  final String title;
  final String description;
  final int unreadMessageCount;

  String getImagePath() {
    return switch (type) {
      'eat' => 'assets/eat.png',
      'subject' => 'assets/subject.png',
      _ => 'assets/talk.png'
    };
  }

  @override
  Widget build(BuildContext context) {
    ColorScheme colorScheme = Theme.of(context).colorScheme;
    return ListTile(
      leading: CircleAvatar(
        child: Image.asset(
          getImagePath(),
        ),
      ),
      title: Text(
        title,
        style: TextStyle(color: colorScheme.onSecondaryContainer),
      ),
      subtitle: Text(
        description,
        style: TextStyle(color: colorScheme.outline.withAlpha(200)),
      ),
      trailing: unreadMessageCount != 0
          ? Container(
              width: 24.0,
              height: 24.0,
              alignment: Alignment.center,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.red,
              ),
              child: Text(
                unreadMessageCount.toString(),
                style: TextStyle(fontSize: 16.0, color: colorScheme.onError),
              ),
            )
          : const SizedBox(),
      onTap: () {},
    );
  }
}
