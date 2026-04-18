import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../routines/domain/routine_models.dart';
import '../data/local_workout_repository.dart';
import '../data/workout_repository.dart';
import '../domain/workout_models.dart';

final workoutRepositoryProvider = Provider<WorkoutRepository>((ref) {
  return LocalWorkoutRepository();
});

final workoutControllerProvider =
    AsyncNotifierProvider<WorkoutController, WorkoutState>(
      WorkoutController.new,
    );

class WorkoutState {
  const WorkoutState({required this.sessions, this.activeSession});

  final List<WorkoutSession> sessions;
  final WorkoutSession? activeSession;

  WorkoutState copyWith({
    List<WorkoutSession>? sessions,
    WorkoutSession? activeSession,
    bool clearActiveSession = false,
  }) {
    return WorkoutState(
      sessions: sessions ?? this.sessions,
      activeSession: clearActiveSession
          ? null
          : (activeSession ?? this.activeSession),
    );
  }
}

class WorkoutController extends AsyncNotifier<WorkoutState> {
  WorkoutRepository get _repository => ref.read(workoutRepositoryProvider);

  @override
  Future<WorkoutState> build() async {
    final sessions = await _repository.listSessions();
    return WorkoutState(sessions: sessions);
  }

  Future<void> startSession(
    RoutineDay day, {
    DateTime? workoutDate,
  }) async {
    final current = _safeState();
    final session = await _repository.createSessionFromRoutineDay(
      day,
      workoutDate: workoutDate,
    );

    state = AsyncData(current.copyWith(activeSession: session));
  }

  void discardActiveSession() {
    final current = _safeState();
    state = AsyncData(current.copyWith(clearActiveSession: true));
  }

  void updateSet({
    required String entryId,
    required String setId,
    required int setNumber,
    required int reps,
    required double weight,
    String? note,
  }) {
    final current = _safeState();
    final activeSession = current.activeSession;

    if (activeSession == null) {
      return;
    }

    final updatedEntries = [
      for (final entry in activeSession.entries)
        if (entry.id == entryId)
          entry.copyWith(
            sets: [
              for (final set in entry.sets)
                if (set.id == setId)
                  set.copyWith(
                    setNumber: setNumber,
                    reps: reps,
                    weight: weight,
                    note: note,
                    clearNote: note == null,
                  )
                else
                  set,
            ],
          )
        else
          entry,
    ];

    state = AsyncData(
      current.copyWith(
        activeSession: activeSession.copyWith(
          entries: updatedEntries,
          updatedAt: DateTime.now(),
        ),
      ),
    );
  }

  void addSet({
    required String entryId,
    required int setNumber,
    required int reps,
    required double weight,
    String? note,
  }) {
    final current = _safeState();
    final activeSession = current.activeSession;

    if (activeSession == null) {
      return;
    }

    final newSet = WorkoutSet(
      id: _buildId('set'),
      setNumber: setNumber,
      reps: reps,
      weight: weight,
      note: note,
    );

    final updatedEntries = [
      for (final entry in activeSession.entries)
        if (entry.id == entryId)
          entry.copyWith(sets: [...entry.sets, newSet])
        else
          entry,
    ];

    state = AsyncData(
      current.copyWith(
        activeSession: activeSession.copyWith(
          entries: updatedEntries,
          updatedAt: DateTime.now(),
        ),
      ),
    );
  }

  void removeSet({required String entryId, required String setId}) {
    final current = _safeState();
    final activeSession = current.activeSession;

    if (activeSession == null) {
      return;
    }

    final updatedEntries = [
      for (final entry in activeSession.entries)
        if (entry.id == entryId)
          entry.copyWith(
            sets: [
              for (final set in entry.sets)
                if (set.id != setId) set,
            ],
          )
        else
          entry,
    ];

    state = AsyncData(
      current.copyWith(
        activeSession: activeSession.copyWith(
          entries: updatedEntries,
          updatedAt: DateTime.now(),
        ),
      ),
    );
  }

  Future<void> saveActiveSession() async {
    final current = _safeState();
    final activeSession = current.activeSession;

    if (activeSession == null) {
      return;
    }

    await _repository.upsertSession(activeSession);
    final sessions = await _repository.listSessions();

    state = AsyncData(
      current.copyWith(sessions: sessions, clearActiveSession: true),
    );
  }

  void editSavedSession(WorkoutSession session) {
    final current = _safeState();
    state = AsyncData(current.copyWith(activeSession: session));
  }

  void updateSessionDate(DateTime date) {
    final current = _safeState();
    final activeSession = current.activeSession;

    if (activeSession == null) {
      return;
    }

    state = AsyncData(
      current.copyWith(
        activeSession: activeSession.copyWith(
          startedAt: date,
          updatedAt: DateTime.now(),
        ),
      ),
    );
  }

  Future<void> deleteSession(String sessionId) async {
    await _repository.deleteSession(sessionId);
    final sessions = await _repository.listSessions();
    final current = _safeState();
    final clearActive = current.activeSession?.id == sessionId;
    state = AsyncData(
      current.copyWith(
        sessions: sessions,
        clearActiveSession: clearActive,
      ),
    );
  }

  WorkoutState _safeState() {
    return state.value ?? const WorkoutState(sessions: []);
  }

  String _buildId(String prefix) {
    final micros = DateTime.now().microsecondsSinceEpoch;
    return '$prefix-$micros';
  }
}
