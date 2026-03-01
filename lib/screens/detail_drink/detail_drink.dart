import 'package:flutter/material.dart';
import 'package:lounge_menu_nfc/models/drink.dart';

class DetailDrink extends StatefulWidget {
  const DetailDrink({super.key, required this.drink});

  final Drink drink;

  @override
  State<DetailDrink> createState() => _DetailDrinkState();
}

class _DetailDrinkState extends State<DetailDrink> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 300,
            flexibleSpace: FlexibleSpaceBar(
              background:
                  widget.drink.immagineUrl != null &&
                      widget.drink.immagineUrl!.isNotEmpty
                  ? Image.network(widget.drink.immagineUrl!, fit: BoxFit.cover)
                  : Center(
                      child: Icon(
                        Icons.local_bar_sharp,
                        size: 100,
                        color: Colors.grey.shade400,
                      ),
                    ),
            ),

            //?
          ),
          SliverToBoxAdapter(child: Card(child: Text(widget.drink.nome))),
          SliverToBoxAdapter(
            child: Card(child: Text(widget.drink.descrizione)),
          ),
        ],
      ),
    );
  }
}
