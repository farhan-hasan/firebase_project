import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_project/firebase_messaging_service.dart';
import 'package:firebase_project/firebase_options.dart';
import 'package:firebase_project/photos_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await FirebaseMessagingService.initialize();
  print(await FirebaseMessagingService.getFCMToken());
  runApp(TennisLiveScoreApp());
}

class TennisLiveScoreApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: PhotosScreen(),
    );
  }

}