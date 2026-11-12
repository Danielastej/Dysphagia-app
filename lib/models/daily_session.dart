import 'package:a_dysfagie/models/exercise_telemetry.dart';

class DailySession {
  final String sessionId;
  final String patientId;
  final String date; // YYYY-MM-DD
  final DateTime startTime;
  final DateTime endTime;
  final int totalPrescribedExercises;
  final int completedExercisesCount;
  final int validExercisesCount;
  final int totalTargetDurationSec;
  final int totalActualWatchtimeSec;
  final double overallAdherencePercent;
  final bool isSyncedToFirebase;
  final List<ExerciseTelemetry> exercises;

  DailySession({
    required this.sessionId,
    required this.patientId,
    required this.date,
    required this.startTime,
    required this.endTime,
    required this.totalPrescribedExercises,
    required this.completedExercisesCount,
    required this.validExercisesCount,
    required this.totalTargetDurationSec,
    required this.totalActualWatchtimeSec,
    required this.overallAdherencePercent,
    this.isSyncedToFirebase = false,
    required this.exercises,
  });

  /// Tovární konstruktor, který spočítá metriky ze seznamu dokončených cviků
  factory DailySession.fromExercises({
    required String patientId,
    required DateTime startTime,
    required DateTime endTime,
    required int totalPrescribed,
    required List<ExerciseTelemetry> exercises,
  }) {
    final now = DateTime.now();
    final mesic = now.month.toString().padLeft(2, '0');
    final den = now.day.toString().padLeft(2, '0');
    final dateStr = '${now.year}-$mesic-$den';
    final sessionId = 'session_${now.millisecondsSinceEpoch}';

    int totalTarget = 0;
    int totalWatch = 0;
    int validCount = 0;

    for (final ex in exercises) {
      totalTarget += ex.targetDurationSec;
      totalWatch += ex.creditedWatchtimeSec;
      if (ex.status == AdherenceStatus.validCompleted) {
        validCount++;
      }
    }

    // Výpočet adherence: 60 % váha dokončení počtu cviků, 40 % váha reálného času
    double countRatio = totalPrescribed > 0 ? (validCount / totalPrescribed) : 0.0;
    double timeRatio = totalTarget > 0 ? (totalWatch / totalTarget) : 0.0;
    double adherence = ((0.6 * countRatio) + (0.4 * timeRatio)) * 100.0;

    return DailySession(
      sessionId: sessionId,
      patientId: patientId,
      date: dateStr,
      startTime: startTime,
      endTime: endTime,
      totalPrescribedExercises: totalPrescribed,
      completedExercisesCount: exercises.length,
      validExercisesCount: validCount,
      totalTargetDurationSec: totalTarget,
      totalActualWatchtimeSec: totalWatch,
      overallAdherencePercent: adherence.clamp(0.0, 100.0),
      isSyncedToFirebase: false,
      exercises: exercises,
    );
  }

  Map<String, dynamic> toJson() => {
    'sessionId': sessionId,
    'patientId': patientId,
    'date': date,
    'startTime': startTime.toIso8601String(),
    'endTime': endTime.toIso8601String(),
    'totalPrescribedExercises': totalPrescribedExercises,
    'completedExercisesCount': completedExercisesCount,
    'validExercisesCount': validExercisesCount,
    'totalTargetDurationSec': totalTargetDurationSec,
    'totalActualWatchtimeSec': totalActualWatchtimeSec,
    'overallAdherencePercent': double.parse(overallAdherencePercent.toStringAsFixed(1)),
    'isSyncedToFirebase': isSyncedToFirebase,
    'exercises': exercises.map((e) => e.toJson()).toList(),
  };

  factory DailySession.fromJson(Map<String, dynamic> json) {
    return DailySession(
      sessionId: json['sessionId'] as String,
      patientId: json['patientId'] as String,
      date: json['date'] as String,
      startTime: DateTime.parse(json['startTime'] as String),
      endTime: DateTime.parse(json['endTime'] as String),
      totalPrescribedExercises: json['totalPrescribedExercises'] as int,
      completedExercisesCount: json['completedExercisesCount'] as int,
      validExercisesCount: json['validExercisesCount'] as int,
      totalTargetDurationSec: json['totalTargetDurationSec'] as int,
      totalActualWatchtimeSec: json['totalActualWatchtimeSec'] as int,
      overallAdherencePercent: (json['overallAdherencePercent'] as num).toDouble(),
      isSyncedToFirebase: json['isSyncedToFirebase'] as bool? ?? false,
      exercises: [], // V případě potřeby lze doparsovat z json['exercises']
    );
  }
}