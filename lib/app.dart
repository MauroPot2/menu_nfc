import 'package:flutter/material.dart';
import 'package:lounge_menu_nfc/screens/admin_panel.dart';
import 'package:lounge_menu_nfc/screens/homepage/home_page.dart';

class LoungeMenuApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Lounge Bar Menu',
      theme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.amber,
      ),
      // routing
      initialRoute: '/homepage',
      routes: {
        '/admin': (context) => AdminPanel(),
        '/homepage': (context) => HomePage(),
      },
    );
  }
}
