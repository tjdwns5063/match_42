import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:match_42/error/error_util.dart';
import 'package:match_42/viewmodel/login_viewmodel.dart';
import 'package:match_42/viewmodel/match_viewmodel.dart';
import 'package:provider/provider.dart';

class TalkDialog extends StatefulWidget {
  const TalkDialog({super.key});

  @override
  State<TalkDialog> createState() => _TalkDialogState();
}

class _TalkDialogState extends State<TalkDialog> {
  bool isSameGender = false;
  List<bool> populationList = [true, false];

  @override
  Widget build(BuildContext context) {
    ColorScheme colorScheme = Theme.of(context).colorScheme;
    MatchViewModel matchViewModel = context.read();
    return SizedBox(
      height: 400,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                '채팅 설정',
                style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.w700),
              ),
            ),
            const Padding(
              padding: EdgeInsets.fromLTRB(16.0, 16.0, 0.0, 0.0),
              child: Text(
                '성별',
                style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.w700),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: EdgeInsets.only(left: 16.0),
                  child: Text(
                    '동성만',
                    style:
                        TextStyle(fontSize: 24.0, fontWeight: FontWeight.w700),
                  ),
                ),
                Padding(
                    padding: EdgeInsets.only(right: 16.0),
                    child: Switch(
                        value: isSameGender,
                        onChanged: (value) {
                          setState(() {
                            isSameGender = value;
                          });
                        })),
              ],
            ),
            const Padding(
              padding: EdgeInsets.fromLTRB(16.0, 16.0, 0.0, 0.0),
              child: Text(
                '인원',
                style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.w700),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Text(
                        '2인',
                        style: TextStyle(
                            fontSize: 20.0, fontWeight: FontWeight.w700),
                      ),
                      Checkbox(
                          value: populationList[0],
                          onChanged: (value) {
                            setState(() {
                              int currIndex = populationList.indexOf(true);

                              if (currIndex != 0) {
                                populationList[0] = true;
                                populationList[currIndex] = false;
                              }
                            });
                          }),
                    ],
                  ),
                  Row(
                    children: [
                      const Text(
                        '4인',
                        style: TextStyle(
                            fontSize: 20.0, fontWeight: FontWeight.w700),
                      ),
                      Checkbox(
                          value: populationList[1],
                          onChanged: (value) {
                            setState(() {
                              int currIndex = populationList.indexOf(true);

                              if (currIndex != 1) {
                                populationList[1] = true;
                                populationList[currIndex] = false;
                              }
                            });
                          }),
                    ],
                  ),
                ],
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 32.0),
              child: ElevatedButton(
                  onPressed: () {
                    matchViewModel
                        .matchStart(
                            type: ChatType.chat,
                            capacity: populationList.indexOf(true) == 0 ? 2 : 4)
                        .then((value) => context.pop())
                        .onError((error, stackTrace) =>
                            onHttpError(context, error as Exception));
                  },
                  child: const SizedBox(
                    width: double.infinity,
                    child: Text(
                      '매칭 시작',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 24.0,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  )),
            ),
          ],
        ),
      ),
    );
  }
}
