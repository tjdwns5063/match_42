import 'package:flutter/material.dart';

class MyRadioListTileWidget extends StatefulWidget {
  @override
  _MyRadioListTileWidgetState createState() => _MyRadioListTileWidgetState();
}

class _MyRadioListTileWidgetState extends State<MyRadioListTileWidget> {
  int _selectedValue = 1; // 초기 선택 값

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        RadioListTile<int>(
          title: Text('옵션 1'),
          value: 1,
          groupValue: _selectedValue,
          onChanged: (value) {
            setState(() {
              _selectedValue = value!;
            });
          },
        ),
        RadioListTile<int>(
          title: Text('옵션 2'),
          value: 2,
          groupValue: _selectedValue,
          onChanged: (value) {
            setState(() {
              _selectedValue = value!;
            });
          },
        ),
      ],
    );
  }
}

class SelectChat extends StatelessWidget {
  const SelectChat({super.key});

  @override
  Widget build(BuildContext context) {
    ColorScheme colorScheme = Theme.of(context).colorScheme;
    return Dialog(
      child: Container(
        width: MediaQuery.of(context).size.width * 0.7,
        height: 380,
        padding: EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: colorScheme.background,
        ),
        child: MyRadioListTileWidget(),),
    );
  }}