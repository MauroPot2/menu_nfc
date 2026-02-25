import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class HideButton extends StatelessWidget {
  const HideButton({
    super.key,
    required this.drinkData,
    required this.doc,
  });

  final Map<String, dynamic> drinkData;
  final QueryDocumentSnapshot<Object?> doc;

  @override
  Widget build(BuildContext context) {
    return IconButton(
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
    );
  }
}
