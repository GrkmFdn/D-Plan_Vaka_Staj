import 'package:flutter/material.dart';
import '../models/habit_model.dart';

class HabitsService extends ChangeNotifier {
  static final HabitsService instance = HabitsService._internal();

  factory HabitsService() {
    return instance;
  }

  HabitsService._internal() {
    _initDefaultHabits();
  }

  final List<HabitItem> _habits = [];
  HabitItem? _lastDeletedHabit;
  int? _lastDeletedIndex;

  List<HabitItem> get habits => List.unmodifiable(_habits);

  int get completedCount => _habits.where((h) => h.isCompleted).length;
  int get totalCount => _habits.length;
  double get completionRatio =>
      _habits.isEmpty ? 0 : completedCount / totalCount;
  int get completionPercentage => (completionRatio * 100).round();

  void _initDefaultHabits() {
    _habits.addAll([
      HabitItem(
        id: '1',
        title: 'Sosyal Medya Detoksu',
        iconSymbol: '🚫',
        isCompleted: false,
        streak: 0,
        activeColor: Colors.redAccent,
        uncompletedColor: const Color(0xFFEF4444),
      ),
      HabitItem(
        id: '2',
        title: '10 Bin Adım',
        iconSymbol: '🚶',
        isCompleted: false,
        streak: 0,
        activeColor: const Color(0xFF38BDF8),
        uncompletedColor: const Color(0xFF475569),
      ),
      HabitItem(
        id: '3',
        title: 'Yarını Planla',
        iconSymbol: '📅',
        isCompleted: true,
        streak: 1,
        activeColor: const Color(0xFF06B6D4),
      ),
      HabitItem(
        id: '4',
        title: '8 Saat Uyku',
        iconSymbol: '💤',
        isCompleted: true,
        streak: 1,
        activeColor: const Color(0xFF6366F1),
      ),
      HabitItem(
        id: '5',
        title: 'Sağlıklı Beslen',
        iconSymbol: '🍎',
        isCompleted: true,
        streak: 1,
        activeColor: const Color(0xFF22C55E),
      ),
    ]);
  }

  void toggleHabit(String id) {
    final index = _habits.indexWhere((h) => h.id == id);
    if (index != -1) {
      _habits[index].isCompleted = !_habits[index].isCompleted;
      if (_habits[index].isCompleted) {
        _habits[index].streak += 1;
      } else if (_habits[index].streak > 0) {
        _habits[index].streak -= 1;
      }
      notifyListeners();
    }
  }

  void deleteHabit(String id) {
    final index = _habits.indexWhere((h) => h.id == id);
    if (index != -1) {
      _lastDeletedIndex = index;
      _lastDeletedHabit = _habits[index];
      _habits.removeAt(index);
      notifyListeners();
    }
  }

  void undoDelete() {
    if (_lastDeletedHabit != null && _lastDeletedIndex != null) {
      final insertIndex = _lastDeletedIndex!.clamp(0, _habits.length);
      _habits.insert(insertIndex, _lastDeletedHabit!);
      _lastDeletedHabit = null;
      _lastDeletedIndex = null;
      notifyListeners();
    }
  }
}
