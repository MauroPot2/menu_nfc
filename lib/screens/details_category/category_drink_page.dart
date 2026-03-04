import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lounge_menu_nfc/models/drink.dart';
import 'package:lounge_menu_nfc/screens/detail_drink/detail_drink.dart';
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
      extendBodyBehindAppBar: true,
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

      body: Stack(
        children: [
          const Positioned.fill(child: VideoBackgroundCard()),

          SafeArea(
            bottom: false,
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
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => DetailDrink(drink: drink),
                          ),
                        );

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
                            backgroundColor: const Color.fromARGB(
                              255,
                              122,
                              122,
                              121,
                            ),
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
