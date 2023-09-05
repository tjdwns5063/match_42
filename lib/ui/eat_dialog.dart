import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:match_42/error/error_util.dart';
import 'package:match_42/viewmodel/match_viewmodel.dart';
import 'package:provider/provider.dart';

class EatDialog extends StatefulWidget {
  const EatDialog({super.key});

  @override
  State<EatDialog> createState() => _EatDialogState();
}

class _EatDialogState extends State<EatDialog> {
  final lists = const ['한식', '중식', '일식', '양식'];
  int select = 0;
  List<bool> populationList = [true, false];
  final ExpansionTileController controller = ExpansionTileController();

  @override
  Widget build(BuildContext context) {
    ColorScheme colorScheme = Theme.of(context).colorScheme;
    MatchViewModel matchViewModel = context.read();

    return SizedBox(
      height: 400,
      child: SingleChildScrollView(
        child: IntrinsicHeight(
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
                  '메뉴 선택',
                  style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.w700),
                ),
              ),
              Theme(
                data: Theme.of(context)
                    .copyWith(dividerColor: Colors.transparent),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: ExpansionTile(
                    controller: controller,
                    title: Text(
                      lists[select],
                      style: TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.w700,
                          color: colorScheme.primary),
                    ),
                    children: [
                      SizedBox(
                        height: 100,
                        child: ListView.builder(
                          itemBuilder: (BuildContext context, int index) {
                            return ListTile(
                              title: Text(lists[index]),
                              onTap: () {
                                setState(() {
                                  select = index;
                                });
                                controller.collapse();
                              },
                              trailing: (select == index)
                                  ? Icon(
                                      Icons.check,
                                      color: colorScheme.primary,
                                    )
                                  : const SizedBox(),
                            );
                          },
                          itemCount: lists.length,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.fromLTRB(16.0, 16.0, 0.0, 0.0),
                child: Text(
                  '인원 선택',
                  style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.w700),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32.0),
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
                padding: const EdgeInsets.symmetric(
                    horizontal: 16.0, vertical: 32.0),
                child: ElevatedButton(
                    onPressed: () {
                      matchViewModel
                          .matchStart(
                              type: ChatType.meal,
                              capacity: populationList[0] == true ? 2 : 4,
                              menu: lists[select])
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
      ),
    );
  }
}
