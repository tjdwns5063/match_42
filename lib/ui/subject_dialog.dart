import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:match_42/error/error_util.dart';
import 'package:match_42/viewmodel/match_viewmodel.dart';
import 'package:provider/provider.dart';

class SubjectDialog extends StatefulWidget {
  const SubjectDialog({super.key});

  @override
  State<SubjectDialog> createState() => _SubjectDialogState();
}

class _SubjectDialogState extends State<SubjectDialog> {
  final List<String> subjects = const [
    'libft',
    'get_next_line',
    'so_long',
    'minirt',
    'cub_3d',
    'ft_transcendence',
  ];

  final List<String> populations = const ['3', '4', '5'];
  final ExpansionTileController subjectController = ExpansionTileController();
  final ExpansionTileController populationController =
      ExpansionTileController();

  int subjectSelect = 0;
  int populationSelect = 0;

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
                  '과제 선택',
                  style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.w700),
                ),
              ),
              Theme(
                data: Theme.of(context)
                    .copyWith(dividerColor: Colors.transparent),
                child: ExpansionTile(
                  controller: subjectController,
                  title: Text(
                    subjects[subjectSelect],
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
                            title: Text(subjects[index]),
                            onTap: () {
                              setState(() {
                                subjectSelect = index;
                              });
                              subjectController.collapse();
                            },
                            trailing: subjectSelect == index
                                ? Icon(
                                    Icons.check,
                                    color: colorScheme.primary,
                                  )
                                : const SizedBox(),
                          );
                        },
                        itemCount: subjects.length,
                      ),
                    ),
                  ],
                ),
              ),
              const Padding(
                padding: EdgeInsets.fromLTRB(16.0, 16.0, 0.0, 0.0),
                child: Text(
                  '인원 선택',
                  style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.w700),
                ),
              ),
              Theme(
                data: Theme.of(context)
                    .copyWith(dividerColor: Colors.transparent),
                child: ExpansionTile(
                  controller: populationController,
                  title: Text(
                    populations[populationSelect],
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
                            title: Text(populations[index]),
                            onTap: () {
                              setState(() {
                                populationSelect = index;
                              });
                              populationController.collapse();
                            },
                            trailing: populationSelect == index
                                ? Icon(
                                    Icons.check,
                                    color: colorScheme.primary,
                                  )
                                : const SizedBox(),
                          );
                        },
                        itemCount: populations.length,
                      ),
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
                              type: ChatType.subject,
                              capacity:
                                  int.parse(populations[populationSelect]),
                              projectName: subjects[subjectSelect])
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
