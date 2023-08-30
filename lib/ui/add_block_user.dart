import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AddBlockUser extends StatelessWidget {
  const AddBlockUser({super.key});

  @override
  Widget build(BuildContext context) {
    ColorScheme colorScheme = Theme.of(context).colorScheme;
    return Dialog(
      child: Container(
        width: MediaQuery.of(context).size.width * 0.7,
        height: 175,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: colorScheme.background,
      ),
      child: Center(
        child: Column(
          children: [
            // SizedBox(height:5),
            GetId(),
            const SizedBox(height: 2),
            TextButton(
                    onPressed: () {},
                    style: TextButton.styleFrom(
                      backgroundColor: colorScheme.primary,
                      padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
                      fixedSize: Size.fromWidth(
                        MediaQuery.of(context).size.width * 0.5,
                      ),
                    ),
                    child: Text(
                      '확인',
                      style: TextStyle(
                        color: colorScheme.onPrimary.withAlpha(240),
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
          ],
        ),
      ),)
    );
  }
}

class GetId extends StatefulWidget {
  @override
  _GetIdState createState() => _GetIdState();
}

class _GetIdState extends State<GetId> {
  TextEditingController _controller = TextEditingController(); // 입력을 관리하기 위한 컨트롤러

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16.0),
      child: TextField(
        controller: _controller, // 컨트롤러 연결
        decoration: InputDecoration(
          labelText: '차단할 intra id를 입력하세요.', // 입력 필드 위에 표시되는 힌트 텍스트
        ),
      ),
    );
  }
}