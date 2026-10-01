import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../services/notes_service.dart';
import '../services/habits_service.dart';
import 'notes_screen.dart';
import 'habits_screen.dart';

class LibraryScreen extends StatelessWidget {
  const LibraryScreen({super.key});

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
              const SizedBox(height: 28),
              _buildPlanAndFocusSection(context),
              const SizedBox(height: 24),
              _buildNotesSection(context),
              const SizedBox(height: 24),
              _buildListsSection(),
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
          'Kitaplık',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontSize: 28,
            fontWeight: FontWeight.w700,
            letterSpacing: -0.5,
          ),
        ),
        IconButton(
          icon: const Icon(Icons.settings_outlined),
          color: AppColors.textPrimary,
          iconSize: 26,
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(),
          onPressed: () {},
        ),
      ],
    );
  }

  Widget _buildPlanAndFocusSection(BuildContext context) {
    return ListenableBuilder(
      listenable: HabitsService.instance,
      builder: (context, _) {
        final habitCount = HabitsService.instance.totalCount;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'PLANLA & ODAK',
              style: TextStyle(
                color: AppColors.textMuted,
                fontSize: 12.5,
                fontWeight: FontWeight.w700,
                letterSpacing: 1.2,
              ),
            ),
            const SizedBox(height: 10),
            Container(
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
                  _buildRowItem(
                    icon: Icons.grid_view_rounded,
                    title: 'Görev Panosu',
                    count: '5',
                  ),
                  const Divider(
                    color: AppColors.divider,
                    height: 1,
                    indent: 16,
                    endIndent: 16,
                  ),
                  _buildRowItem(
                    icon: Icons.water_drop_outlined,
                    title: 'Alışkanlık Takibi',
                    count: '$habitCount',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const HabitsScreen(),
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
                  _buildRowItem(
                    icon: Icons.timer_outlined,
                    title: 'Odaklanma',
                    count: null,
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildNotesSection(BuildContext context) {
    return ListenableBuilder(
      listenable: NotesService.instance,
      builder: (context, _) {
        final writtenCount = NotesService.instance.writtenNotes.length;
        final canvasCount = NotesService.instance.canvasNotes.length;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'NOTLAR',
              style: TextStyle(
                color: AppColors.textMuted,
                fontSize: 12.5,
                fontWeight: FontWeight.w700,
                letterSpacing: 1.2,
              ),
            ),
            const SizedBox(height: 10),
            Container(
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
                  _buildRowItem(
                    icon: Icons.crop_portrait_rounded,
                    title: 'Notlar',
                    count: '$writtenCount',
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
                  _buildRowItem(
                    icon: Icons.draw_outlined,
                    title: 'Tuval Notları',
                    count: '$canvasCount',
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
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildListsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'LİSTELER',
          style: TextStyle(
            color: AppColors.textMuted,
            fontSize: 12.5,
            fontWeight: FontWeight.w700,
            letterSpacing: 1.2,
          ),
        ),
        const SizedBox(height: 10),
        Container(
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
              _buildRowItem(
                icon: Icons.check_box_outlined,
                title: 'Kontrol Listesi',
                count: '0',
              ),
              const Divider(
                color: AppColors.divider,
                height: 1,
                indent: 16,
                endIndent: 16,
              ),
              _buildRowItem(
                icon: Icons.layers_outlined,
                title: 'Hayat Listeleri',
                count: '0',
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildRowItem({
    required IconData icon,
    required String title,
    String? count,
    VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: onTap ?? () {},
      borderRadius: BorderRadius.circular(18),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
        child: Row(
          children: [
            Icon(
              icon,
              color: AppColors.cyan,
              size: 21,
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
            if (count != null) ...[
              Text(
                count,
                style: const TextStyle(
                  color: AppColors.textMuted,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(width: 8),
            ],
            const Icon(
              Icons.chevron_right_rounded,
              color: AppColors.textMuted,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
}
