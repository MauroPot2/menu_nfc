import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:marquee/marquee.dart'; // Assicurati di aver aggiunto il pacchetto
import 'package:google_fonts/google_fonts.dart';

import 'package:lounge_menu_nfc/screens/homepage/section/header_logo.dart';
import 'package:lounge_menu_nfc/screens/homepage/section/home_categories_section.dart';
import 'package:lounge_menu_nfc/screens/homepage/section/video_background_card.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection('impostazioni')
            .doc('banner_home')
            .snapshots(),
        builder: (context, snapshot) {
          bool showBanner = false;
          String bannerText = '';
          bool showTicker = false;
          String tickerText = '';

          if (snapshot.hasData && snapshot.data!.exists) {
            var data = snapshot.data!.data() as Map<String, dynamic>;
            showBanner = data['banner_attivo'] ?? false;
            bannerText = data['banner_testo'] ?? '';
            showTicker = data['ticker_attivo'] ?? false;
            tickerText = data['ticker_testo'] ?? '';
          }

          return Stack(
            children: [
              const Positioned.fill(child: VideoBackgroundCard()),

              SafeArea(
                child: CustomScrollView(
                  slivers: [
                    const HeaderLogo(),

                    if (showBanner && bannerText.isNotEmpty)
                      SliverToBoxAdapter(
                        child: Container(
                          margin: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Colors.amber.shade700,
                                Colors.amber.shade400,
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.amber.withValues(alpha: 0.3),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.local_offer_rounded,
                                color: Colors.black87,
                                size: 28,
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  bannerText,
                                  style: GoogleFonts.poppins(
                                    color: Colors.black87,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                    const HomeCategoriesSection(),

                    if (showTicker && tickerText.isNotEmpty)
                      const SliverToBoxAdapter(child: SizedBox(height: 50)),
                  ],
                ),
              ),

              if (showTicker && tickerText.isNotEmpty)
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    height: 45,
                    decoration: BoxDecoration(
                      color: Colors.black87,
                      border: Border(
                        top: BorderSide(color: Colors.amber.shade600, width: 2),
                      ),
                    ),
                    child: Marquee(
                      text: tickerText,
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                        letterSpacing: 1.2,
                      ),
                      scrollAxis: Axis.horizontal,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      blankSpace:
                          100.0, // Spazio vuoto prima che la frase ricominci
                      velocity: 40.0, // Velocità di scorrimento (regolabile)
                      startPadding: 10.0,
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}
