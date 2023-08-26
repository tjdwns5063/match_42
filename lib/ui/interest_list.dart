import 'package:flutter/material.dart';
import 'package:match_42/ui/my_page.dart';

class InterestView extends StatelessWidget {
  // const InterestView({super.key});
  List<Interest> interestList;
  final Function onPressed;
  InterestView(List<Interest> interestList, Function onPressed)
      : this.interestList = interestList,
        this.onPressed = onPressed;

  @override
  Widget build(BuildContext context) {
    ColorScheme colorScheme = Theme.of(context).colorScheme;
    return Dialog(
      child: Container(
        width: MediaQuery.of(context).size.width * 0.7,
        height: 380,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: colorScheme.background,
        ),
        child: Column(
          children: [
            SizedBox(
              width: double.infinity,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: double.infinity,
                        height: 34,
                        child: Text('관심사 선택',
                            style: TextStyle(
                              color: colorScheme.onBackground,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            )),
                      ),
                      SizedBox(
                        width: double.infinity,
                        child: Text('최대 6개 선택가능',
                            style: TextStyle(
                              color: colorScheme.onBackground.withAlpha(200),
                            )),
                      ),
                    ]),
              ),
            ),
            Expanded(
              flex: 2,
              child: SizedBox(
                width: double.infinity,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16.0, 0, 16.0, 0),
                  child: Wrap(
                    spacing: 10.0,
                    runSpacing: 8.0,
                    alignment: WrapAlignment.start,
                    children: [
                      for (int i = 0; i < interestList.length; ++i)
                        TextButton(
                            onPressed: () => onPressed(i),
                            style: TextButton.styleFrom(
                              backgroundColor: !interestList[i].isSelect
                                  ? colorScheme.onBackground.withAlpha(50)
                                  : colorScheme.secondaryContainer,
                              padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
                            ),
                            child: Text(interestList[i].title,
                                style: TextStyle(
                                  color: colorScheme.onSecondaryContainer,
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                ))),
                    ],
                  ),
                ),
              ),
            ),
            Expanded(
              child: Center(
                child: TextButton(
                  onPressed: null,
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
            ),
          ],
        ),
      ),
    );
  }
}
