import 'package:flutter/material.dart';

class MakeTopic extends StatelessWidget {
  const MakeTopic({super.key});

  @override
  Widget build(BuildContext context) {
    ColorScheme colorScheme = Theme.of(context).colorScheme;
    return Dialog(
      child: Container(
        width: MediaQuery.of(context).size.width * 0.7,
        height: 380,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: colorScheme.background,),
          child: TextButton(
                onPressed: () {},
                style: TextButton.styleFrom(
                  backgroundColor: colorScheme.primary,
                  padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
                  fixedSize: Size.fromWidth(
                    MediaQuery.of(context).size.width * 0.5,
                  ),
                ),
                child: Text(
                  '랜덤 대화주제 생성하기',
                  style: TextStyle(
                    color: colorScheme.onPrimary.withAlpha(240),
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
    ),
    );
  }
}