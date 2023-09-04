import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart';
import 'package:match_42/data/message.dart';
import 'package:match_42/data/user.dart';
import 'package:match_42/router.dart';
import 'package:match_42/viewmodel/chat_list_viewmodel.dart';
import 'package:match_42/viewmodel/login_viewmodel.dart';
import 'package:provider/provider.dart';
import 'package:match_42/ui/select_chat.dart';

class ChatListPage extends StatelessWidget {
  const ChatListPage({super.key});

  @override
  Widget build(BuildContext context) {
    ChatListViewModel viewModel = context.watch();
    LoginViewModel loginViewModel = context.read();

    void onPressedChatRoom(int index) {
      String chatPath = '$CHAT_PATH/${viewModel.rooms[index].id}';

      context.push(chatPath);
    }

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
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (context) => ChangeNotifierProvider.value(
                          value: viewModel, child: const SelectChat()));
                },
                icon: const Icon(
                  Icons.filter_list_outlined,
                  size: 28.0,
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: Scrollbar(
            child: ListView.builder(
              itemBuilder: (BuildContext _, int index) {
                return ChatListItem(
                  type: viewModel.rooms[index].type,
                  title: viewModel.rooms[index].name,
                  userCount: viewModel.rooms[index].users.length,
                  lastMsg: viewModel.rooms[index].lastMsg,
                  unreadMessageCount: viewModel.rooms[index].unread[viewModel
                      .rooms[index].users
                      .indexOf(loginViewModel.user!.id)],
                  onPressed: () => onPressedChatRoom(index),
                );
              },
              itemCount: viewModel.rooms.length,
            ),
          ),
        ),
      ],
    );
  }
}

class ChatListItem extends StatelessWidget {
  const ChatListItem({
    super.key,
    required this.type,
    required this.title,
    required this.userCount,
    required this.lastMsg,
    required this.unreadMessageCount,
    required this.onPressed,
  });

  final String type;
  final String title;
  final int userCount;
  final Message lastMsg;
  final int unreadMessageCount;
  final VoidCallback onPressed;

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
      title: Row(
        children: [
          Text(
            title,
            style: TextStyle(color: colorScheme.onSecondaryContainer),
          ),
          const SizedBox(
            width: 8.0,
          ),
          (userCount > 2)
              ? Text(
                  userCount.toString(),
                  style: TextStyle(color: colorScheme.outline.withAlpha(200)),
                )
              : const SizedBox(),
        ],
      ),
      subtitle: Text(
        lastMsg.message,
        style: TextStyle(color: colorScheme.outline.withAlpha(200)),
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
      ),
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            lastMsg.date.toFormatString(),
            style: TextStyle(color: colorScheme.outline.withAlpha(200)),
          ),
          const SizedBox(
            height: 7.0,
          ),
          unreadMessageCount != 0
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
                    style:
                        TextStyle(fontSize: 16.0, color: colorScheme.onError),
                  ),
                )
              : const SizedBox(),
        ],
      ),
      onTap: onPressed,
    );
  }
}
