import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lounge_menu_nfc/screens/admin/admin_panel.dart';
import 'package:lounge_menu_nfc/screens/admin/section/delete_button.dart';
import 'package:lounge_menu_nfc/screens/admin/section/hide_button.dart';
import '../../models/categoria.dart';

class AddDrink extends StatefulWidget {
  @override
  _AddDrinkState createState() => _AddDrinkState();
}

class _AddDrinkState extends State<AddDrink> {
  final TextEditingController _nomeController = TextEditingController();
  final TextEditingController _prezzoController = TextEditingController();
  final TextEditingController _descController = TextEditingController();
  final TextEditingController _ingredientiController = TextEditingController();
  // default cocktail
  Categoria _categoriaSelezionata = Categoria.cocktail;

  void _aggiungiDrink() async {
    if (_nomeController.text.isEmpty || _prezzoController.text.isEmpty) return;

    double priceDouble =
        double.tryParse(_prezzoController.text.replaceAll(',', '.')) ?? 0.0;

    List<String> listaIngredienti = _ingredientiController.text
        .split(',')
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)
        .toList();

    Map<String, dynamic> nuovoDrink = {
      'nome': _nomeController.text,
      'descrizione': _descController.text,
      'prezzo': priceDouble,
      'categoria': _categoriaSelezionata.name,
      'isAvailable': true,
      'popolarita': 0,
      'ingredienti': listaIngredienti,
      'immagineUrl': null,
      'timestamp': FieldValue.serverTimestamp(),
    };

    try {
      await FirebaseFirestore.instance.collection('menu').add(nuovoDrink);
      //?print('Drink inviato ok');

      _nomeController.clear();
      _prezzoController.clear();
      _descController.clear();
      _ingredientiController.clear();

      // Opzionale: reset categoria dopo l'invio
      setState(() {});
    } catch (e) {
      print('Errore durante il salvataggio: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Gestionale Lounge Bar")),
      body: Column(
        children: [
          Expanded(
            flex: 1,
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  TextField(
                    controller: _nomeController,
                    decoration: InputDecoration(
                      labelText: "Nome Prodotto (es. Gin Hendrick's)",
                    ),
                  ),
                  TextField(
                    controller: _descController,
                    decoration: InputDecoration(
                      labelText: "Dettagli (es. con Tonica Premium)",
                    ),
                  ),
                  TextField(
                    controller: _ingredientiController,
                    decoration: InputDecoration(
                      labelText: 'Ingredienti(separati da virgola)',
                    ),
                  ),
                  TextField(
                    controller: _prezzoController,
                    decoration: InputDecoration(labelText: "Prezzo"),
                    keyboardType: TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                  ),

                  // 3. MENU A DISCESA PER LE CATEGORIE
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text("Categoria:"),
                    trailing: DropdownButton<Categoria>(
                      value: _categoriaSelezionata,
                      onChanged: (Categoria? nuovoValore) {
                        setState(() {
                          if (nuovoValore != null) {
                            _categoriaSelezionata = nuovoValore;
                          }
                        });
                      },
                      items: Categoria.values.map((Categoria cat) {
                        return DropdownMenuItem<Categoria>(
                          value: cat,
                          child: Text(cat.label),
                        );
                      }).toList(),
                    ),
                  ),

                  SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: _aggiungiDrink,
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size(double.infinity, 45),
                    ),
                    child: Text("Aggiungi al Menu"),
                  ),
                ],
              ),
            ),
          ),

          Divider(thickness: 2),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Text(
              "PRODOTTI ONLINE",
              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey),
            ),
          ),

          //dati da firebase
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('menu')
                  .orderBy('timestamp', descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(child: CircularProgressIndicator());
                }
                return ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    var doc = snapshot.data!.docs[index];
                    var drinkData = doc.data() as Map<String, dynamic>;

                    return ListTile(
                      leading: Icon(Icons.local_bar, color: Colors.amber),
                      title: Text(drinkData['nome']),
                      subtitle: Text(
                        "${drinkData['categoria']} - ${drinkData['descrizione']}",
                      ),
                      trailing: Wrap(
                        spacing: 8, // Spazio tra i due tasti
                        children: [
                          // --- TASTO VISIBILITÀ ---
                          HideButton(drinkData: drinkData, doc: doc),

                          // --- TASTO ELIMINA (Definitivo) ---
                          DeleteButton(drinkData: drinkData, doc: doc),
                        ],
                      ),
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
