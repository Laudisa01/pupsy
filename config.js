// Supabase-Zugangsdaten (Dashboard → Project Settings → API).
// Der "anon public" Key ist für den Browser gedacht und darf öffentlich sein;
// die Zugriffsregeln (RLS) in supabase.sql schützen die Daten.
// Solange beide Felder leer sind, läuft Pupsy im Vorschau-Modus.
window.PUPSY_CONFIG = {
  supabaseUrl: "",
  supabaseAnonKey: "",
};
