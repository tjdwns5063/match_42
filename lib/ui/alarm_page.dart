import 'package:flutter/material.dart';

class AlarmPage extends StatelessWidget {
  const AlarmPage({super.key});

  @override
  Widget build(BuildContext context) {
    ColorScheme colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(title: const Text('알림',
      style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.w700),)),
      body: const Center(
        child: Text('알림이 없습니다.',
        style: TextStyle(fontSize: 20.0,
        // color: Colors.black.withAlpha(170)),
         ), ),
      ),
    );
  }
}
