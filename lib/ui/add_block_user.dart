import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:match_42/service/error_util.dart';
import 'package:match_42/viewmodel/login_viewmodel.dart';
import 'package:match_42/viewmodel/mypage_viewmodel.dart';
import 'package:provider/provider.dart';

class AddBlockUser extends StatefulWidget {
  const AddBlockUser({super.key});

  @override
  State<AddBlockUser> createState() => _AddBlockUserState();
}

class _AddBlockUserState extends State<AddBlockUser> {
  final TextEditingController _controller =
      TextEditingController(); // 입력을 관리하기 위한 컨트롤러

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ColorScheme colorScheme = Theme.of(context).colorScheme;
    MyPageViewModel myPageViewModel = context.read();
    LoginViewModel loginViewModel = context.read();

    return Dialog(
        child: Container(
      width: MediaQuery.of(context).size.width * 0.7,
      height: 175,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: colorScheme.background,
      ),
      child: Center(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(16.0),
              child: TextField(
                controller: _controller, // 컨트롤러 연결
                decoration: InputDecoration(
                  labelText: '차단할 intra id를 입력하세요.', // 입력 필드 위에 표시되는 힌트 텍스트
                ),
              ),
            ),
            const SizedBox(height: 2),
            TextButton(
              onPressed: () {
                myPageViewModel
                    .requestAddBlockUser(
                        intraId: _controller.text,
                        callback: loginViewModel.updateUser)
                    .onError((error, stackTrace) => onHttpError(context));
                context.pop();
              },
              style: TextButton.styleFrom(
                backgroundColor: colorScheme.primary,
                padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
                fixedSize: Size.fromWidth(
                  MediaQuery.of(context).size.width * 0.5,
                ),
              ),
              child: Text(
                '확인',
                style: TextStyle(
                  color: colorScheme.onPrimary.withAlpha(240),
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    ));
  }
}
