import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lounge_menu_nfc/models/categoria.dart';
import 'package:lounge_menu_nfc/models/drink.dart';
import 'package:lounge_menu_nfc/screens/details_category/category_drink_page.dart';
import 'package:lounge_menu_nfc/screens/homepage/section/card_home_page.dart';

class HomeCategoriesSection extends StatelessWidget {
  const HomeCategoriesSection({super.key});

  String _ottieniLabelBella(String codice) {
    try {
      return Categoria.values.firstWhere((e) => e.name == codice).label;
    } catch (e) {
      return codice;
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('menu').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return SliverToBoxAdapter(child: Text("Errore: ${snapshot.error}"));
        }
        if (!snapshot.hasData) {
          return const SliverToBoxAdapter(
            child: Center(child: CircularProgressIndicator()),
          );
        }

        final List<Drink> allDrink = snapshot.data!.docs.map((doc) {
          return Drink.fromFirestore(doc);
        }).toList();

        final listaCategorie = allDrink
            .map((drink) => drink.categoria)
            .toSet()
            .toList();

        return SliverPadding(
          padding: const EdgeInsets.all(16),
          sliver: SliverGrid(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 15,
              crossAxisSpacing: 15,
              childAspectRatio: 0.9,
            ),
            delegate: SliverChildBuilderDelegate((context, index) {
              final codice = listaCategorie[index];
              return CardHomePage(
                titolo: _ottieniLabelBella(codice),
                onTap: () {
                  // Navigazione verso la pagina filtrata
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CategoryDrinksPage(
                        categoriaCodice:
                            codice, // Passiamo 'cocktail' (per la query)
                        categoriaLabel: _ottieniLabelBella(
                          codice,
                        ), // Passiamo 'Cocktail' (per il titolo)
                      ),
                    ),
                  );
                },
              );
            }, childCount: listaCategorie.length),
          ),
        );
      },
    );
  }
}
