import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lounge_menu_nfc/models/drink.dart';
import 'package:lounge_menu_nfc/screens/details_category/section/card_drink.dart';

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
      // IMPORTANTE: Sfondo scuro per far risaltare le card luxury
      backgroundColor: const Color(0xFF1A1A1A),
      appBar: AppBar(
        title: Text(
          categoriaLabel,
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.transparent,
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
      ),
      body: StreamBuilder<QuerySnapshot>(
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
            itemCount: drinks.length,
            itemBuilder: (context, index) {
              final drink = drinks[index];

              // --- USIAMO LA NUOVA CARD ANIMATA ---
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
                        style: const TextStyle(color: Colors.black),
                      ),
                      backgroundColor: const Color(0xFFD4AF37),
                      duration: const Duration(seconds: 1),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
