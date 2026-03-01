import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lounge_menu_nfc/screens/admin/section/delete_button.dart';
import 'package:lounge_menu_nfc/screens/admin/section/hide_button.dart';

class AddBottle extends StatefulWidget {
  const AddBottle({super.key});

  @override
  _AddBottleState createState() => _AddBottleState();
}

class _AddBottleState extends State<AddBottle> {
  final TextEditingController _nomeController = TextEditingController();
  final TextEditingController _sovrapprezzoController = TextEditingController();
  
  // Lista delle categorie per la bottiglieria
  final List<String> _categorieBottiglieria = [
    'Gin', 'Rum', 'Vodka', 'Tequila', 'Whisky', 'Mezcal', 'Amari'
  ];
  String _categoriaSelezionata = 'Gin'; // Valore di default

  void _aggiungiBottiglia() async {
    if (_nomeController.text.isEmpty || _sovrapprezzoController.text.isEmpty) return;

    double priceDouble = double.tryParse(_sovrapprezzoController.text.replaceAll(',', '.')) ?? 0.0;

    // Struttura dati allineata alla classe Bottle creata prima
    Map<String, dynamic> nuovaBottiglia = {
      'nome': _nomeController.text,
      'categoria': _categoriaSelezionata,
      'sovrapprezzo': priceDouble,
      'disponibile': true, // Di default quando la inserisci è disponibile
      'timestamp': FieldValue.serverTimestamp(),
    };

    try {
      // Salviamo nella NUOVA collezione
      await FirebaseFirestore.instance.collection('bottiglieria').add(nuovaBottiglia);

      // Pulizia dei campi dopo l'inserimento
      _nomeController.clear();
      _sovrapprezzoController.clear();
      
      // Ricarichiamo la UI per sicurezza (opzionale)
      setState(() {});
    } catch (e) {
      print('Errore durante il salvataggio: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Gestione Bottiglieria")),
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
                    decoration: const InputDecoration(
                      labelText: "Nome Bottiglia (es. Monkey 47)",
                    ),
                  ),
                  TextField(
                    controller: _sovrapprezzoController,
                    decoration: const InputDecoration(
                      labelText: "Sovrapprezzo (es. 5.00)",
                    ),
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  ),

                  // MENU A DISCESA PER LE CATEGORIE DELLA BOTTIGLIERIA
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: const Text("Categoria Alcolico:"),
                    trailing: DropdownButton<String>(
                      value: _categoriaSelezionata,
                      onChanged: (String? nuovoValore) {
                        if (nuovoValore != null) {
                          setState(() {
                            _categoriaSelezionata = nuovoValore;
                          });
                        }
                      },
                      items: _categorieBottiglieria.map((String cat) {
                        return DropdownMenuItem<String>(
                          value: cat,
                          child: Text(cat),
                        );
                      }).toList(),
                    ),
                  ),

                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: _aggiungiBottiglia,
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 45),
                    ),
                    child: const Text("Aggiungi Bottiglia al Magazzino"),
                  ),
                ],
              ),
            ),
          ),

          const Divider(thickness: 2),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 8.0),
            child: Text(
              "MAGAZZINO ATTUALE",
              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey),
            ),
          ),

          // DATI DA FIREBASE (Lettura dalla collezione bottiglieria)
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('bottiglieria')
                  .orderBy('categoria') // Ordinato per categoria per pulizia visiva
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }
                return ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    var doc = snapshot.data!.docs[index];
                    var bottigliaData = doc.data() as Map<String, dynamic>;

                    return ListTile(
                      leading: const Icon(Icons.liquor, color: Colors.amber),
                      title: Text(bottigliaData['nome'] ?? 'Sconosciuto'),
                      subtitle: Text(
                        "Categoria: ${bottigliaData['categoria'] ?? ''} | Sovrapprezzo: €${(bottigliaData['sovrapprezzo'] ?? 0).toStringAsFixed(2)}",
                      ),
                      trailing: Wrap(
                        spacing: 8,
                        children: [
                          // ATTENZIONE QUI: Verifica i tuoi file HideButton e DeleteButton
                          HideButton(drinkData: bottigliaData, doc: doc),
                          DeleteButton(drinkData: bottigliaData, doc: doc),
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