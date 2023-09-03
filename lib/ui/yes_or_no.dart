import 'package:flutter/material.dart';

class YesOrNo extends StatefulWidget {
  const YesOrNo({super.key});

  @override
  State<YesOrNo> createState() => _YesOrNoState();
}

class _YesOrNoState extends State<YesOrNo> {
   bool isYesSelected = false;
  bool isNoSelected = false;

  void selectYes() {
    setState(() {
      isYesSelected = true;
      isNoSelected = false;
    });
  }

  void selectNo() {
    setState(() {
      isYesSelected = false;
      isNoSelected = true;
    });
  }
  @override
  Widget build(BuildContext context) {
    ColorScheme colorScheme = Theme.of(context).colorScheme;
    return Dialog(
      child: Container(
        width: MediaQuery.of(context).size.width * 0.7,
        height: 150,
        padding: EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: colorScheme.background,
        ),
        child: Center(
          child: Column(
            children: [
              SizedBox(height: 7),
              Text('인트라 id를 공개할까요?',
              style: TextStyle(fontWeight: FontWeight.bold,
              fontSize: 22,
              color: colorScheme.onBackground,)),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  TextButton(
                    onPressed: (){selectYes;
                    Navigator.of(context).pop(true);
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
                    onPressed: (){selectNo;
                    Navigator.of(context).pop(false);},
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
        ),

        )
    );
  }
}