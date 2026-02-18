import 'package:cloud_firestore/cloud_firestore.dart';

class Drink {
  final String id;
  final String nome;
  final String descrizione;
  final double prezzo;
  final String categoria;
  final String? immagineUrl;

  Drink({
    required this.id,
    required this.nome,
    required this.descrizione,
    required this.prezzo,
    required this.categoria,
    required this.immagineUrl,
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

    return Drink(
      id: doc.id,
      nome: data['nome'] ?? '',
      descrizione: data['descrizione'],
      categoria: data['categoria'] ?? '',
      prezzo: prezzoFinale,
      immagineUrl: data['immagineUrl'],
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
