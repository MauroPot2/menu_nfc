import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lounge_menu_nfc/models/drink.dart'; // Importa il tuo modello

class DrinkAnimatedCard extends StatefulWidget {
  final Drink drink; // Usiamo l'oggetto Drink invece della Map
  final VoidCallback onTap; // Gestiamo il click

  const DrinkAnimatedCard({
    super.key, 
    required this.drink, 
    required this.onTap
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

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeIn),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic),
    );

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
            color: const Color(0xFF2C2C2C).withOpacity(0.6), 
            borderRadius: BorderRadius.circular(15),
            border: Border.all(color: Colors.white.withOpacity(0.1)),
            boxShadow: [
               BoxShadow(
                 color: Colors.black.withOpacity(0.2),
                 blurRadius: 10,
                 offset: const Offset(0, 5),
               )
            ]
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: widget.onTap, // Colleghiamo il click qui
              borderRadius: BorderRadius.circular(15),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
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
                        color: Colors.grey[800],
                      ),
                      child: widget.drink.immagineUrl == null
                          ? const Icon(Icons.local_bar, color: Color(0xFFD4AF37))
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
                            ),
                          ),
                          if (widget.drink.descrizione.isNotEmpty) ...[
                            const SizedBox(height: 4),
                            Text(
                              widget.drink.descrizione,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.poppins(
                                color: Colors.white60, 
                                fontSize: 12
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
                        color: const Color(0xFFD4AF37), // Color ORO
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
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