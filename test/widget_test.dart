import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:d_plan/main.dart';
import 'package:d_plan/screens/notes_screen.dart';
import 'package:d_plan/screens/note_edit_screen.dart';
import 'package:d_plan/screens/assistant_screen.dart';
import 'package:d_plan/screens/habits_screen.dart';

void main() {
  testWidgets('App renders D-Plan home screen and navigation',
      (WidgetTester tester) async {
    await tester.pumpWidget(const DPlanApp());
    await tester.pump();

    // Verify Today screen elements
    expect(find.text('İyi geceler, Görkem'), findsOneWidget);
    expect(find.text('Günün Sözü'), findsOneWidget);
    expect(find.text('Notlar'), findsOneWidget);
    expect(find.text('Bugünün Görevleri'), findsOneWidget);
  });

  testWidgets(
      'Navigating from Tümünü Gör to NotesScreen and saving new note with Kaydet button',
      (WidgetTester tester) async {
    await tester.pumpWidget(const DPlanApp());
    await tester.pump();

    // 1. Tap "Tümünü gör" button in the Notlar section
    final tumunuGorFinder = find.text('Tümünü gör').first;
    expect(tumunuGorFinder, findsOneWidget);
    await tester.tap(tumunuGorFinder);
    await tester.pumpAndSettle();

    // 2. Verify NotesScreen is displayed
    expect(find.byType(NotesScreen), findsOneWidget);
    expect(find.text('Yazılı'), findsOneWidget);
    expect(find.text('Tuval'), findsOneWidget);
    expect(find.text("D-Plan'ı geliştir"), findsOneWidget);
    expect(find.text('Tüm notlar yüklendi'), findsOneWidget);

    // 3. Tap the add icon (+) on top right of NotesScreen
    final addIconFinder = find.descendant(
      of: find.byType(NotesScreen),
      matching: find.byIcon(Icons.add_rounded),
    );
    expect(addIconFinder, findsOneWidget);
    await tester.tap(addIconFinder);
    await tester.pumpAndSettle();

    // 4. Verify NoteEditScreen is displayed
    expect(find.byType(NoteEditScreen), findsOneWidget);
    expect(find.text('Yeni Not'), findsOneWidget);
    expect(find.text('Kaydet'), findsOneWidget);

    // 5. Enter title and content
    final titleFieldFinder = find.widgetWithText(TextField, 'Başlık');
    expect(titleFieldFinder, findsOneWidget);
    await tester.enterText(titleFieldFinder, 'Flutter Staj Projesi');

    final contentFieldFinder =
        find.widgetWithText(TextField, 'Notunu buraya yazmaya başla...');
    expect(contentFieldFinder, findsOneWidget);
    await tester.enterText(
        contentFieldFinder, 'Notlar kısmı başarıyla tamamlandı.');

    // 6. Tap "Kaydet" button
    final kaydetButtonFinder = find.text('Kaydet');
    expect(kaydetButtonFinder, findsOneWidget);
    await tester.tap(kaydetButtonFinder);
    await tester.pumpAndSettle();

    // 7. Verify we are back on NotesScreen and the new note is visible
    expect(find.byType(NotesScreen), findsOneWidget);
    expect(find.text('Flutter Staj Projesi'), findsOneWidget);
  });

  testWidgets(
      'AI Assistant properly handles Günün analizini yap without duplicates or system prompt leak',
      (WidgetTester tester) async {
    await tester.pumpWidget(const DPlanApp());
    await tester.pump();

    // 1. Navigate to Asistan tab in bottom navigation
    final asistanTabFinder = find.byIcon(Icons.auto_awesome).first;
    await tester.tap(asistanTabFinder);
    await tester.pumpAndSettle();

    // Verify AssistantScreen is displayed
    expect(find.byType(AssistantScreen), findsOneWidget);

    // 2. Tap "Günün analizini yap" quick chip
    final chipFinder = find.text('📊 Günün analizini yap');
    expect(chipFinder, findsOneWidget);
    await tester.tap(chipFinder);

    // Fast forward to complete AI generation
    await tester.pump(const Duration(milliseconds: 200));
    await tester.pump(const Duration(milliseconds: 800));
    await tester.pumpAndSettle();

    // 3. Verify user query is displayed
    expect(find.text('Günün analizini yap'), findsOneWidget);

    // 4. Verify AI answered with DAILY analysis (NOT weekly recap)
    expect(find.textContaining('İşte bugünün özeti ve analizi (1 Ekim):'),
        findsOneWidget);

    // 5. Verify NO SYSTEM PROMPT LEAK exists
    expect(find.textContaining('SYSTEM/WEEKLY RECAP'), findsNothing);

    // 6. Verify single response (NOT 3 duplicate responses)
    expect(
        find.textContaining('İşte bugünün özeti ve analizi'), findsOneWidget);

    // 7. Verify quota was updated correctly
    expect(find.text('Bugün 11/15'), findsOneWidget);
    expect(find.text('Bu saat 1 hakkın kaldı'), findsOneWidget);
  });

  testWidgets(
      'Swiping a habit card from right to left automatically deletes it from the list',
      (WidgetTester tester) async {
    await tester.pumpWidget(const DPlanApp());
    await tester.pump();

    // 1. Navigate to Kitaplık tab
    final kitaplikTabFinder = find.byIcon(Icons.grid_view_rounded).first;
    await tester.tap(kitaplikTabFinder);
    await tester.pumpAndSettle();

    // 2. Tap on "Alışkanlık Takibi" row
    final habitRowFinder = find.text('Alışkanlık Takibi');
    expect(habitRowFinder, findsOneWidget);
    await tester.tap(habitRowFinder);
    await tester.pumpAndSettle();

    // 3. Verify HabitsScreen is displayed
    expect(find.byType(HabitsScreen), findsOneWidget);
    expect(find.text('3 / 5 tamamlandı'), findsOneWidget);
    expect(find.text('Sosyal Medya Detoksu'), findsOneWidget);
    expect(find.text('10 Bin Adım'), findsOneWidget);
    expect(find.text('Yarını Planla'), findsOneWidget);

    // 4. Swipe "Sosyal Medya Detoksu" from right to left (endToStart)
    await tester.drag(
      find.text('Sosyal Medya Detoksu'),
      const Offset(-500.0, 0.0),
    );
    await tester.pumpAndSettle();

    // 5. Verify "Sosyal Medya Detoksu" is automatically removed
    expect(find.text('Sosyal Medya Detoksu'), findsNothing);

    // 6. Verify counter automatically updated from 3 / 5 to 3 / 4
    expect(find.text('3 / 4 tamamlandı'), findsOneWidget);

    // 7. Verify SnackBar confirmation was shown
    expect(find.text('"Sosyal Medya Detoksu" silindi'), findsOneWidget);
  });
}
