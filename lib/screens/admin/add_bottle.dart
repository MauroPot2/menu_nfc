import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lounge_menu_nfc/screens/admin/section/delete_button.dart';
import 'package:lounge_menu_nfc/screens/admin/section/hide_button.dart';

class AddBottle extends StatefulWidget {
  const AddBottle({super.key});

  @override
  AddBottleState createState() => AddBottleState();
}

class AddBottleState extends State<AddBottle> {
  final TextEditingController _nomeController = TextEditingController();
  final TextEditingController _sovrapprezzoController = TextEditingController();
  final TextEditingController _nuovaCategoriaController =
      TextEditingController();

  String? _categoriaSelezionata;

  // AGGIUNTO: Metodo per liberare la memoria dei controller
  @override
  void dispose() {
    _nomeController.dispose();
    _sovrapprezzoController.dispose();
    _nuovaCategoriaController.dispose();
    super.dispose();
  }

  void _popolaCategorieIniziali() async {
    // 1. La tua lista di categorie base
    List<String> categorieIniziali = [
      "Gin",
      "Rum",
      "Vodka",
      "Tequila",
      "Whisky",
      "Cognac & Brandy",
      "Amari",
      "Liquori Dolci",
      "Vermouth",
      "Bollicine",
      "Champagne",
      "Vini Bianchi",
      "Vini Rossi",
      "Birre Artigianali",
      "Soft Drinks",
      "Toniche Premium",
    ];

    FirebaseFirestore db = FirebaseFirestore.instance;

    // 2. Creiamo un "Batch" (un pacchetto di operazioni)
    WriteBatch batch = db.batch();

    // 3. Prepariamo un documento per ogni categoria
    for (String categoria in categorieIniziali) {
      // Usiamo il nome esatto come ID del documento per evitare duplicati
      DocumentReference docRef = db
          .collection('categoria_bottiglieria')
          .doc(categoria);
      batch.set(docRef, {'categoria': categoria});
    }

    // 4. Inviamo tutto a Firebase in un colpo solo!
    try {
      await batch.commit();

      // Mostriamo un avviso a schermo quando ha finito
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('✅ Tutte le categorie caricate con successo!'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      debugPrint("❌ Errore durante il caricamento massivo: $e");
    }
  }

  void _aggiungiBottiglia() async {
    if (_nomeController.text.isEmpty || _sovrapprezzoController.text.isEmpty) {
      return;
    }

    double priceDouble =
        double.tryParse(_sovrapprezzoController.text.replaceAll(',', '.')) ??
        0.0;

    Map<String, dynamic> nuovaBottiglia = {
      'nome': _nomeController.text,
      'categoria': _categoriaSelezionata,
      'sovrapprezzo': priceDouble,
      'disponibile': true,
      'timestamp': FieldValue.serverTimestamp(),
    };

    try {
      await FirebaseFirestore.instance
          .collection('bottiglieria')
          .add(nuovaBottiglia);

      _nomeController.clear();
      _sovrapprezzoController.clear();
      // RIMOSSO: setState(() {}); non è più necessario
    } catch (e) {
      debugPrint('Errore durante il salvataggio: $e');
    }
  }

  Future<void> _mostraDialogNuovaCategoria(BuildContext context) async {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Nuova Categoria'),
          content: TextField(
            controller: _nuovaCategoriaController,
            decoration: const InputDecoration(
              hintText: "Es. Gin, Rum, Vodka...",
            ),
            autofocus: true,
          ),
          actions: [
            TextButton(
              child: const Text('Annulla'),
              onPressed: () {
                _nuovaCategoriaController.clear();
                Navigator.pop(context);
              },
            ),
            ElevatedButton(
              child: const Text('Aggiungi'),
              onPressed: () async {
                if (_nuovaCategoriaController.text.trim().isNotEmpty) {
                  String nuovaCat = _nuovaCategoriaController.text.trim();

                  // Salva nella collezione dedicata alle categorie
                  await FirebaseFirestore.instance
                      .collection('categoria_bottiglieria')
                      .doc(nuovaCat)
                      .set({'categoria': nuovaCat});

                  setState(() {
                    _categoriaSelezionata = nuovaCat;
                  });

                  _nuovaCategoriaController.clear();
                  if (context.mounted) {
                    Navigator.pop(context);
                  }
                }
              },
            ),
          ],
        );
      },
    );
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
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                  ),
                  const SizedBox(height: 10),

                  StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('categoria_bottiglieria')
                        .orderBy('categoria')
                        .snapshots(),
                    builder: (context, asyncSnapshot) {
                      if (asyncSnapshot.connectionState ==
                          ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      if (asyncSnapshot.hasError) {
                        return const Text("Errore nel caricamento categorie");
                      }
                      if (!asyncSnapshot.hasData ||
                          asyncSnapshot.data!.docs.isEmpty) {
                        return const Text("Nessuna categoria trovata");
                      }

                      // Ora asyncSnapshot esiste ed è pieno di dati
                      List<String> categoryBottleList = asyncSnapshot.data!.docs
                          .map((doc) {
                            return doc['categoria'].toString();
                          })
                          .toSet()
                          .toList(); // toSet().toList() rimuove i duplicati in automatico!

                      return ListTile(
                        contentPadding: EdgeInsets.zero,
                        title: const Text("Categoria Alcolico:"),
                        trailing: Row(
                          mainAxisSize: .min,
                          children: [
                            DropdownButton<String>(
                              value:
                                  categoryBottleList.contains(
                                    _categoriaSelezionata,
                                  )
                                  ? _categoriaSelezionata
                                  : null, // Evita errori se la categoria selezionata scompare
                              hint: const Text("Seleziona"),
                              onChanged: (String? nuovoValore) {
                                if (nuovoValore != null) {
                                  setState(() {
                                    _categoriaSelezionata = nuovoValore;
                                  });
                                }
                              },
                              items: categoryBottleList.map((String cat) {
                                return DropdownMenuItem<String>(
                                  value: cat,
                                  child: Text(cat),
                                );
                              }).toList(),
                            ),
                            IconButton(
                              icon: const Icon(
                                Icons.add_circle,
                                color: Colors.blue,
                              ),
                              onPressed: () =>
                                  _mostraDialogNuovaCategoria(context),
                              tooltip: "Aggiungi nuova categoria",
                            ),
                          ],
                        ),
                      );
                    },
                  ),

                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: _aggiungiBottiglia,
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 45),
                    ),
                    child: const Text("Aggiungi Bottiglia al Magazzino"),
                  ),
                  SizedBox(height: 3),
                  ElevatedButton(
                    onPressed: _popolaCategorieIniziali,
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 45),
                    ),
                    child: const Text("Popola Magazzino"),
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
                  .orderBy(
                    'categoria',
                  ) // Ordinato per categoria per pulizia visiva
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
