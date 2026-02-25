import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lounge_menu_nfc/models/drink.dart'; // Importa il tuo modello

class DrinkAnimatedCard extends StatefulWidget {
  final Drink drink; // Usiamo l'oggetto Drink invece della Map
  final VoidCallback onTap; // Gestiamo il click

  const DrinkAnimatedCard({
    super.key,
    required this.drink,
    required this.onTap,
  });

  @override
  State<DrinkAnimatedCard> createState() => _DrinkAnimatedCardState();
}

class _DrinkAnimatedCardState extends State<DrinkAnimatedCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeIn));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: SlideTransition(
        position: _slideAnimation,
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            // Sfondo scuro semitrasparente per far risaltare il testo bianco
            color: const Color(0xFF1A1A1A).withValues(alpha: 0.8),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: Colors.grey.shade300, width: 2.0),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withValues(alpha: 0.6),
                blurRadius: 20,
                spreadRadius: 2,
              ),
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.5),
                blurRadius: 10,
                offset: Offset(0, 5),
              ),
            ],
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: widget.onTap, // Colleghiamo il click qui
              borderRadius: BorderRadius.circular(15),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 15,
                ),
                child: Row(
                  children: [
                    // Immagine o Icona
                    Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: widget.drink.immagineUrl != null
                            ? DecorationImage(
                                image: NetworkImage(widget.drink.immagineUrl!),
                                fit: BoxFit.cover,
                              )
                            : null,
                        color: Colors.white,
                      ),
                      child: widget.drink.immagineUrl == null
                          ? const Icon(
                              Icons.local_bar,
                              color: Color.fromARGB(255, 118, 117, 116),
                            )
                          : null,
                    ),
                    const SizedBox(width: 15),
                    // Testi
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.drink.nome,
                            style: GoogleFonts.poppins(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                              letterSpacing: 1.5,
                              shadows: [
                                Shadow(
                                  color: Colors.grey.shade400,
                                  blurRadius: 15,
                                ),
                              ],
                            ),
                          ),
                          if (widget.drink.descrizione.isNotEmpty) ...[
                            const SizedBox(height: 4),
                            Text(
                              widget.drink.descrizione,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.poppins(
                                color: Colors.white,
                                fontSize: 12,
                                shadows: [
                                  Shadow(
                                    color: Colors.grey.shade400,
                                    blurRadius: 15,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                    // Prezzo
                    Text(
                      "€ ${widget.drink.prezzo.toStringAsFixed(2)}",
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        shadows: [
                          Shadow(color: Colors.grey.shade400, blurRadius: 15),
                        ],
                      ),
                    ),
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
