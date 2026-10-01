import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../models/habit_model.dart';
import '../services/habits_service.dart';
import '../widgets/custom_bottom_nav_bar.dart';

class HabitsScreen extends StatefulWidget {
  const HabitsScreen({super.key});

  @override
  State<HabitsScreen> createState() => _HabitsScreenState();
}

class _HabitsScreenState extends State<HabitsScreen> {
  int _selectedDayIndex = 3; // Index 3 is 'P 1' (Perşembe 1 Eki) in the strip

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: HabitsService.instance,
      builder: (context, _) {
        final habits = HabitsService.instance.habits;
        final completedCount = HabitsService.instance.completedCount;
        final totalCount = HabitsService.instance.totalCount;
        final completionPercentage =
            HabitsService.instance.completionPercentage;
        final completionRatio = HabitsService.instance.completionRatio;

        return Scaffold(
          backgroundColor: AppColors.background,
          body: SafeArea(
            bottom: false,
            child: Stack(
              children: [
                Column(
                  children: [
                    _buildAppBar(),
                    _buildWeekdayStrip(),
                    const SizedBox(height: 12),
                    _buildSummaryCard(
                      completedCount: completedCount,
                      totalCount: totalCount,
                      percentage: completionPercentage,
                      ratio: completionRatio,
                    ),
                    const SizedBox(height: 14),
                    Expanded(
                      child: habits.isEmpty
                          ? _buildEmptyState()
                          : ListView.builder(
                              padding: const EdgeInsets.only(
                                left: 16,
                                right: 16,
                                top: 4,
                                bottom: 120, // Space for floating bottom bar
                              ),
                              itemCount: habits.length,
                              itemBuilder: (context, index) {
                                final habit = habits[index];
                                return _buildDismissibleHabitCard(habit);
                              },
                            ),
                    ),
                  ],
                ),
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: CustomBottomNavBar(
                    selectedIndex: 3, // 'Kitaplık' tab
                    onItemSelected: (index) {
                      Navigator.pop(context);
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildAppBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.chevron_left_rounded),
            color: Colors.white,
            iconSize: 32,
            onPressed: () => Navigator.pop(context),
          ),
          const SizedBox(width: 4),
          const Text(
            'Alışkanlık Takibi',
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: 22,
              fontWeight: FontWeight.w700,
              letterSpacing: -0.3,
            ),
          ),
          const Spacer(),
          IconButton(
            icon: const Icon(Icons.bar_chart_rounded),
            color: Colors.white,
            iconSize: 24,
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.add_rounded),
            color: Colors.white,
            iconSize: 28,
            onPressed: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildWeekdayStrip() {
    final days = [
      {'day': 'P', 'date': '28'},
      {'day': 'S', 'date': '29'},
      {'day': 'Ç', 'date': '30'},
      {'day': 'P', 'date': '1'},
      {'day': 'C', 'date': '2'},
      {'day': 'C', 'date': '3'},
      {'day': 'P', 'date': '4'},
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: List.generate(days.length, (index) {
          final isSelected = index == _selectedDayIndex;
          final item = days[index];

          return InkWell(
            onTap: () => setState(() => _selectedDayIndex = index),
            borderRadius: BorderRadius.circular(16),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 44,
              padding: const EdgeInsets.symmetric(vertical: 8),
              decoration: BoxDecoration(
                color: isSelected
                    ? AppColors.cyan
                    : const Color(0xFF1B2539),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: isSelected
                      ? AppColors.cyan
                      : const Color(0xFF27354E),
                  width: 1,
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    item['day']!,
                    style: TextStyle(
                      color: isSelected
                          ? const Color(0xFF0F172A)
                          : const Color(0xFF94A3B8),
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    item['date']!,
                    style: TextStyle(
                      color: isSelected
                          ? const Color(0xFF0F172A)
                          : Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  if (isSelected) ...[
                    const SizedBox(height: 3),
                    Container(
                      width: 4,
                      height: 4,
                      decoration: const BoxDecoration(
                        color: Color(0xFF0F172A),
                        shape: BoxShape.circle,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildSummaryCard({
    required int completedCount,
    required int totalCount,
    required int percentage,
    required double ratio,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFF1C263B),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: const Color(0xFF283652),
            width: 1.2,
          ),
        ),
        child: Row(
          children: [
            // Circular progress indicator
            SizedBox(
              width: 54,
              height: 54,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  CircularProgressIndicator(
                    value: ratio,
                    strokeWidth: 4.5,
                    backgroundColor: const Color(0xFF26334D),
                    valueColor: const AlwaysStoppedAnimation(AppColors.cyan),
                  ),
                  Text(
                    '$percentage%',
                    style: const TextStyle(
                      color: AppColors.cyan,
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16),
            // Progress label and segmented bars
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '$completedCount / $totalCount tamamlandı',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: List.generate(totalCount, (index) {
                      final isFilled = index < completedCount;
                      return Expanded(
                        child: Container(
                          height: 6,
                          margin: EdgeInsets.only(
                            right: index == totalCount - 1 ? 0 : 6,
                          ),
                          decoration: BoxDecoration(
                            color: isFilled
                                ? AppColors.cyan
                                : const Color(0xFF283652),
                            borderRadius: BorderRadius.circular(3),
                          ),
                        ),
                      );
                    }),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDismissibleHabitCard(HabitItem habit) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Dismissible(
        key: Key(habit.id),
        // Sağdan sola kaydırma ile otomatik silme
        direction: DismissDirection.endToStart,
        background: Container(
          alignment: Alignment.centerRight,
          padding: const EdgeInsets.symmetric(horizontal: 22),
          decoration: BoxDecoration(
            color: const Color(0xFFDC2626),
            borderRadius: BorderRadius.circular(18),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: const [
              Icon(
                Icons.delete_outline_rounded,
                color: Colors.white,
                size: 24,
              ),
              SizedBox(width: 8),
              Text(
                'Sil',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  fontSize: 14.5,
                ),
              ),
            ],
          ),
        ),
        onDismissed: (direction) {
          final habitTitle = habit.title;
          HabitsService.instance.deleteHabit(habit.id);

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('"$habitTitle" silindi'),
              backgroundColor: const Color(0xFF1E283C),
              duration: const Duration(seconds: 3),
              action: SnackBarAction(
                label: 'Geri Al',
                textColor: AppColors.cyan,
                onPressed: () {
                  HabitsService.instance.undoDelete();
                },
              ),
            ),
          );
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
          decoration: BoxDecoration(
            color: const Color(0xFF1B2438),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: const Color(0xFF283652),
              width: 1.2,
            ),
          ),
          child: Row(
            children: [
              Text(
                habit.iconSymbol,
                style: const TextStyle(fontSize: 22),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Text(
                  habit.title,
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 15.5,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              if (habit.streak > 0) ...[
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.local_fire_department_rounded,
                      color: Color(0xFFFB923C),
                      size: 16,
                    ),
                    const SizedBox(width: 3),
                    Text(
                      '${habit.streak}',
                      style: const TextStyle(
                        color: Color(0xFFFB923C),
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(width: 4),
                    const Icon(
                      Icons.info_outline_rounded,
                      color: Color(0xFF64748B),
                      size: 13,
                    ),
                  ],
                ),
                const SizedBox(width: 12),
              ],
              // Completion check circle button
              InkWell(
                onTap: () {
                  HabitsService.instance.toggleHabit(habit.id);
                },
                borderRadius: BorderRadius.circular(18),
                child: Container(
                  width: 34,
                  height: 34,
                  decoration: BoxDecoration(
                    color: habit.isCompleted
                        ? habit.activeColor
                        : Colors.transparent,
                    shape: BoxShape.circle,
                    border: habit.isCompleted
                        ? null
                        : Border.all(
                            color: habit.uncompletedColor ??
                                const Color(0xFF475569),
                            width: 2,
                          ),
                  ),
                  child: habit.isCompleted
                      ? const Center(
                          child: Icon(
                            Icons.check_rounded,
                            color: Colors.white,
                            size: 20,
                          ),
                        )
                      : null,
                ),
              ),
              const SizedBox(width: 8),
              PopupMenuButton<String>(
                icon: const Icon(
                  Icons.more_vert_rounded,
                  color: Color(0xFF94A3B8),
                  size: 20,
                ),
                color: AppColors.cardBackground,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: const BorderSide(color: AppColors.cardBorder),
                ),
                onSelected: (val) {
                  if (val == 'delete') {
                    final habitTitle = habit.title;
                    HabitsService.instance.deleteHabit(habit.id);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('"$habitTitle" silindi'),
                        backgroundColor: const Color(0xFF1E283C),
                        action: SnackBarAction(
                          label: 'Geri Al',
                          textColor: AppColors.cyan,
                          onPressed: () {
                            HabitsService.instance.undoDelete();
                          },
                        ),
                      ),
                    );
                  }
                },
                itemBuilder: (context) => [
                  const PopupMenuItem(
                    value: 'edit',
                    child: Text(
                      'Düzenle',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  const PopupMenuItem(
                    value: 'delete',
                    child: Text(
                      'Sil',
                      style: TextStyle(color: Colors.redAccent),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return const Center(
      child: Text(
        'Kayıtlı alışkanlık bulunmuyor',
        style: TextStyle(
          color: AppColors.textMuted,
          fontSize: 15,
        ),
      ),
    );
  }
}
