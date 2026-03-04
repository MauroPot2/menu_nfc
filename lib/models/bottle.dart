import 'package:cloud_firestore/cloud_firestore.dart';

class Bottle {
  final String id;
  final String nome;
  final String idCategoria;
  final double sovrapprezzo;
  final bool isAvailable;

  Bottle({
    required this.id,
    required this.nome,
    required this.idCategoria,
    required this.sovrapprezzo,
    required this.isAvailable,
  });

  factory Bottle.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

    return Bottle(
      id: doc.id,
      nome: data['nome'] ?? 'Unknow Item',
      idCategoria: data['idCategoria'] ?? 'Generic',
      sovrapprezzo: (data['sovrapprezzo'] ?? 0).toDouble(),
      isAvailable: data['isAvailable'] ?? false,
    );
  }
}
