import 'package:cloud_firestore/cloud_firestore.dart';

class Drink {
  final String id;
  final String nome;
  final String descrizione;
  final double prezzo;
  final String categoria;
  final String? immagineUrl;
  final bool isAvailable;
  final int popolarita;
  final List<String> ingredienti;

  Drink({
    required this.id,
    required this.nome,
    required this.descrizione,
    required this.prezzo,
    required this.categoria,
    required this.immagineUrl,
    this.isAvailable = true,
    this.popolarita = 0,
    this.ingredienti = const [],
  });

  factory Drink.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

    double prezzoFinale = 0.0;
    var rawPrezzo = data['prezzo'];

    if (rawPrezzo is num) {
      prezzoFinale = rawPrezzo.toDouble();
    } else if (rawPrezzo is String) {
      String pulito = rawPrezzo
          .replaceAll('€', '')
          .replaceAll('\$', '')
          .replaceAll(',', '.')
          .trim();
      prezzoFinale = double.tryParse(pulito) ?? 0.0;
    }
    // ------------------------------------

    List<String> listaIngredienti = [];
    if (data['ingredienti'] is List) {
      listaIngredienti = List<String>.from(data['ingredienti']);
    }

    // ------------------------------------
    return Drink(
      id: doc.id,
      nome: data['nome'] ?? '',
      descrizione: data['descrizione'],
      categoria: data['categoria'] ?? '',
      prezzo: prezzoFinale,
      immagineUrl: data['immagineUrl'],
      isAvailable: data['isAvailable'] ?? true,
      popolarita: data['popolarita'] ?? 0,
      ingredienti: listaIngredienti,
    );
  }

  static Future<void> incrementaPopolarita(String drinkId) async {
    try {
      await FirebaseFirestore.instance.collection('menu').doc(drinkId).update({
        'popolarita': FieldValue.increment(1),
      });
    } catch (e) {
      print('Errore durante l\'incremento: $e');
    }
  }
}
