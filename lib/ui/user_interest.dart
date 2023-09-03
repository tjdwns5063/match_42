import 'package:flutter/material.dart';
import 'package:match_42/viewmodel/mypage_viewmodel.dart';
import 'package:provider/provider.dart';


class UserInterest extends StatelessWidget {
  const UserInterest({super.key});

  @override
  Widget build(BuildContext context) {
    MyPageViewModel viewModel = context.watch();
    ColorScheme colorScheme = Theme.of(context).colorScheme;
    return Container(child: Wrap(
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
                              backgroundColor:
                                  viewModel.selectedList[i].isSelect
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
                  ),);
  }
}