import 'package:flutter/material.dart';
import 'package:lounge_menu_nfc/screens/homepage/section/header_logo.dart';
import 'package:lounge_menu_nfc/screens/homepage/section/home_categories_section.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [HeaderLogo(), HomeCategoriesSection()],
        ),
      ),
    );
  }
}
