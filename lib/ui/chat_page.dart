import 'package:flutter/material.dart';
import 'package:match_42/data/message.dart';
import 'package:match_42/ui/user_interest.dart';
import 'package:match_42/ui/yes_or_no.dart';
import 'package:match_42/viewmodel/chat_viewmodel.dart';
import 'package:match_42/viewmodel/login_viewmodel.dart';
import 'package:match_42/viewmodel/match_viewmodel.dart';
import 'package:provider/provider.dart';
import 'package:match_42/ui/report_page.dart';
import 'package:match_42/ui/make_topic.dart';

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
    LoginViewModel loginViewModel = context.read();

    Widget generateMessage(int i) {
      if (chatViewModel.messages[i].sender.id == 0) {
        return SystemMessage(msg: chatViewModel.messages[i]);
      } else if (chatViewModel.messages[i].sender.id ==
          loginViewModel.user!.id) {
        return MyChatMessage(msg: chatViewModel.messages[i]);
      } else {
        return OtherChatMessage(msg: chatViewModel.messages[i]);
      }
    }

    Widget buildChatPage() {
      return Column(
        children: [
          Expanded(
            child: ListView.separated(
                reverse: true,
                controller: scroll,
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                itemBuilder: (context, index) {
                  int i = chatViewModel.messages.length - index - 1;
                  Message msg = chatViewModel.messages[i];

                  if (i == 0) {
                    return Column(
                      children: [
                        DateSeparator(date: msg.date.toDate()),
                        generateMessage(i),
                      ],
                    );
                  } else {
                    return generateMessage(i);
                  }
                },
                separatorBuilder: (context, index) {
                  int i = chatViewModel.messages.length - index - 1;
                  Message msg = chatViewModel.messages[i];

                  if (chatViewModel.isChangeDate(i)) {
                    return DateSeparator(date: msg.date.toDate());
                  }
                  return const SizedBox(
                    height: 16.0,
                  );
                },
                itemCount: chatViewModel.messages.length),
          ),
          (chatViewModel.remainSeconds ?? 42) > 0
              ? Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: MessageSender(
                    sendCallback: () =>
                        chatViewModel.send(loginViewModel.user!, text),
                    controller: text,
                  ),
                )
              : const SizedBox(),
        ],
      );
    }

    Widget builder() {
      if ((chatViewModel.remainSeconds ?? 42) > 0) {
        return buildChatPage();
      } else if ((chatViewModel.remainSeconds ?? 42) <= 0 &&
          chatViewModel.chatRoom.isOpen![
              chatViewModel.chatRoom.users.indexOf(loginViewModel.user!.id)]) {
        return buildChatPage();
      } else {
        return const YesOrNo();
      }
    }

    return Scaffold(
      appBar: AppBar(
        surfaceTintColor: Colors.transparent,
        scrolledUnderElevation: 0.0,
        centerTitle: false,
        title: Container(
            width: 150.0,
            height: 45.0,
            alignment: Alignment.center,
            decoration: BoxDecoration(
                color: colorScheme.secondaryContainer,
                borderRadius: BorderRadius.circular(20.0)),
            child: Text(
              chatViewModel.parseHMS(),
              style:
                  const TextStyle(fontSize: 16.0, fontWeight: FontWeight.w700),
            )),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const ReportPage()));
            },
            icon: const Icon(
              Icons.warning_rounded,
              size: 32.0,
            ),
            color: Colors.red,
          )
        ],
      ),
      body: builder(),
    );
  }
}

class SystemMessage extends StatelessWidget {
  const SystemMessage({super.key, required this.msg});

  final Message msg;

  @override
  Widget build(BuildContext context) {
    ColorScheme colorScheme = Theme.of(context).colorScheme;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CircleAvatar(
          child: Image.asset('assets/system.png'),
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

class MessageSender extends StatelessWidget {
  const MessageSender(
      {super.key, required this.sendCallback, required this.controller});

  final VoidCallback sendCallback;
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    ChatViewModel viewModel = context.read();
    ColorScheme colorScheme = Theme.of(context).colorScheme;
    return Row(
      children: [
        ElevatedButton(
          onPressed: () {
            showDialog(
              context: context,
              builder: (context) => ChangeNotifierProvider.value(
                  value: viewModel, child: const MakeTopic()),
            );
          },
          style: ElevatedButton.styleFrom(
            shape: const CircleBorder(),
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
    ChatViewModel viewModel = context.read();

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkWell(
          onTap: () {
            showModalBottomSheet<void>(
                context: context,
                builder: (context) => UserInterest(userId: msg.sender.id));
          },
          child: CircleAvatar(
            child: Image.asset('assets/${msg.sender.profile}'),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                (viewModel.chatRoom.type == 'chat')
                    ? msg.sender.nickname
                    : msg.sender.intra,
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

class DateSeparator extends StatelessWidget {
  const DateSeparator({super.key, required this.date});

  final DateTime date;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Text(
          '${date.year}년 ${date.month}월 ${date.day}일',
          style: const TextStyle(fontSize: 12.0),
        ),
      ),
    );
  }
}
