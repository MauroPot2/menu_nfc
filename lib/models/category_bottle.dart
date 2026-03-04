import 'package:cloud_firestore/cloud_firestore.dart';

class CategoryBottle {
  final String id;
  final String nome;

  CategoryBottle({required this.id, required this.nome});

  factory CategoryBottle.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

    return CategoryBottle(
      id: doc.id,
      nome: data['nome'] ?? 'Categoria Sconosciuta',
    );
  }
}
