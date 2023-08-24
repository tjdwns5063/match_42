import 'package:flutter/material.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  List<String> list = [for (int i = 0; i < 20; ++i) '안녕하세요'];
  late TextEditingController text;
  late ScrollController scroll;

  @override
  void initState() {
    text = TextEditingController();
    scroll = ScrollController();
    super.initState();
  }

  @override
  void dispose() {
    text.dispose();
    scroll.dispose();
    super.dispose();
  }

  void _send() {
    setState(() {
      list.add(text.text);
      text.clear();
    });
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      scroll.jumpTo(0.0);
    });
  }

  @override
  Widget build(BuildContext context) {
    ColorScheme colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        surfaceTintColor: Colors.transparent,
        scrolledUnderElevation: 0.0,
        centerTitle: false,
        title: Container(
            width: 120.0,
            height: 30.0,
            alignment: Alignment.center,
            decoration: BoxDecoration(
                color: colorScheme.secondaryContainer,
                borderRadius: BorderRadius.circular(20.0)),
            child: const Text(
              '06:03 남음',
              style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w700),
            )),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.warning_rounded,
              size: 32.0,
            ),
            color: Colors.red,
          )
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.separated(
                reverse: true,
                controller: scroll,
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                itemBuilder: (context, index) {
                  int i = list.length - index - 1;
                  if (index % 2 == 0) {
                    return MyChatMessage(text: list[i]);
                  } else {
                    return OtherChatMessage(text: list[i]);
                  }
                },
                separatorBuilder: (context, index) {
                  if (index % 5 == 1) {
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Text(
                          '2023년 6월 ${index ~/ 5 + 1}일',
                          style: const TextStyle(fontSize: 12.0),
                        ),
                      ),
                    );
                  }
                  return const SizedBox(
                    height: 16.0,
                  );
                },
                itemCount: list.length),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: MessageSender(
              sendCallback: _send,
              controller: text,
            ),
          )
        ],
      ),
    );
  }
}

class MessageSender extends StatelessWidget {
  const MessageSender(
      {super.key, required this.sendCallback, required this.controller});

  final VoidCallback sendCallback;
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    ColorScheme colorScheme = Theme.of(context).colorScheme;
    return Row(
      children: [
        ElevatedButton(
          onPressed: () {},
          style: ElevatedButton.styleFrom(
            shape: const CircleBorder(),
            backgroundColor: colorScheme.primary,
            foregroundColor: colorScheme.onPrimary,
            padding: EdgeInsets.zero,
          ),
          child: ImageIcon(
            const AssetImage('assets/talk_event.png'),
            color: colorScheme.onPrimary,
          ),
        ),
        Expanded(
          child: SizedBox(
            height: 40.0,
            child: TextField(
              controller: controller,
              style: const TextStyle(fontSize: 16.0),
              decoration: InputDecoration(
                  contentPadding: const EdgeInsets.only(
                      left: 16.0, bottom: 8.0, right: 16.0),
                  border: OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.circular(20.0)),
                  filled: true,
                  fillColor: colorScheme.secondaryContainer),
            ),
          ),
        ),
        IconButton(
            onPressed: sendCallback,
            icon: Icon(
              Icons.send,
              color: colorScheme.primary,
            )),
      ],
    );
  }
}

class OtherChatMessage extends StatelessWidget {
  const OtherChatMessage({super.key, required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    ColorScheme colorScheme = Theme.of(context).colorScheme;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CircleAvatar(
          child: Image.asset('assets/eat.png'),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                '안드',
              ),
              ConstrainedBox(
                constraints: BoxConstraints(
                    maxWidth: MediaQuery.of(context).size.width - 68.0,
                    maxHeight: MediaQuery.of(context).size.height -
                        kToolbarHeight * 2),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Flexible(
                        child: Container(
                      padding: const EdgeInsets.all(8.0),
                      decoration: BoxDecoration(
                          color: colorScheme.secondaryContainer,
                          borderRadius: BorderRadius.circular(10.0)),
                      child: Text(text),
                    )),
                    const Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 4.0,
                      ),
                      child: Text(
                        '오후 13:33',
                        style: TextStyle(fontSize: 10.0),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class MyChatMessage extends StatelessWidget {
  const MyChatMessage({
    super.key,
    required this.text,
  });

  final String text;

  @override
  Widget build(BuildContext context) {
    ColorScheme colorScheme = Theme.of(context).colorScheme;

    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: Column(
            children: [
              ConstrainedBox(
                constraints: BoxConstraints(
                    maxWidth: MediaQuery.of(context).size.width - 60.0,
                    maxHeight: MediaQuery.of(context).size.height -
                        kToolbarHeight * 2),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 4.0),
                      child: Text(
                        '오후 13:33',
                        style: TextStyle(fontSize: 10.0),
                      ),
                    ),
                    Flexible(
                        child: Padding(
                      padding: const EdgeInsets.fromLTRB(0.0, 0.0, 8.0, 8.0),
                      child: Container(
                        padding: const EdgeInsets.all(8.0),
                        decoration: BoxDecoration(
                            color: colorScheme.tertiaryContainer,
                            borderRadius: BorderRadius.circular(10.0)),
                        child: Text(text),
                      ),
                    )),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}