# Lounge Menu NFC

Progetto Flutter per un menu digitale consultabile dai clienti, con contenuti e prezzi gestiti tramite Firebase. Il nome richiama l'uso tramite tag NFC, ma la gestione diretta dei tag non è documentata come funzionalità implementata nel codice attuale.

## Funzionalità

- Visualizzazione di categorie e prodotti del menu
- Dettaglio dei drink e delle varianti
- Sezione amministrativa per gestire il catalogo
- Gestione di contenuti visivi, fra cui immagini, video e banner

## Stack e struttura

Flutter, Dart, Firebase Authentication e Cloud Firestore. Fra le dipendenze figurano inoltre `video_player`, `marquee` e `google_fonts`.

- `lib/screens/homepage/`: consultazione pubblica
- `lib/screens/details_category/`, `detail_drink/`: pagine di dettaglio
- `lib/screens/admin/`: gestione dei contenuti
- `lib/models/`: modelli applicativi
- `assets/`: immagini e video

## Avvio locale

Configurare un progetto Firebase e controllare le impostazioni utilizzate dall'app in `lib/utility/firebase_options_manual.dart`.

~~~bash
flutter pub get
flutter run
~~~

## Stato del progetto

Applicazione in sviluppo. Nel README precedente erano annotati come lavori aperti il perfezionamento del dettaglio prodotto, un banner eventi gestibile dall'amministrazione e l'ordinamento delle categorie per popolarità. Queste attività restano da verificare nel codice prima di essere considerate completate.

Le regole Firebase e l'accesso amministrativo devono essere controllati prima della pubblicazione.
