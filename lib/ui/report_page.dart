import 'package:flutter/material.dart';

class Report {
  String title;
  bool isSelect;

  Report(
    this.title,
    this.isSelect,
  );
}

class ReportPage extends StatefulWidget {
  const ReportPage({super.key});

  @override
  State<ReportPage> createState() => _ReportPageState();
}

class _ReportPageState extends State<ReportPage> {
  List<Report> reportList = [];
  List reportName = [
    '신분 노출',
    '특정 카뎃 언급',
    '욕설 및 부적절한 언행',
    '기타 비매너 행위',
  ];

  @override
  Widget build(BuildContext context) {
    ColorScheme colorScheme = Theme.of(context).colorScheme;
    for (int i = 0; i < reportName.length; i++) {
      reportList.add(Report(reportName[i], false));
    }
    return Scaffold(
      appBar: AppBar(
          title: const Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            ' 신고 사유',
            style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.w700),
          ),
        ],
      )),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              physics: NeverScrollableScrollPhysics(),
              itemCount: reportName.length,
              itemBuilder: (context, index) {
                return CheckboxListTile(
                  title: Row(
                    children: [
                      const SizedBox(width: 8),
                      Text(
                        reportList[index].title,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: colorScheme.onBackground,
                        ),
                      ),
                    ],
                  ),
                  value: reportList[index].isSelect,
                  onChanged: (value) {
                    setState(() {
                      reportList[index].isSelect = value!;
                    });
                  },
                );
              },
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            style: TextButton.styleFrom(
              backgroundColor: colorScheme.primary,
              padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
              fixedSize: Size.fromWidth(
                MediaQuery.of(context).size.width * 0.5,
              ),
            ),
            child: Text(
              '신고 완료',
              style: TextStyle(
                color: colorScheme.onPrimary.withAlpha(240),
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 25),
        ],
      ),
    );
  }
}
