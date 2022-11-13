import 'package:camera/camera.dart';
import 'package:chat_app/firebase_options.dart';
import 'package:chat_app/ui/app/my_app.dart';
import 'package:chat_app/ui/utils/app_constants.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:path_provider/path_provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // initialize firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // allow app to use camera
  cameras = await availableCameras();

  // allow save data in storage
  final storage = await HydratedStorage.build(
    storageDirectory: await getApplicationDocumentsDirectory(),
  );

  // set app orientation to portrait only
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  const myApp = MyApp();
  HydratedBlocOverrides.runZoned(
    () => runApp(
      myApp,
    ),
    storage: storage,
  );
}
