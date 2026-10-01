class NoteItem {
  final String id;
  String title;
  String content;
  final DateTime createdAt;
  final bool isCanvas;

  NoteItem({
    required this.id,
    required this.title,
    this.content = '',
    required this.createdAt,
    this.isCanvas = false,
  });
}
