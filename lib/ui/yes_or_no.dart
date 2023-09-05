import 'package:flutter/material.dart';
import 'package:match_42/viewmodel/chat_viewmodel.dart';
import 'package:provider/provider.dart';

class YesOrNo extends StatelessWidget {
  const YesOrNo({super.key});

  @override
  Widget build(BuildContext context) {
    ColorScheme colorScheme = Theme.of(context).colorScheme;
    ChatViewModel viewModel = context.read();
    return Dialog(
        child: Container(
      height: 300,
      width: 300,
      padding: EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: colorScheme.background.withOpacity(0.5),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(height: 7),
          Text('인트라 id를 공개할까요?',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 22,
                color: colorScheme.onBackground,
              )),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextButton(
                onPressed: () {
                  viewModel.updateOpenResult();
                  // Navigator.of(context).pop(true);
                },
                style: TextButton.styleFrom(
                  backgroundColor: colorScheme.secondaryContainer,
                ),
                child: Text(
                  '예',
                  style: TextStyle(
                    color: colorScheme.onSecondaryContainer,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ),
              SizedBox(width: 20),
              TextButton(
                onPressed: () {
                  // Navigator.of(context).pop(false);
                },
                style: TextButton.styleFrom(
                  backgroundColor: colorScheme.secondaryContainer,
                ),
                child: Text(
                  '아니요',
                  style: TextStyle(
                    color: colorScheme.onSecondaryContainer,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    ));
  }
}
