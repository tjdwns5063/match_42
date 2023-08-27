import 'package:flutter/material.dart';
import 'package:match_42/data/message.dart';
import 'package:match_42/data/user.dart';
import 'package:match_42/viewmodel/chat_list_viewmodel.dart';
import 'package:match_42/viewmodel/chat_viewmodel.dart';
import 'package:provider/provider.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
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

  @override
  Widget build(BuildContext context) {
    ColorScheme colorScheme = Theme.of(context).colorScheme;
    ChatViewModel chatViewModel = context.watch();
    chatViewModel.listen();

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
                  int i = chatViewModel.messages.length - index - 1;
                  if (chatViewModel.messages[i].sender.intra == 'seongjki') {
                    return MyChatMessage(msg: chatViewModel.messages[i]);
                  } else {
                    return OtherChatMessage(msg: chatViewModel.messages[i]);
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
                itemCount: chatViewModel.messages.length),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: MessageSender(
              sendCallback: () => chatViewModel.send(
                  User(nickname: 'aaaa', intra: 'seongjki', profile: 'eat'),
                  text),
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
    ChatViewModel chatViewModel = context.read();
    ColorScheme colorScheme = Theme.of(context).colorScheme;
    return Row(
      children: [
        ElevatedButton(
          onPressed: () {
            chatViewModel.send(
                User(nickname: 'bbbb', intra: 'jiheekan', profile: 'talk'),
                controller);
          },
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
  const OtherChatMessage({super.key, required this.msg});

  final Message msg;

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
              Text(
                msg.sender.nickname,
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
                      child: Text(msg.message),
                    )),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 4.0,
                      ),
                      child: Text(
                        msg.date.toFormatString(),
                        style: const TextStyle(fontSize: 10.0),
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
    required this.msg,
  });

  final Message msg;

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
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4.0),
                      child: Text(
                        msg.date.toFormatString(),
                        style: const TextStyle(fontSize: 10.0),
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
                        child: Text(msg.message),
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
