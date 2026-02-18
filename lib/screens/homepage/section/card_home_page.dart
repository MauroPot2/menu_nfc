import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CardHomePage extends StatelessWidget {
  final String titolo;
  final VoidCallback onTap;

  const CardHomePage({super.key, required this.titolo, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 10.0,
      shadowColor: const Color(
        0xFFD4AF37,
      ).withValues(alpha: 0.2), // Ombra leggermente dorata
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 8.0),
          child: Column(
            mainAxisAlignment:
                MainAxisAlignment.center, // Centra il contenuto nella griglia
            children: <Widget>[
              const Icon(
                Icons.local_bar,
                color: Color.fromARGB(255, 181, 179, 175),
                size: 30,
              ),
              const SizedBox(height: 8),
              Text(
                titolo,
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  color: const Color(0xFFD4AF37),
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              Text(
                'Scopri la selezione',
                style: GoogleFonts.poppins(
                  fontSize: 11,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
