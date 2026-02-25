import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class DeleteButton extends StatelessWidget {
  const DeleteButton({super.key, required this.drinkData, required this.doc});

  final Map<String, dynamic> drinkData;
  final QueryDocumentSnapshot<Object?> doc;

  @override
  Widget build(BuildContext context) {
    return IconButton(
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
                child: Text("Elimina", style: TextStyle(color: Colors.red)),
              ),
            ],
          ),
        );
      },
      tooltip: "Elimina definitivamente",
    );
  }
}
