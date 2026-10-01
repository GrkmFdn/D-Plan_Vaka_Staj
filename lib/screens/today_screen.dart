import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../services/notes_service.dart';
import '../services/habits_service.dart';
import 'notes_screen.dart';
import 'note_edit_screen.dart';

class TodayScreen extends StatelessWidget {
  const TodayScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        bottom: false,
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(
            left: 20,
            right: 20,
            top: 16,
            bottom: 100, // Space for bottom floating nav bar
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),
              const SizedBox(height: 24),
              _buildQuoteSection(),
              const SizedBox(height: 24),
              _buildNotesSection(context),
              const SizedBox(height: 24),
              _buildTasksSection(),
              const SizedBox(height: 24),
              _buildQuickStatsSection(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'İyi geceler, Görkem',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontSize: 24,
            fontWeight: FontWeight.w700,
            letterSpacing: -0.3,
          ),
        ),
        Row(
          children: [
            IconButton(
              icon: const Icon(Icons.tune_rounded),
              color: AppColors.textSecondary,
              iconSize: 22,
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
              onPressed: () {},
            ),
            const SizedBox(width: 14),
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFF1E2A40),
                border: Border.all(
                  color: const Color(0xFF2E4162),
                  width: 1.2,
                ),
              ),
              child: const Icon(
                Icons.person_rounded,
                color: AppColors.cyan,
                size: 20,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildQuoteSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: const [
            Icon(
              Icons.format_quote_rounded,
              color: AppColors.quoteIcon,
              size: 20,
            ),
            SizedBox(width: 8),
            Text(
              'Günün Sözü',
              style: TextStyle(
                color: AppColors.textPrimary,
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        ClipRRect(
          borderRadius: BorderRadius.circular(18),
          child: Container(
            decoration: BoxDecoration(
              color: AppColors.quoteBackground,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(
                color: const Color(0xFF2F3254),
                width: 1.2,
              ),
            ),
            child: Stack(
              children: [
                // Top-right background quote mark watermark
                Positioned(
                  top: 2,
                  right: 12,
                  child: Icon(
                    Icons.format_quote_rounded,
                    size: 64,
                    color: const Color(0xFF353762).withAlpha(120),
                  ),
                ),
                // Left glowing accent bar
                Positioned(
                  left: 0,
                  top: 14,
                  bottom: 14,
                  child: Container(
                    width: 4,
                    decoration: BoxDecoration(
                      color: AppColors.cyan,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
                // Quote text
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                  child: Text(
                    'Her gün atılan küçük adımlar büyük sonuçlara dönüşür.',
                    style: TextStyle(
                      color: AppColors.quoteText,
                      fontSize: 16,
                      fontStyle: FontStyle.italic,
                      fontWeight: FontWeight.w400,
                      height: 1.45,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildNotesSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(
              Icons.description_outlined,
              color: AppColors.amber,
              size: 20,
            ),
            const SizedBox(width: 8),
            const Text(
              'Notlar',
              style: TextStyle(
                color: AppColors.textPrimary,
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
            ),
            const Spacer(),
            InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const NotesScreen()),
                );
              },
              borderRadius: BorderRadius.circular(8),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                child: Row(
                  children: const [
                    Icon(
                      Icons.add_rounded,
                      color: AppColors.amber,
                      size: 20,
                    ),
                    SizedBox(width: 6),
                    Text(
                      'Tümünü gör',
                      style: TextStyle(
                        color: AppColors.amber,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        ListenableBuilder(
          listenable: NotesService.instance,
          builder: (context, _) {
            final notes = NotesService.instance.allNotes;
            final displayNotes = notes.take(2).toList();

            return Container(
              decoration: BoxDecoration(
                color: AppColors.cardBackground,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(
                  color: AppColors.cardBorder,
                  width: 1.2,
                ),
              ),
              child: Column(
                children: [
                  if (displayNotes.isNotEmpty) ...[
                    for (int i = 0; i < displayNotes.length; i++) ...[
                      if (i > 0)
                        const Divider(
                          color: AppColors.divider,
                          height: 1,
                          indent: 16,
                          endIndent: 16,
                        ),
                      _buildNoteItem(
                        title: displayNotes[i].title,
                        showChevron: true,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const NotesScreen(),
                            ),
                          );
                        },
                      ),
                    ],
                  ] else ...[
                    _buildNoteItem(
                      title: 'Sonsuz Tuval',
                      showChevron: true,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const NotesScreen(),
                          ),
                        );
                      },
                    ),
                    const Divider(
                      color: AppColors.divider,
                      height: 1,
                      indent: 16,
                      endIndent: 16,
                    ),
                    _buildNoteItem(
                      title: "D-Plan'ı geliştir",
                      showChevron: true,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const NotesScreen(),
                          ),
                        );
                      },
                    ),
                  ],
                  const Divider(
                    color: AppColors.divider,
                    height: 1,
                    indent: 16,
                    endIndent: 16,
                  ),
                  _buildAddNoteItem(context),
                ],
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildNoteItem({
    required String title,
    required bool showChevron,
    VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            const Icon(
              Icons.description_outlined,
              color: AppColors.amber,
              size: 20,
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 15.5,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            if (showChevron)
              const Icon(
                Icons.chevron_right_rounded,
                color: AppColors.textMuted,
                size: 22,
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildAddNoteItem(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const NoteEditScreen(),
          ),
        );
      },
      borderRadius: BorderRadius.circular(16),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: const [
            Icon(
              Icons.add_rounded,
              color: AppColors.amber,
              size: 20,
            ),
            SizedBox(width: 14),
            Text(
              'Yeni not',
              style: TextStyle(
                color: AppColors.amber,
                fontSize: 15,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTasksSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(
              Icons.checklist_rounded,
              color: AppColors.cyan,
              size: 20,
            ),
            const SizedBox(width: 8),
            const Text(
              'Bugünün Görevleri',
              style: TextStyle(
                color: AppColors.textPrimary,
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(width: 8),
            const Text(
              '1 Eki',
              style: TextStyle(
                color: AppColors.textSecondary,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
            const Spacer(),
            const Text(
              'Tümünü gör',
              style: TextStyle(
                color: AppColors.cyan,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.cardBackground,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: AppColors.cardBorder,
              width: 1.2,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Progress Bar Row
              Row(
                children: [
                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: const LinearProgressIndicator(
                        value: 2 / 3,
                        minHeight: 6,
                        backgroundColor: Color(0xFF25334E),
                        valueColor: AlwaysStoppedAnimation(AppColors.blue),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Text(
                    '2/3 görev',
                    style: TextStyle(
                      color: AppColors.cyan,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              const Text(
                '1 görev açık — dinlen, yarını planla.',
                style: TextStyle(
                  color: AppColors.cyan,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 16),
              // Task 1: Staj Görüşmesi
              _buildTaskItem(
                title: 'Staj Görüşmesi',
                time: '13:30',
                isCompleted: true,
                isStrikethrough: false,
              ),
              const SizedBox(height: 14),
              // Task 2: Arkadaşlarla Dışarı Çıkma
              _buildTaskItem(
                title: 'Arkadaşlarla Dışarı Çıkma',
                time: '20:00',
                isCompleted: true,
                isStrikethrough: true,
              ),
              const SizedBox(height: 16),
              // Add task row
              Row(
                children: const [
                  Icon(
                    Icons.add_rounded,
                    color: AppColors.cyan,
                    size: 20,
                  ),
                  SizedBox(width: 8),
                  Text(
                    'Bugüne bir görev ekle',
                    style: TextStyle(
                      color: AppColors.cyan,
                      fontSize: 14.5,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTaskItem({
    required String title,
    required String time,
    required bool isCompleted,
    required bool isStrikethrough,
  }) {
    return Row(
      children: [
        Container(
          width: 22,
          height: 22,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: AppColors.green,
              width: 1.8,
            ),
          ),
          child: const Center(
            child: Icon(
              Icons.check,
              size: 14,
              color: AppColors.green,
            ),
          ),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Text(
            title,
            style: TextStyle(
              color: isStrikethrough
                  ? AppColors.textMuted
                  : AppColors.textPrimary,
              fontSize: 15,
              fontWeight: FontWeight.w500,
              decoration: isStrikethrough
                  ? TextDecoration.lineThrough
                  : TextDecoration.none,
              decorationColor: AppColors.textMuted,
            ),
          ),
        ),
        Text(
          time,
          style: const TextStyle(
            color: AppColors.textMuted,
            fontSize: 14,
          ),
        ),
      ],
    );
  }

  Widget _buildQuickStatsSection() {
    return ListenableBuilder(
      listenable: HabitsService.instance,
      builder: (context, _) {
        final completed = HabitsService.instance.completedCount;
        final total = HabitsService.instance.totalCount;
        final ratio = HabitsService.instance.completionRatio;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: const [
                Icon(
                  Icons.bar_chart_rounded,
                  color: AppColors.cyan,
                  size: 20,
                ),
                SizedBox(width: 8),
                Text(
                  'Hızlı İstatistikler',
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
              decoration: BoxDecoration(
                color: AppColors.cardBackground,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(
                  color: AppColors.cardBorder,
                  width: 1.2,
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildStatGauge(
                    percent: 0.67,
                    color: AppColors.cyan,
                    label: '%67',
                    sublabel: 'Görev',
                  ),
                  _buildStatGauge(
                    percent: ratio,
                    color: AppColors.purple,
                    label: '$completed/$total',
                    sublabel: 'Alışkanlık',
                  ),
                  _buildStatGauge(
                    percent: 0.50,
                    color: AppColors.green,
                    icon: Icons.arrow_forward_rounded,
                    sublabel: 'Hedef',
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildStatGauge({
    required double percent,
    required Color color,
    String? label,
    IconData? icon,
    required String sublabel,
  }) {
    return Column(
      children: [
        SizedBox(
          width: 56,
          height: 56,
          child: Stack(
            alignment: Alignment.center,
            children: [
              CircularProgressIndicator(
                value: percent,
                strokeWidth: 4.5,
                backgroundColor: const Color(0xFF263249),
                valueColor: AlwaysStoppedAnimation(color),
              ),
              if (label != null)
                Text(
                  label,
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                  ),
                )
              else if (icon != null)
                Icon(
                  icon,
                  color: color,
                  size: 20,
                ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        Text(
          sublabel,
          style: const TextStyle(
            color: AppColors.textSecondary,
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
