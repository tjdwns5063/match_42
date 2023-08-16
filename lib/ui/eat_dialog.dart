import 'package:flutter/material.dart';

class EatDialog extends StatelessWidget {
  const EatDialog({super.key});

  final lists = const ['한식', '중식', '일식', '양식'];

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
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: ExpansionTile(
                    title: Text(
                      '한식',
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
                              onTap: () {},
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
                        Checkbox(value: true, onChanged: (value) {}),
                      ],
                    ),
                    Row(
                      children: [
                        const Text(
                          '4인',
                          style: TextStyle(
                              fontSize: 20.0, fontWeight: FontWeight.w700),
                        ),
                        Checkbox(value: false, onChanged: (value) {}),
                      ],
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 16.0, vertical: 32.0),
                child: ElevatedButton(
                    onPressed: () {},
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
