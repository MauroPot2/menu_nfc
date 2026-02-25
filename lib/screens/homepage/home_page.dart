import 'package:flutter/material.dart';
import 'package:lounge_menu_nfc/screens/homepage/section/header_logo.dart';
import 'package:lounge_menu_nfc/screens/homepage/section/home_categories_section.dart';
import 'package:lounge_menu_nfc/screens/homepage/section/video_background_card.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          const Positioned.fill(child: VideoBackgroundCard()),

          // --- LIVELLO 2: IL CONTENUTO SCORREVOLE ---
          SafeArea(
            child: CustomScrollView(
              slivers: [const HeaderLogo(), const HomeCategoriesSection()],
            ),
          ),
        ],
      ),
    );
  }
}
