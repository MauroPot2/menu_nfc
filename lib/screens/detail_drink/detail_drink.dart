import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lounge_menu_nfc/models/drink.dart';

class DetailDrink extends StatefulWidget {
  const DetailDrink({super.key, required this.drink});

  final Drink drink;

  @override
  State<DetailDrink> createState() => _DetailDrinkState();
}

class _DetailDrinkState extends State<DetailDrink> {
  Map<String, dynamic>? _tonicaSelezionata;
  Map<String, dynamic>? _baseAlcolicaSelezionata;

  // Calcolo dinamico del prezzo finale
  double get _prezzoTotale {
    double base = widget.drink.prezzo;
    double extraTonica = _tonicaSelezionata?['sovrapprezzo'] ?? 0.0;
    double extraBase = _baseAlcolicaSelezionata?['sovrapprezzo'] ?? 0.0;
    return base + extraTonica + extraBase;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 300,
            flexibleSpace: FlexibleSpaceBar(
              background:
                  widget.drink.immagineUrl != null &&
                      widget.drink.immagineUrl!.isNotEmpty
                  ? Image.network(widget.drink.immagineUrl!, fit: BoxFit.cover)
                  : Center(
                      child: Icon(
                        Icons.local_bar_sharp,
                        size: 100,
                        color: Colors.grey.shade400,
                      ),
                    ),
            ),

            //?
          ),

