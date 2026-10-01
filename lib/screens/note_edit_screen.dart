import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../models/note_model.dart';
import '../services/notes_service.dart';

class NoteEditScreen extends StatefulWidget {
  final NoteItem? existingNote;

  const NoteEditScreen({
    super.key,
    this.existingNote,
  });

  @override
  State<NoteEditScreen> createState() => _NoteEditScreenState();
}

class _NoteEditScreenState extends State<NoteEditScreen> {
  late TextEditingController _titleController;
  late TextEditingController _contentController;
  bool _isBold = false;
  bool _isItalic = false;
  bool _isUnderline = false;

  @override
  void initState() {
    super.initState();
    _titleController =
        TextEditingController(text: widget.existingNote?.title ?? '');
    _contentController =
        TextEditingController(text: widget.existingNote?.content ?? '');
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  void _saveNote() {
    final title = _titleController.text.trim();
    final content = _contentController.text.trim();

    if (title.isEmpty && content.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Lütfen bir başlık veya içerik girin.'),
          backgroundColor: AppColors.cardBackground,
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }

    if (widget.existingNote != null) {
      NotesService.instance.updateNote(
        widget.existingNote!.id,
        title,
        content,
      );
    } else {
      NotesService.instance.addNote(
        title,
        content,
      );
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Not kaydedildi.'),
        backgroundColor: AppColors.cardBackground,
        duration: Duration(milliseconds: 1500),
      ),
    );

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.existingNote != null;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            _buildAppBar(isEditing),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  children: [
                    const SizedBox(height: 12),
                    _buildTitleField(),
                    const SizedBox(height: 16),
                    Expanded(
                      child: _buildContentField(),
                    ),
                  ],
                ),
              ),
            ),
            _buildFormattingToolbar(),
            _buildSaveButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBar(bool isEditing) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: const Icon(Icons.chevron_left_rounded),
            color: Colors.white,
            iconSize: 32,
            onPressed: () => Navigator.pop(context),
          ),
          Text(
            isEditing ? 'Notu Düzenle' : 'Yeni Not',
            style: const TextStyle(
              color: AppColors.textPrimary,
              fontSize: 18,
              fontWeight: FontWeight.w700,
            ),
          ),
          IconButton(
            icon: const Icon(Icons.ios_share_rounded),
            color: Colors.white,
            iconSize: 22,
            onPressed: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildTitleField() {
    return Container(
      height: 64,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: const Color(0xFF162033),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.cyan,
          width: 1.5,
        ),
      ),
      alignment: Alignment.centerLeft,
      child: TextField(
        controller: _titleController,
        style: const TextStyle(
          color: AppColors.textPrimary,
          fontSize: 24,
          fontWeight: FontWeight.w700,
        ),
        cursorColor: AppColors.cyan,
        decoration: const InputDecoration(
          hintText: 'Başlık',
          hintStyle: TextStyle(
            color: Color(0xFF5A6980),
            fontSize: 24,
            fontWeight: FontWeight.w700,
          ),
          border: InputBorder.none,
          isDense: true,
          contentPadding: EdgeInsets.zero,
        ),
      ),
    );
  }

  Widget _buildContentField() {
    return TextField(
      controller: _contentController,
      maxLines: null,
      expands: true,
      textAlignVertical: TextAlignVertical.top,
      style: TextStyle(
        color: AppColors.textPrimary,
        fontSize: 16,
        height: 1.5,
        fontWeight: _isBold ? FontWeight.bold : FontWeight.normal,
        fontStyle: _isItalic ? FontStyle.italic : FontStyle.normal,
        decoration: _isUnderline
            ? TextDecoration.underline
            : TextDecoration.none,
      ),
      cursorColor: AppColors.cyan,
      decoration: const InputDecoration(
        hintText: 'Notunu buraya yazmaya başla...',
        hintStyle: TextStyle(
          color: Color(0xFF5A6980),
          fontSize: 16,
          fontWeight: FontWeight.w400,
        ),
        border: InputBorder.none,
        contentPadding: EdgeInsets.zero,
      ),
    );
  }

  Widget _buildFormattingToolbar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      decoration: const BoxDecoration(
        color: Color(0xFF151D2E),
        border: Border(
          top: BorderSide(
            color: Color(0xFF283652),
            width: 1,
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildToolbarIcon(Icons.undo_rounded, () {}),
          _buildToolbarIcon(Icons.redo_rounded, () {}),
          _buildToolbarIcon(Icons.title_rounded, () {}),
          _buildToolbarIcon(Icons.brush_outlined, () {}),
          _buildToolbarIcon(
            Icons.format_bold_rounded,
            () => setState(() => _isBold = !_isBold),
            isActive: _isBold,
          ),
          _buildToolbarIcon(
            Icons.format_italic_rounded,
            () => setState(() => _isItalic = !_isItalic),
            isActive: _isItalic,
          ),
          _buildToolbarIcon(
            Icons.format_underlined_rounded,
            () => setState(() => _isUnderline = !_isUnderline),
            isActive: _isUnderline,
          ),
          _buildToolbarIcon(Icons.format_strikethrough_rounded, () {}),
          _buildToolbarIcon(Icons.link_rounded, () {}),
        ],
      ),
    );
  }

  Widget _buildToolbarIcon(
    IconData icon,
    VoidCallback onTap, {
    bool isActive = false,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(6),
      child: Padding(
        padding: const EdgeInsets.all(6),
        child: Icon(
          icon,
          size: 20,
          color: isActive ? AppColors.cyan : const Color(0xFF8E9BAE),
        ),
      ),
    );
  }

  Widget _buildSaveButton() {
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16, top: 10, bottom: 12),
      child: InkWell(
        onTap: _saveNote,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          height: 50,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [
                Color(0xFF0EA5E9),
                Color(0xFF2563EB),
              ],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF0EA5E9).withAlpha(80),
                blurRadius: 14,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.check_rounded,
                color: Colors.white,
                size: 20,
              ),
              SizedBox(width: 8),
              Text(
                'Kaydet',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.3,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
