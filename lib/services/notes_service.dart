import 'package:flutter/foundation.dart';
import '../models/note_model.dart';

class NotesService extends ChangeNotifier {
  static final NotesService instance = NotesService._internal();

  factory NotesService() {
    return instance;
  }

  NotesService._internal() {
    _initDefaultNotes();
  }

  final List<NoteItem> _notes = [];

  List<NoteItem> get allNotes => List.unmodifiable(_notes);

  List<NoteItem> get writtenNotes =>
      _notes.where((note) => !note.isCanvas).toList();

  List<NoteItem> get canvasNotes =>
      _notes.where((note) => note.isCanvas).toList();

  void _initDefaultNotes() {
    _notes.addAll([
      NoteItem(
        id: '1',
        title: "D-Plan'ı geliştir",
        content: 'D-Plan uygulamasının arayüzünü ve özelliklerini tamamla.',
        createdAt: DateTime.now().subtract(const Duration(hours: 2)),
        isCanvas: false,
      ),
      NoteItem(
        id: '2',
        title: 'Sonsuz Tuval',
        content: 'Proje fikirleri ve eskizler için sonsuz tuval alanı.',
        createdAt: DateTime.now().subtract(const Duration(days: 1)),
        isCanvas: true,
      ),
    ]);
  }

  void addNote(String title, String content, {bool isCanvas = false}) {
    final newNote = NoteItem(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: title.trim().isEmpty ? 'Başlıksız Not' : title.trim(),
      content: content.trim(),
      createdAt: DateTime.now(),
      isCanvas: isCanvas,
    );
    _notes.insert(0, newNote);
    notifyListeners();
  }

  void updateNote(String id, String title, String content) {
    final index = _notes.indexWhere((note) => note.id == id);
    if (index != -1) {
      _notes[index] = NoteItem(
        id: id,
        title: title.trim().isEmpty ? 'Başlıksız Not' : title.trim(),
        content: content.trim(),
        createdAt: _notes[index].createdAt,
        isCanvas: _notes[index].isCanvas,
      );
      notifyListeners();
    }
  }

  void deleteNote(String id) {
    _notes.removeWhere((note) => note.id == id);
    notifyListeners();
  }
}