          SliverToBoxAdapter(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
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
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 1. TITOLO E PREZZO DINAMICO SULLA STESSA RIGA
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          widget.drink.nome,
                          style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 22,
                            letterSpacing: 1.5,
                            shadows: [
                              Shadow(
                                color: Colors.grey.shade400,
                                blurRadius: 15,
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      // Questo prezzo ora usa la variabile calcolata _prezzoTotale!
                      Text(
                        '€ ${_prezzoTotale.toStringAsFixed(2)}',
                        style: GoogleFonts.poppins(
                          color: Colors
                              .amber
                              .shade400, // Colore dorato per dare risalto
                          fontWeight: FontWeight.bold,
                          fontSize: 22,
                          shadows: [
                            Shadow(
                              color: Colors.amber.withValues(alpha: 0.3),
                              blurRadius: 10,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  // 2. DESCRIZIONE
                  if (widget.drink.descrizione.isNotEmpty) ...[
                    const SizedBox(height: 12),
                    Text(
                      widget.drink.descrizione,
                      style: GoogleFonts.poppins(
                        color: Colors.white70,
                        fontSize: 14,
                        height: 1.5, // Migliora la leggibilità se va a capo
                        shadows: [
                          Shadow(
                            color: Colors.black.withValues(alpha: 0.8),
                            blurRadius: 5,
                          ),
                        ],
                      ),
                    ),
                  ],

                  // ---------------------------------------------------------
                  // 3. SEZIONE SCELTE (Solo se è un drink da personalizzare)
                  // ---------------------------------------------------------
                  // Qui puoi usare la tua logica (es. widget.drink.categoria == 'Gin Tonic')
                  if (widget.drink.nome.toLowerCase().contains('tonic') ||
                      widget.drink.descrizione.toLowerCase().contains(
                        'tonica',
                      )) ...[
                    const SizedBox(height: 24),
                    const Divider(
                      color: Colors.white24,
                      thickness: 1,
                    ), // Divisore elegante
                    const SizedBox(height: 16),

                    // --- SCELTA TONICA ---
                    Text(
                      "Personalizza la Tonica",
                      style: GoogleFonts.poppins(
                        color:
                            Colors.amber.shade200, // Richiama il colore premium
                        fontWeight: FontWeight.w500,
                        fontSize: 16,
                        letterSpacing: 1.0,
                      ),
                    ),
                    const SizedBox(height: 12),
                    StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection('bottiglieria')
                          .where('categoria', isEqualTo: 'Toniche Premium')
                          .where('disponibile', isEqualTo: true)
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData)
                          return const CircularProgressIndicator(
                            color: Colors.amber,
                          );
                        var toniche = snapshot.data!.docs;
                        if (toniche.isEmpty) return const SizedBox.shrink();

                        return Wrap(
                          spacing: 10,
                          runSpacing: 10,
                          children: toniche.map((doc) {
                            var data = doc.data() as Map<String, dynamic>;
                            String nome = data['nome'] ?? 'Sconosciuta';
                            double extra =
                                data['sovrapprezzo']?.toDouble() ?? 0.0;
                            String labelText = extra > 0
                                ? "$nome (+€${extra.toStringAsFixed(2)})"
                                : nome;
                            bool isSelected =
                                _tonicaSelezionata?['nome'] == nome;

                            // Chip Grafico Premium
                            return ChoiceChip(
                              label: Text(labelText),
                              selected: isSelected,
                              selectedColor: Colors.amber.shade700.withValues(
                                alpha: 0.3,
                              ), // Sfondo dorato scuro
                              backgroundColor: Colors
                                  .black45, // Sfondo quasi nero se non selezionato
                              showCheckmark:
                                  false, // Togliamo la spunta di default di Flutter per un look più pulito
                              labelStyle: GoogleFonts.poppins(
                                color: isSelected
                                    ? Colors.amberAccent
                                    : Colors.white70,
                                fontWeight: isSelected
                                    ? FontWeight.w600
                                    : FontWeight.normal,
                                fontSize: 13,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                                side: BorderSide(
                                  color: isSelected
                                      ? Colors.amber.shade600
                                      : Colors.white24,
                                  width: 1.5,
                                ),
                              ),
                              onSelected: (bool selected) {
                                setState(() {
                                  _tonicaSelezionata = selected ? data : null;
                                });
                              },
                            );
                          }).toList(),
                        );
                      },
                    ),

                    const SizedBox(height: 24),

                    // --- SCELTA BASE ALCOLICA ---
                    Text(
                      "Upgrade Base Alcolica",
                      style: GoogleFonts.poppins(
                        color: Colors.amber.shade200,
                        fontWeight: FontWeight.w500,
                        fontSize: 16,
                        letterSpacing: 1.0,
                      ),
                    ),
                    const SizedBox(height: 12),
                    //StreamBuilder puntando a gin
                    StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection('bottiglieria')
                          .where(
                            'categoria',
                            isEqualTo: 'Gin',
                          ) // Modifica la categoria in base al drink!
                          .where('disponibile', isEqualTo: true)
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData){
                          return const CircularProgressIndicator(
                            color: Colors.amber,
                          );
                        }
                        var basi = snapshot.data!.docs;
                        if (basi.isEmpty) return const SizedBox.shrink();

                        return Wrap(
                          spacing: 10,
                          runSpacing: 10,
                          children: basi.map((doc) {
                            var data = doc.data() as Map<String, dynamic>;
                            String nome = data['nome'] ?? 'Sconosciuta';
                            double extra =
                                data['sovrapprezzo']?.toDouble() ?? 0.0;
                            String labelText = extra > 0
                                ? "$nome (+€${extra.toStringAsFixed(2)})"
                                : nome;
                            bool isSelected =
                                _baseAlcolicaSelezionata?['nome'] == nome;

                            return ChoiceChip(
                              label: Text(labelText),
                              selected: isSelected,
                              selectedColor: Colors.amber.shade700.withValues(
                                alpha: 0.3,
                              ),
                              backgroundColor: Colors.black45,
                              showCheckmark: false,
                              labelStyle: GoogleFonts.poppins(
                                color: isSelected
                                    ? Colors.amberAccent
                                    : Colors.white70,
                                fontWeight: isSelected
                                    ? FontWeight.w600
                                    : FontWeight.normal,
                                fontSize: 13,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                                side: BorderSide(
                                  color: isSelected
                                      ? Colors.amber.shade600
                                      : Colors.white24,
                                  width: 1.5,
                                ),
                              ),
                              onSelected: (bool selected) {
                                setState(() {
                                  _baseAlcolicaSelezionata = selected
                                      ? data
                                      : null;
                                });
                              },
                            );
                          }).toList(),
                        );
                      },
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
