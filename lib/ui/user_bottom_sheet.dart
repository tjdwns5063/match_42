import 'package:flutter/material.dart';
import 'package:match_42/error/error_util.dart';
import 'package:match_42/service/interest_service.dart';
import 'package:match_42/ui/report_page.dart';
import 'package:match_42/viewmodel/chat_viewmodel.dart';
import 'package:match_42/viewmodel/login_viewmodel.dart';
import 'package:match_42/viewmodel/mypage_viewmodel.dart';
import 'package:provider/provider.dart';

class UserBottomSheet extends StatelessWidget {
  const UserBottomSheet({super.key, required this.userId});

  final int userId;

  @override
  Widget build(BuildContext context) {
    ColorScheme colorScheme = Theme.of(context).colorScheme;
    LoginViewModel loginViewModel = context.read();
    ChatViewModel chatViewModel = context.read();

    Widget buildInterestWrap(List<String> interests) {
      if (interests.isEmpty) {
        return const Center(
          child: Text(
            '선택한 관심사가 없습니다',
            style: TextStyle(fontSize: 20.0),
          ),
        );
      }
      return Center(
        child: Wrap(spacing: 10.0, runSpacing: 8.0, children: [
          for (int i = 0; i < interests.length; ++i)
            TextButton(
                onPressed: null,
                style: TextButton.styleFrom(
                  backgroundColor: colorScheme.secondaryContainer,
                  padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
                ),
                child: Text(interests[i],
                    style: TextStyle(
                      color: colorScheme.onSecondaryContainer,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ))),
        ]),
      );
    }

    return SizedBox(
      height: MediaQuery.of(context).size.height,
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              '이 유저의 관심사',
              style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: FutureBuilder<List<String>>(
                  future: InterestService.instance
                      .getInterestsById(userId, loginViewModel.token),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return const SizedBox();
                    } else if (snapshot.hasData) {
                      List<String> interests = snapshot.data!;
                      return buildInterestWrap(interests);
                    } else {
                      onHttpError(context, snapshot.error as Exception);
                      return const SizedBox();
                    }
                  },
                ),
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).primaryColor,
                  minimumSize: Size.fromHeight(54)),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ChangeNotifierProvider.value(
                            value: chatViewModel, child: ReportPage(userId))));
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    '신고하기',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    width: 12,
                  ),
                  Icon(
                    Icons.warning_rounded,
                    size: 32.0,
                    color: Colors.redAccent,
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
