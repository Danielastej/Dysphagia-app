enum AdherenceStatus {
  validCompleted,      // Poctivě odcvičeno (např. >= 75 % délky)
  partiallyCompleted,  // Částečně odcvičeno (35 % až 75 % délky)
  skipped,             // Prokliknuto nebo přeskočeno (< 35 % délky)
  idleDetected,        // Detekována dlouhá nečinnost
}

class SeekEvent {
  final int fromSec;  // Odkud skočil
  final int toSec;    // Kam skočil
  final int diffSec;  // Rozdíl (+25 s dopředu, nebo -10 s zpět)

  SeekEvent({
    required this.fromSec,
    required this.toSec,
    required this.diffSec,
  });

  Map<String, dynamic> toJson() => {
    'fromSec': fromSec,
    'toSec': toSec,
    'diffSec': diffSec,
  };
}
class ExerciseTelemetry {
  final String exerciseName;
  final int targetDurationSec;     // Délka videa v sekundách
  final int actualWatchtimeSec;    // Čas, kdy video skutečně běželo (Play)
  final int screenTimeSec;         // Celkový čas otevřené obrazovky
  final int seekForwardCount;      // Kolikrát posunul dopředu - POSUN SE POČÍTÁ JEN KDYŽ JE DELŠÍ NEŽ 2 SEKUNDY
  final int seekBackwardCount;     // Kolikrát vrátil zpět
  final int replayCount;           // Kolikrát pustil znovu po dojetí na konec
  final int seekForwardTotalSec;
  final int seekBackwardTotalSec;
  final List<SeekEvent> seekEvents;

  ExerciseTelemetry({
    required this.exerciseName,
    required this.targetDurationSec,
    required this.actualWatchtimeSec,
    required this.screenTimeSec,
    required this.seekForwardCount,
    required this.seekBackwardCount,
    required this.replayCount,
    required this.seekForwardTotalSec,
    required this.seekBackwardTotalSec,
    required this.seekEvents,
  });

  /// 1. Ošetření nečinnosti (ořezání na max 1.5 násobek cíle)
  int get sanitizedScreenTimeSec {
    final maxAllowed = (targetDurationSec * 1.5).round();
    return screenTimeSec > maxAllowed ? maxAllowed : screenTimeSec;
  }

  /// 2. Započitatelný čas do adherence (stropován na 100 % délky videa)
  int get creditedWatchtimeSec {
    return actualWatchtimeSec.clamp(0, targetDurationSec);
  }

  /// 3. Procento splnění tohoto konkrétního cviku (0.0 až 1.0)
  double get adherenceRatio {
    if (targetDurationSec <= 0) return 0.0;
    return creditedWatchtimeSec / targetDurationSec;
  }

  /// 4. Klasifikace stavu podle přísných klinických kritérií
  AdherenceStatus get status {
    // Pokud byl na obrazovce více než trojnásobek času videa
    if (screenTimeSec > targetDurationSec * 3 && actualWatchtimeSec < targetDurationSec * 0.5) {
      return AdherenceStatus.idleDetected;
    }
    // Prokliknutí pod 35 %
    if (adherenceRatio < 0.35) {
      return AdherenceStatus.skipped;
    }
    // Částečné splnění
    if (adherenceRatio < 0.75) {
      return AdherenceStatus.partiallyCompleted;
    }
    // Plně odcvičeno
    return AdherenceStatus.validCompleted;
  }

  Map<String, dynamic> toJson() => {
    'exerciseName': exerciseName,
    'targetDurationSec': targetDurationSec,
    'actualWatchtimeSec': actualWatchtimeSec,
    'screenTimeSec': screenTimeSec,
    'sanitizedScreenTimeSec': sanitizedScreenTimeSec,
    'seekForwardCount': seekForwardCount,
    'seekBackwardCount': seekBackwardCount,
    'replayCount': replayCount,
    'adherenceRatio': (adherenceRatio * 100).toStringAsFixed(1),
    'status': status.name,
  };
}