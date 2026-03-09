import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class SettingBanner extends StatefulWidget {
  const SettingBanner({super.key});

  @override
  State<SettingBanner> createState() => _SettingBannerState();
}

class _SettingBannerState extends State<SettingBanner> {
  // Controller per i testi
  final TextEditingController _bannerTextController = TextEditingController();
  final TextEditingController _tickerTextController = TextEditingController();

  // Variabili di stato per gli interruttori
  bool _isBannerActive = false;
  bool _isTickerActive = false;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _caricaImpostazioniAttuali();
  }

  @override
  void dispose() {
    _bannerTextController.dispose();
    _tickerTextController.dispose();
    super.dispose();
  }

  // Legge il documento da Firebase all'apertura della pagina
  Future<void> _caricaImpostazioniAttuali() async {
    try {
      DocumentSnapshot doc = await FirebaseFirestore.instance
          .collection('impostazioni')
          .doc('banner_home')
          .get();

      if (doc.exists) {
        var data = doc.data() as Map<String, dynamic>;
        setState(() {
          _isBannerActive = data['banner_attivo'] ?? false;
          _bannerTextController.text = data['banner_testo'] ?? '';
          _isTickerActive = data['ticker_attivo'] ?? false;
          _tickerTextController.text = data['ticker_testo'] ?? '';
        });
      }
    } catch (e) {
      print("Errore nel caricamento impostazioni: $e");
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  // Salva le modifiche su Firebase
  Future<void> _salvaImpostazioni() async {
    try {
      await FirebaseFirestore.instance
          .collection('impostazioni')
          .doc('banner_home')
          .set({
        'banner_attivo': _isBannerActive,
        'banner_testo': _bannerTextController.text,
        'ticker_attivo': _isTickerActive,
        'ticker_testo': _tickerTextController.text,
      }, SetOptions(merge: true)); // merge: true crea il doc se non esiste

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('✅ Banner aggiornati con successo!'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      print("Errore nel salvataggio: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Gestione Promozioni"),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _salvaImpostazioni,
            tooltip: "Salva Modifiche",
          )
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          // SEZIONE 1: BANNER PRINCIPALE (Fisso)
          const Text(
            "Banner Statico (Offerte)",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.amber),
          ),
          const SizedBox(height: 10),
          Card(
            color: Colors.grey.shade900,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  SwitchListTile(
                    title: const Text("Mostra Banner in Home"),
                    subtitle: const Text("Accende o spegne l'offerta principale"),
                    activeColor: Colors.amber,
                    value: _isBannerActive,
                    onChanged: (bool value) {
                      setState(() {
                        _isBannerActive = value;
                      });
                    },
                  ),
                  if (_isBannerActive) ...[
                    const Divider(),
                    TextField(
                      controller: _bannerTextController,
                      decoration: const InputDecoration(
                        labelText: "Testo del Banner",
                        hintText: "Es: 20% di sconto sui cocktail stasera!",
                        border: OutlineInputBorder(),
                      ),
                      maxLines: 2,
                    ),
                  ]
                ],
              ),
            ),
          ),

          const SizedBox(height: 30),

          // SEZIONE 2: TICKER SCORREVOLE (Effetto SkySport24)
          const Text(
            "Ticker Scorrevole (News)",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.amber),
          ),
          const SizedBox(height: 10),
          Card(
            color: Colors.grey.shade900,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  SwitchListTile(
                    title: const Text("Mostra Testo Scorrevole"),
                    subtitle: const Text("News continue in fondo o in cima allo schermo"),
                    activeColor: Colors.amber,
                    value: _isTickerActive,
                    onChanged: (bool value) {
                      setState(() {
                        _isTickerActive = value;
                      });
                    },
                  ),
                  if (_isTickerActive) ...[
                    const Divider(),
                    TextField(
                      controller: _tickerTextController,
                      decoration: const InputDecoration(
                        labelText: "Testo della News",
                        hintText: "Es: Venerdì serata speciale... Prenotazioni aperte...",
                        border: OutlineInputBorder(),
                      ),
                      maxLines: 3,
                    ),
                  ]
                ],
              ),
            ),
          ),

          const SizedBox(height: 30),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 15),
              backgroundColor: Colors.amber.shade700,
              foregroundColor: Colors.black,
            ),
            onPressed: _salvaImpostazioni,
            child: const Text("SALVA E PUBBLICA", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          ),
        ],
      ),
    );
  }
}