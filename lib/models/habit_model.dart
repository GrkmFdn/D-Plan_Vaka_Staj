import 'package:flutter/material.dart';

class HabitItem {
  final String id;
  final String title;
  final String iconSymbol; // emoji or icon code
  bool isCompleted;
  int streak;
  final Color activeColor;
  final Color? uncompletedColor;

  HabitItem({
    required this.id,
    required this.title,
    required this.iconSymbol,
    this.isCompleted = false,
    this.streak = 0,
    required this.activeColor,
    this.uncompletedColor,
  });
}
