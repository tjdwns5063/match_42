import 'package:flutter/material.dart';
import 'package:match_42/viewmodel/chat_list_viewmodel.dart';
import 'package:provider/provider.dart';

class MyRadioListTileWidget extends StatelessWidget {
  const MyRadioListTileWidget({super.key});

  @override
  Widget build(BuildContext context) {
    ChatListViewModel viewModel = context.watch();

    return Center(
      child: Column(
        children: <Widget>[
          RadioListTile<int>(
            title: const Text('현재 채팅중인 방',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 19,
                )),
            value: 1,
            groupValue: viewModel.isOn,
            onChanged: (value) {
              viewModel.isOn = value!;
            },
          ),
          RadioListTile<int>(
            title: const Text(
              '비활성화 된 방',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 19,
              ),
            ),
            value: 2,
            groupValue: viewModel.isOn,
            onChanged: (value) {
              viewModel.isOn = value!;
            },
          ),
        ],
      ),
    );
  }
}

// class MyRadioListTileWidget extends StatefulWidget {
//   const MyRadioListTileWidget({super.key});
//
//   @override
//   State<MyRadioListTileWidget> createState() => _MyRadioListTileWidgetState();
// }
//
// class _MyRadioListTileWidgetState extends State<MyRadioListTileWidget> {
//   int _selectedValue = 1;
//
//   @override
//   Widget build(BuildContext context) {}
// }

class SelectChat extends StatelessWidget {
  const SelectChat({super.key});

  @override
  Widget build(BuildContext context) {
    ColorScheme colorScheme = Theme.of(context).colorScheme;
    return Dialog(
      child: Container(
        width: MediaQuery.of(context).size.width * 0.7,
        height: 145,
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: colorScheme.background,
        ),
        child: MyRadioListTileWidget(),
      ),
    );
  }
}
