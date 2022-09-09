import 'package:chat_app/firebase_options.dart';
import 'package:chat_app/ui/app/my_app.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  const myApp = MyApp();
  runApp(myApp);
}
