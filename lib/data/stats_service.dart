import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:a_dysfagie/models/daily_session.dart';
import 'package:flutter/foundation.dart';

class StatsService {
  static final _prefs = SharedPreferencesAsync();

  /// Uloží celou relaci DailySession
  static Future<void> ulozRelaci(DailySession session) async {
    final list = await _prefs.getStringList('sessions_history') ?? [];
    list.add(jsonEncode(session.toJson()));
    await _prefs.setStringList('sessions_history', list);

    // Aktualizujeme i jednoduchý watchtime pro dnešní den
    final klic = _dnesniKlic();
    final stavajici = await _prefs.getInt(klic) ?? 0;
    await _prefs.setInt(klic, stavajici + session.totalActualWatchtimeSec);
  }

  /// Načte všechny relace pro generování PDF nebo synchronizaci do Firebase
  static Future<List> nactiVsechnyRelace() async {
    try {
      final list = await _prefs.getStringList('sessions_history') ?? [];
      return list
          .map((item) => jsonDecode(item) as Map<String, dynamic>)
          .toList();
    } catch (e) {
      debugPrint('Chyba při načítání relací: $e');
      return [];
    }
  }

  static String _dnesniKlic([DateTime? datum]) {
    final d = datum ?? DateTime.now();
    final mesic = d.month.toString().padLeft(2, '0');
    final den = d.day.toString().padLeft(2, '0');
    return 'watchtime_${d.year}-$mesic-$den';
  }

  static Future<int> ziskejDnesniSekundy() async {
    return await _prefs.getInt(_dnesniKlic()) ?? 0;
  }

  static Future ziskejTydenniStatistiku() async {
    int celkemSekund = 0;
    int aktivniDni = 0;
    final ted = DateTime.now();

    for (int i = 0; i < 7; i++) {
      final den = ted.subtract(Duration(days: i));
      final klic = _dnesniKlic(den);
      final sekundy = await _prefs.getInt(klic) ?? 0;
      celkemSekund += sekundy;
      if (sekundy > 0) aktivniDni++;
    }

    return {
      'celkemSekund': celkemSekund,
      'aktivniDni': aktivniDni,
    };
  }
  /// Vypočítá průměrnou denní a týdenní adherenci (v %) z uložených relací
  static Future ziskejAdherenci() async {
    final relaceList = await nactiVsechnyRelace();

    final ted = DateTime.now();
    final dnesStr = '${ted.year}-${ted.month.toString().padLeft(2, '0')}-${ted.day.toString().padLeft(2, '0')}';
    final dnesPulnoc = DateTime(ted.year, ted.month, ted.day);
    final pondeli = dnesPulnoc.subtract(Duration(days: ted.weekday - 1));
    final nedele = pondeli.add(const Duration(days: 6));
    final tydenPopisek = '${pondeli.day}. ${pondeli.month}. – ${nedele.day}. ${nedele.month}.'; // Formát popisku týdne, např. "9. 11. – 15. 11."

    if (relaceList.isEmpty) {
      return {
        'denniAdherence': 0.0,
        'tydenniAdherence': 0.0,
        'tydenPopisek': tydenPopisek,
      };
    }

    double sumaDnes = 0.0;
    int pocetDnes = 0;

    double sumaTyden = 0.0;
    int pocetTyden = 0;

    for (final json in relaceList) {
      final dateStr = json['date'] as String? ?? '';
      final adherence = (json['overallAdherencePercent'] as num?)?.toDouble() ?? 0.0;
      final datumRelace = DateTime.tryParse(dateStr);

      // 1. Denní adherence (všechny dnešní relace)
      if (dateStr == dnesStr) {
        sumaDnes += adherence;
        pocetDnes++;
      }

      // 2. Týdenní adherence (od pondělí do neděle aktuálního týdne)
      if (datumRelace != null) {
        final datumPulnoc = DateTime(datumRelace.year, datumRelace.month, datumRelace.day);
        if (!datumPulnoc.isBefore(pondeli) && !datumPulnoc.isAfter(nedele)) {
          sumaTyden += adherence;
          pocetTyden++;
        }
      }
    }

    return {
      'denniAdherence': pocetDnes > 0 ? (sumaDnes / pocetDnes) : 0.0,
      'tydenniAdherence': pocetTyden > 0 ? (sumaTyden / pocetTyden) : 0.0,
      'tydenPopisek': tydenPopisek,
    };
  }
}