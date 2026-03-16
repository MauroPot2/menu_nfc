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
  // Mappa per gestire le selezioni indipendenti per ogni categoria
  final Map<String, Map<String, dynamic>?> _scelteAttive = {};

  // Calcolo dinamico del prezzo finale (Base + Extra)
  double get _prezzoTotale {
    double totale = widget.drink.prezzo;
    _scelteAttive.forEach((categoria, selezione) {
      if (selezione != null) {
        totale += (selezione['sovrapprezzo'] as num?)?.toDouble() ?? 0.0;
      }
    });
    return totale;
  }

  @override
  Widget build(BuildContext context) {
    // Configurazione: Parola chiave nell'ingrediente -> Categoria in Bottiglieria
    final Map<String, String> configUpgrade = {
      'tonica': 'Toniche Premium',
      'gin': 'Gin',
      'vodka': 'Vodka',
      'rum': 'Rum',
      'tequila': 'Tequila',
    };

    return Scaffold(
      backgroundColor: Colors.black,
      body: CustomScrollView(
        slivers: [
          // AppBar con immagine del Drink
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background:
                  widget.drink.immagineUrl != null &&
                      widget.drink.immagineUrl!.isNotEmpty
                  ? Image.network(widget.drink.immagineUrl!, fit: BoxFit.cover)
                  : Center(
                      child: Icon(
                        Icons.local_bar_sharp,
                        size: 100,
                        color: Colors.grey.shade800,
                      ),
                    ),
            ),
          ),

          SliverToBoxAdapter(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: const Color(0xFF1A1A1A),
                borderRadius: BorderRadius.circular(28),
                border: Border.all(color: Colors.white10, width: 1.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.5),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 1. INTESTAZIONE: NOME E PREZZO DINAMICO
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          widget.drink.nome,
                          style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 24,
                            letterSpacing: 1.2,
                          ),
                        ),
                      ),
                      Text(
                        '€ ${_prezzoTotale.toStringAsFixed(2)}',
                        style: GoogleFonts.poppins(
                          color: Colors.amber.shade400,
                          fontWeight: FontWeight.bold,
                          fontSize: 24,
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
                        fontSize: 15,
                        height: 1.5,
                      ),
                    ),
                  ],

                  // 3. GENERAZIONE DINAMICA SEZIONI PERSONALIZZAZIONE
                  ...configUpgrade.entries
                      .where((entry) {
                        // Controlla se l'ingrediente (es. 'gin') è presente nella lista ingredienti del drink
                        return widget.drink.ingredienti.any(
                          (ing) => ing.toLowerCase().contains(entry.key),
                        );
                      })
                      .map((entry) {
                        final String categoriaFS = entry.value;

                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 32),
                            const Divider(color: Colors.white10, thickness: 1),
                            const SizedBox(height: 16),
                            Text(
                              "Personalizza $categoriaFS",
                              style: GoogleFonts.poppins(
                                color: Colors.amber.shade200,
                                fontWeight: FontWeight.w500,
                                fontSize: 16,
                                letterSpacing: 0.5,
                              ),
                            ),
                            const SizedBox(height: 16),
                            StreamBuilder<QuerySnapshot>(
                              stream: FirebaseFirestore.instance
                                  .collection('bottiglieria')
                                  .where('categoria', isEqualTo: categoriaFS)
                                  .where('disponibile', isEqualTo: true)
                                  .snapshots(),
                              builder: (context, snapshot) {
                                if (!snapshot.hasData) {
                                  return const LinearProgressIndicator(
                                    color: Colors.amber,
                                  );
                                }

                                final opzioni = snapshot.data!.docs;
                                if (opzioni.isEmpty) {
                                  return const SizedBox.shrink();
                                }

                                return Wrap(
                                  spacing: 12,
                                  runSpacing: 12,
                                  children: opzioni.map((doc) {
                                    final data =
                                        doc.data() as Map<String, dynamic>;
                                    final String nome = data['nome'] ?? '';
                                    final double extra =
                                        (data['sovrapprezzo'] as num?)
                                            ?.toDouble() ??
                                        0.0;

                                    final bool isSelected =
                                        _scelteAttive[categoriaFS]?['nome'] ==
                                        nome;

                                    return ChoiceChip(
                                      label: Text(
                                        extra > 0
                                            ? "$nome (+€${extra.toStringAsFixed(2)})"
                                            : nome,
                                      ),
                                      selected: isSelected,
                                      onSelected: (selected) {
                                        setState(() {
                                          _scelteAttive[categoriaFS] = selected
                                              ? data
                                              : null;
                                        });
                                      },
                                      selectedColor: Colors.amber.shade700
                                          .withValues(alpha: 0.3),
                                      backgroundColor: Colors.white.withValues(
                                        alpha: 0.05,
                                      ),
                                      showCheckmark: false,
                                      labelStyle: GoogleFonts.poppins(
                                        color: isSelected
                                            ? Colors.amberAccent
                                            : Colors.white70,
                                        fontSize: 13,
                                        fontWeight: isSelected
                                            ? FontWeight.w600
                                            : FontWeight.normal,
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
                                    );
                                  }).toList(),
                                );
                              },
                            ),
                          ],
                        );
                      }),

                  // Spazio finale per non coprire l'ultimo elemento col bottone
                  const SizedBox(height: 100),
                ],
              ),
            ),
          ),
        ],
      ),

      // Esempio di Bottone d'ordine fisso in basso
      bottomSheet: Container(
        color: const Color(0xFF1A1A1A),
        padding: const EdgeInsets.all(20),
        child: ElevatedButton(
          onPressed: () {
            // Logica per inviare l'ordine con _scelteAttive
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.amber.shade600,
            foregroundColor: Colors.black,
            minimumSize: const Size(double.infinity, 55),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
          child: Text(
            "Ordina - € ${_prezzoTotale.toStringAsFixed(2)}",
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
        ),
      ),
    );
  }
}
