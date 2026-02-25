import 'dart:ui'; // Necessario per ImageFilter
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CardHomePage extends StatelessWidget {
  final String titolo;
  final VoidCallback onTap;

  const CardHomePage({super.key, required this.titolo, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 12.0, sigmaY: 12.0),
          child: Container(
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 0, 0, 0).withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.3),
                width: 1.5,
              ),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  const Color.fromARGB(93, 0, 0, 0).withValues(alpha: 0.2),
                  Colors.white.withValues(alpha: 0.05),
                ],
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.4),
                  blurRadius: 30,
                  spreadRadius: -5,
                ),
              ],
            ),
            child: Center(
              child: Text(
                titolo,
                textAlign: TextAlign.center,
                style: GoogleFonts.montserrat(
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                  color:
                      Colors.white, 
                  letterSpacing: 1.2,
                  shadows: [
                    Shadow(color: Colors.grey.shade400, blurRadius: 15),
                  ], 
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
