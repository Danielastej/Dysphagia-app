import 'package:shared_preferences/shared_preferences.dart';

class StatsService {
  static final _prefs = SharedPreferencesAsync();

  // Vrátí klíč pro dnešní den, např. 'watchtime_2026-10-12'
  static String _dnesniKlic([DateTime? datum]) {
    final d = datum ?? DateTime.now();
    final mesic = d.month.toString().padLeft(2, '0');
    final den = d.day.toString().padLeft(2, '0');
    return 'watchtime_${d.year}-$mesic-$den';
  }

  /// Přičte zhlédnuté sekundy k dnešnímu dni
  static Future<void> pridejSekundy(int sekundy) async {
    if (sekundy <= 0) return;
    final klic = _dnesniKlic();
    final stavajici = await _prefs.getInt(klic) ?? 0;
    await _prefs.setInt(klic, stavajici + sekundy);
  }

  /// Vrátí počet sekund odcvičených dnes
  static Future<int> ziskejDnesniSekundy() async {
    return await _prefs.getInt(_dnesniKlic()) ?? 0;
  }

  /// Vrátí počet sekund za posledních 7 dní a počet aktivních dní v týdnu
  static Future<Map<String, dynamic>> ziskejTydenniStatistiku() async {
    int celkemSekund = 0;
    int aktivniDny = 0;
    final ted = DateTime.now();

    for (int i = 0; i < 7; i++) {
      final den = ted.subtract(Duration(days: i));
      final klic = _dnesniKlic(den);
      final sekundy = await _prefs.getInt(klic) ?? 0;
      celkemSekund += sekundy;
      if (sekundy > 0) {
        aktivniDny++;
      }
    }

    return {
      'celkemSekund': celkemSekund,
      'aktivniDni': aktivniDny, // kolikrát za týden pacient cvičil
    };
  }
}