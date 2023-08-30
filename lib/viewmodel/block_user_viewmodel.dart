import 'package:flutter/cupertino.dart';
import 'package:match_42/ui/my_page.dart';
import 'package:match_42/data/user.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:match_42/viewmodel/login_viewmodel.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';

class BlockUserViewModel extends ChangeNotifier {

  
//   void onPressed(int index) {
//     isSelect[index].isSelect = !isSelect[index].isSelect;

//     notifyListeners();
//   }

//   verifyButton(BuildContext context) async {
//     LoginViewModel loginViewModel = context.read();
//     for (int i = 0; i < isSelect.length; i++) {
//       if (isSelect[i].isSelect) {
//         Uri uri = Uri.http('115.85.181.92', '/api/v1/user/interest',
//             {'interest': isSelect[i].title});
//         print(isSelect[i].title);

//         print(uri.toString());

//         Response response =
//             await http.post(uri, headers: {'Authorization': 'Bearer $token'});
//         print('body: ${response.body} ${response.headers}');
//         // Map<String, dynamic> json = jsonDecode(response.body);
//         // User user = User.fromJson(json);
//         // loginViewModel.updateUser(user);
//       }
//     }
//   }
}
