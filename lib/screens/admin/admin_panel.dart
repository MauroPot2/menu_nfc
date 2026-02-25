import 'package:flutter/material.dart';
import 'package:lounge_menu_nfc/screens/admin/add_drink.dart';
import 'package:lounge_menu_nfc/screens/admin/section/build_admin_card.dart';
import 'package:lounge_menu_nfc/screens/homepage/home_page.dart';

class AdminPanel extends StatelessWidget {
  const AdminPanel({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pannello di Controllo'),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.menu_book_rounded),
            tooltip: 'Visualizza Menu Clienti',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const HomePage()),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.count(
          crossAxisCount: 2, // Numero di colonne
          crossAxisSpacing: 16.0, // Spazio orizzontale
          mainAxisSpacing: 16.0, // Spazio verticale
          children: [
            BuildAdminCart(
              context: context,
              title: 'Modifica Menu',
              icon: Icons.local_bar,
              color: Colors.blueAccent,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AddDrink()),
                );
              },
            ),
            BuildAdminCart(
              context: context,
              title: 'Gestione NFC',
              icon: Icons.nfc,
              color: Colors.orangeAccent,
              onTap: () {
                //? Sostituire con la pagina NFC
              },
            ),
            BuildAdminCart(
              context: context,
              title: 'Categorie',
              icon: Icons.category,
              color: Colors.purpleAccent,
              onTap: () {
                //? Sostituire con la pagina Categorie
              },
            ),
            BuildAdminCart(
              context: context,
              title: 'Impostazioni',
              icon: Icons.settings,
              color: Colors.blueGrey,
              onTap: () {
                //? Sostituire con la pagina Impostazioni
              },
            ),
          ],
        ),
      ),
    );
  }
}
