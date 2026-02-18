import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../models/categoria.dart';

class AdminPanel extends StatefulWidget {
  @override
  _AdminPanelState createState() => _AdminPanelState();
}

class _AdminPanelState extends State<AdminPanel> {
  final TextEditingController _nomeController = TextEditingController();
  final TextEditingController _prezzoController = TextEditingController();
  final TextEditingController _descController = TextEditingController();

  // default cocktail
  Categoria _categoriaSelezionata = Categoria.cocktail;

  void _aggiungiDrink() async {
    if (_nomeController.text.isEmpty || _prezzoController.text.isEmpty) return;

    Map<String, dynamic> nuovoDrink = {
      'nome': _nomeController.text,
      'descrizione': _descController.text,
      'prezzo': "${_prezzoController.text}€",
      'categoria': _categoriaSelezionata.name,
      'isAvailable': true,
      'timestamp': FieldValue.serverTimestamp(),
    };

    try {
      await FirebaseFirestore.instance.collection('menu').add(nuovoDrink);
      //?print('Drink inviato ok');

      _nomeController.clear();
      _prezzoController.clear();
      _descController.clear();

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
          Padding(
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
                  controller: _prezzoController,
                  decoration: InputDecoration(
                    labelText: "Prezzo",
                  ),
                  keyboardType: TextInputType.number,
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
                        child: Text(
                          cat.label,
                        ),
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
                          IconButton(
                            icon: Icon(
                              // Se isAvailable è false, mostra l'occhio sbarrato grigio
                              drinkData['isAvailable'] == false
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                              color: drinkData['isAvailable'] == false
                                  ? Colors.grey
                                  : Colors.blue,
                            ),
                            onPressed: () {
                              // Invertiamo lo stato: se è null o true diventa false, e viceversa
                              bool statoAttuale =
                                  drinkData['isAvailable'] ?? true;
                              doc.reference.update({
                                'isAvailable': !statoAttuale,
                              });
                            },
                            tooltip: "Nascondi/Mostra nel menu",
                          ),

                          // --- TASTO ELIMINA (Definitivo) ---
                          IconButton(
                            icon: Icon(Icons.delete_outline, color: Colors.red),
                            onPressed: () {
                              // Chiediamo conferma prima di eliminare per sempre
                              showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: Text("Elimina prodotto?"),
                                  content: Text(
                                    "Sei sicuro di voler eliminare ${drinkData['nome']}?",
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Navigator.pop(context),
                                      child: Text("Annulla"),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        doc.reference.delete();
                                        Navigator.pop(context);
                                      },
                                      child: Text(
                                        "Elimina",
                                        style: TextStyle(color: Colors.red),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                            tooltip: "Elimina definitivamente",
                          ),
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
