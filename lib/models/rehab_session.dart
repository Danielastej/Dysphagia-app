class ExerciseLog {
  final String cvikNazev;
  final int targetDurationSec;   // Předepsaná délka videa
  final int actualWatchtimeSec;  // Reálně odehraný čas videa
  final int totalScreenTimeSec;  // Celkový čas strávený na obrazovce
  final int seekForwardCount;    // Počet přetočení dopředu
  final int seekBackwardCount;   // Počet přetočení dozadu
  final bool completedNaturally; // Dojel až na konec bez přeskoku

  ExerciseLog({
    required this.cvikNazev,
    required this.targetDurationSec,
    required this.actualWatchtimeSec,
    required this.totalScreenTimeSec,
    this.seekForwardCount = 0,
    this.seekBackwardCount = 0,
    required this.completedNaturally,
  });

  /// Klasifikace cviku podle validačního algoritmu
  ExerciseStatus get status {
    // 1. Prokliknuto moc rychle (pod 30 % stopáže)
    if (actualWatchtimeSec < (targetDurationSec * 0.30)) {
      return ExerciseStatus.skipped;
    }
    // 2. Částečně odcvičeno (mezi 30 % a 75 %)
    if (actualWatchtimeSec < (targetDurationSec * 0.75)) {
      return ExerciseStatus.partiallyCompleted;
    }
    // 3. Validně odcvičeno
    return ExerciseStatus.validCompleted;
  }

  /// Efektivní čas započitatelný do adherence (odfiltrování idle ghostingu a přetočení)
  int get validWatchtimeSec {
    return actualWatchtimeSec.clamp(0, targetDurationSec);
  }

  Map<String, dynamic> toJson() => {
    'cvikNazev': cvikNazev,
    'targetDurationSec': targetDurationSec,
    'actualWatchtimeSec': actualWatchtimeSec,
    'totalScreenTimeSec': totalScreenTimeSec,
    'seekForwardCount': seekForwardCount,
    'seekBackwardCount': seekBackwardCount,
    'status': status.name,
  };
}

enum ExerciseStatus { skipped, partiallyCompleted, validCompleted }

class DailySession {
  final DateTime date;
  final List<ExerciseLog> exercises;

  DailySession({required this.date, required this.exercises});

  double get completionRate {
    if (exercises.isEmpty) return 0.0;
    final validCount = exercises.where((e) => e.status == ExerciseStatus.validCompleted).length;
    return validCount / exercises.length;
  }

  double get adherenceIndex {
    if (exercises.isEmpty) return 0.0;
    final totalTarget = exercises.fold(0, (sum, e) => sum + e.targetDurationSec);
    final totalValidWatch = exercises.fold(0, (sum, e) => sum + e.validWatchtimeSec);
    if (totalTarget == 0) return 0.0;
    return (totalValidWatch / totalTarget).clamp(0.0, 1.0);
  }
}