import 'dart:ui'; // Necessario per ImageFilter
import 'package:flutter/material.dart';

class CardHomePage extends StatelessWidget {
  final String titolo;
  final VoidCallback onTap;

  const CardHomePage({super.key, required this.titolo, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: ClipRRect(
        // Fondamentale: taglia l'effetto sfocatura per non farlo uscire dai bordi
        borderRadius: BorderRadius.circular(24),
        child: BackdropFilter(
          // Regola sigmaX e sigmaY per aumentare o dimin<uire l'intensità della sfocatura
          filter: ImageFilter.blur(sigmaX: 12.0, sigmaY: 12.0),
          child: Container(
            decoration: BoxDecoration(
              // Sfondo semi-trasparente
              color: const Color.fromARGB(255, 0, 0, 0).withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(24),
              // Il tocco magico del Glassmorphism: un bordo sottile e luminoso
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.3),
                width: 1.5,
              ),
              // Un gradiente molto leggero per dare profondità al vetro
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  const Color.fromARGB(93, 0, 0, 0).withValues(alpha: 0.2),
                  Colors.white.withValues(alpha: 0.05),
                ],
              ),
              // Opzionale: un'ombra leggera per staccare la card dallo sfondo
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
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                  color:
                      Colors.white, // Usa un colore che contrasti con lo sfondo
                  letterSpacing: 1.2, // Spaziatura elegante
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
