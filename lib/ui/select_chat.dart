import 'package:flutter/material.dart';
import 'package:match_42/viewmodel/chat_list_viewmodel.dart';

class MyRadioListTileWidget extends StatefulWidget {
  @override
  _MyRadioListTileWidgetState createState() => _MyRadioListTileWidgetState();
}

class _MyRadioListTileWidgetState extends State<MyRadioListTileWidget> {
  int _selectedValue = 1;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: <Widget>[
          RadioListTile<int>(
            title: Text('현재 채팅중인 방',
            style: TextStyle(fontWeight: FontWeight.bold,
            fontSize: 19,)),
            value: 1,
            groupValue: _selectedValue,
            onChanged: (value) {
              setState(() {
                _selectedValue = value!;
                if (_selectedValue == 1)
                {}
                else if (_selectedValue == 2)
                {}
              });
            },
          ),
          RadioListTile<int>(
            title: Text('매칭 기록',
            style: TextStyle(fontWeight: FontWeight.bold,
            fontSize: 19,),),
            value: 2,
            groupValue: _selectedValue,
            onChanged: (value) {
              setState(() {
                _selectedValue = value!;
              });
            },
          ),
        ],
      ),
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
        height: 145,
        padding: EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: colorScheme.background,
        ),
        child: MyRadioListTileWidget(),),
    );
  }}