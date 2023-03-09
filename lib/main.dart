import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:camera/camera.dart';

import 'firebase_options.dart';
import 'homepge.dart';
import 'homevideo.dart';
import 'loginpage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(

  );
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(MaterialApp(home: loginpage()));
}
