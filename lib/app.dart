import 'package:flutter/material.dart';
import 'package:lounge_menu_nfc/screens/admin/admin_panel.dart';
import 'package:lounge_menu_nfc/screens/admin/login_panel.dart';
import 'package:lounge_menu_nfc/screens/homepage/home_page.dart';

class LoungeMenuApp extends StatelessWidget {
  const LoungeMenuApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Lounge Bar Menu',
      theme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: Color.fromARGB(255, 167, 166, 163),
      ),
      // routing
      initialRoute: '/homepage',
      routes: {
        '/admin': (context) => AdminPanel(),
        '/homepage': (context) => HomePage(),
        '/login': (context) => LoginPanel(),
      },
    );
  }
}
