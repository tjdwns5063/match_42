import 'package:flutter/material.dart';

class SubjectDialog extends StatelessWidget {
  const SubjectDialog({super.key});

  final subjects = const [
    'libft',
    'get_next_line',
    'so_long',
    'minirt',
    'cub_3d',
    'ft_transcendence',
  ];

  final populations = const ['3', '4', '5'];

  @override
  Widget build(BuildContext context) {
    ColorScheme colorScheme = Theme.of(context).colorScheme;
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
                  title: Text(
                    'ft_transcendence',
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
                            onTap: () {},
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
                  title: Text(
                    '3명',
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
                            onTap: () {},
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
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: colorScheme.secondaryContainer,
                    ),
                    child: SizedBox(
                      width: double.infinity,
                      child: Text(
                        '매칭 시작',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 24.0,
                            fontWeight: FontWeight.w700,
                            color: colorScheme.onSecondaryContainer),
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
