import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lounge_menu_nfc/models/drink.dart';
import 'package:lounge_menu_nfc/screens/details_category/section/card_drink.dart';
import 'package:lounge_menu_nfc/screens/homepage/section/video_background_card.dart';

class CategoryDrinksPage extends StatelessWidget {
  final String categoriaCodice;
  final String categoriaLabel;

  const CategoryDrinksPage({
    super.key,
    required this.categoriaCodice,
    required this.categoriaLabel,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // 1. IL TOCCO MAGICO: Estende il corpo dietro la AppBar
      extendBodyBehindAppBar: true,
      // 2. Sfondo trasparente per far vedere il livello sottostante
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: Text(
          categoriaLabel,
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.transparent,
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
      ),
      // 3. Usiamo lo Stack per sovrapporre la lista al video
      body: Stack(
        children: [
          // --- LIVELLO 1: IL VIDEO DI SFONDO ---
          const Positioned.fill(child: VideoBackgroundCard()),

          // --- LIVELLO 2: LA LISTA DEI DRINK ---
          // Usiamo SafeArea per evitare che le card finiscano "sotto" la AppBar trasparente
          SafeArea(
            bottom:
                false, // Lasciamo che la lista scorra liberamente fino al bordo inferiore del telefono
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('menu')
                  .where('categoria', isEqualTo: categoriaCodice)
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(
                    child: CircularProgressIndicator(color: Color(0xFFD4AF37)),
                  );
                }

                final List<Drink> drinks = snapshot.data!.docs
                    .map((doc) => Drink.fromFirestore(doc))
                    .toList();

                if (drinks.isEmpty) {
                  return const Center(
                    child: Text(
                      "Nessun drink in questa categoria",
                      style: TextStyle(color: Colors.white),
                    ),
                  );
                }

                return ListView.builder(
                  // Aggiungiamo un po' di padding generale alla lista per farla respirare
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16.0,
                    vertical: 8.0,
                  ),
                  itemCount: drinks.length,
                  itemBuilder: (context, index) {
                    final drink = drinks[index];

                    return DrinkAnimatedCard(
                      drink: drink,
                      onTap: () {
                        // Incremento Popolarità
                        Drink.incrementaPopolarita(drink.id);

                        // Feedback Utente
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              "Hai scelto: ${drink.nome}",
                              style: const TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            backgroundColor: const Color(0xFFD4AF37),
                            duration: const Duration(seconds: 2),
                          ),
                        );
                      },
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
