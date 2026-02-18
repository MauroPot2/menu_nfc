import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:lounge_menu_nfc/app.dart';
import 'package:lounge_menu_nfc/utility/firebase_options_manual.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(LoungeMenuApp());
}
