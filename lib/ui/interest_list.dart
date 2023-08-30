import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:match_42/service/error_util.dart';
import 'package:match_42/viewmodel/login_viewmodel.dart';
import 'package:match_42/viewmodel/mypage_viewmodel.dart';
import 'package:provider/provider.dart';

class InterestView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    MyPageViewModel viewModel = context.watch();
    LoginViewModel loginViewModel = context.read();
    ColorScheme colorScheme = Theme.of(context).colorScheme;
    return Dialog(
      child: Container(
        width: MediaQuery.of(context).size.width * 0.7,
        height: 380,
        padding: EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: colorScheme.background,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('관심사 선택',
                style: TextStyle(
                  color: colorScheme.onBackground,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                )),
            Text('최대 5개 선택가능',
                style: TextStyle(
                  color: colorScheme.onBackground.withAlpha(200),
                )),
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16.0, 16.0, 0, 16.0),
                child: Wrap(
                  spacing: 10.0,
                  runSpacing: 8.0,
                  alignment: WrapAlignment.start,
                  children: [
                    for (int i = 0; i < viewModel.selectedList.length; ++i)
                      TextButton(
                          onPressed: () => viewModel.onPressed(
                                i,
                              ),
                          style: TextButton.styleFrom(
                            backgroundColor: viewModel.selectedList[i].isSelect
                                ? colorScheme.secondaryContainer
                                : colorScheme.onBackground.withAlpha(50),
                            padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
                          ),
                          child: Text(allInterest[i],
                              style: TextStyle(
                                color: colorScheme.onSecondaryContainer,
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                              ))),
                  ],
                ),
              ),
            ),
            Center(
              child: TextButton(
                onPressed: () {
                  viewModel
                      .verifyButton(callback: loginViewModel.updateUser)
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
            ),
          ],
        ),
      ),
    );
  }
}
