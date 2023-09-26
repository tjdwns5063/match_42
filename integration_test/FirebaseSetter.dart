import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:integration_test/integration_test.dart';
import 'package:http/http.dart' as http;

class FirebaseSetter {
  static Future<void> init() async {
    IntegrationTestWidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp();
    FirebaseFirestore.instance
        .useFirestoreEmulator('localhost', 8080, sslEnabled: false);
    FirebaseFirestore.instance.settings =
        const Settings(persistenceEnabled: false);
  }

  static Future<void> deleteFirestore() async {
    Uri uri = Uri.http('10.0.2.2:8080',
        '/emulator/v1/projects/match-42/databases/(default)/documents');

    http.Response response =
        await http.delete(uri, headers: {'Authorization': 'Bearer owner'});

    if (response.statusCode != 200) {
      print('Firestore clear failed!');
    }
  }
}
