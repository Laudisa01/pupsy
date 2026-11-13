# Pupsy 💨

Die Community-Web-App für den guten Ton: Fürze hochladen, per Swipe bewerten, Duelle mit Elo-Wertung, ein Wochenturnier, Daily Challenges, Bestenlisten (Tag, Woche, Monat, Allzeit und nach Essen) und Abzeichen.

**Live:** https://laudisa01.github.io/pupsy/

## So funktioniert's

- **Aufnehmen:** Auf dem Handy ein kurzes Video oder eine Sprachmemo aufnehmen und hochladen. Pupsy nutzt nur den Ton (max. 15 s), schneidet Stille ab und misst Dauer, Wumms-Score und Kategorie. Alternativ gibt es den 🎲-Zufalls-Generator.
- **Entdecken:** Rechts = Like, links = Nö, hoch = Super-Pups (5 pro Tag).
- **Duelle & Turnier:** Elo-Wertung; jeden Montag treten die besten Fürze im K.-o.-System an.
- **Moderation:** Ab 3 Meldungen wird ein Pups ausgeblendet; Blockieren blendet eine Person aus.

## Backend einrichten (Supabase)

Ohne Zugangsdaten läuft die Seite im Vorschau-Modus (alles nur lokal im Browser).

1. Kostenloses Projekt auf [supabase.com](https://supabase.com) anlegen.
2. Im **SQL Editor** den Inhalt von [`supabase.sql`](supabase.sql) ausführen.
3. **Authentication → URL Configuration:** als *Site URL* `https://laudisa01.github.io/pupsy/` eintragen.
4. **Authentication → Email Templates → Magic Link:** `{{ .Token }}` in den Text aufnehmen, damit ein Code mitgeschickt wird (der Link funktioniert auch so).
5. **Project Settings → API:** URL und `anon public` Key in [`config.js`](config.js) eintragen und pushen.

## Dateien

| Datei | Inhalt |
|---|---|
| `index.html` | Die komplette App (HTML, CSS, JavaScript) |
| `config.js` | Supabase-URL und anon key |
| `supabase.sql` | Tabellen und Zugriffsregeln |
