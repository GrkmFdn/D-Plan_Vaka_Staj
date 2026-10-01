import 'package:flutter/foundation.dart';
import '../models/chat_message.dart';

class AiAssistantService extends ChangeNotifier {
  static final AiAssistantService instance = AiAssistantService._internal();

  factory AiAssistantService() {
    return instance;
  }

  AiAssistantService._internal();

  final List<ChatMessage> _messages = [];
  bool _isProcessing = false;
  int _dailyUsed = 10;
  final int _dailyLimit = 15;
  int _hourlyRemaining = 2;

  List<ChatMessage> get messages => List.unmodifiable(_messages);
  bool get isProcessing => _isProcessing;
  int get dailyUsed => _dailyUsed;
  int get dailyLimit => _dailyLimit;
  int get hourlyRemaining => _hourlyRemaining;

  void clearChat() {
    _messages.clear();
    notifyListeners();
  }

  Future<void> sendMessage(String text) async {
    final query = text.trim();
    if (query.isEmpty) return;

    // Prevent duplicate triggers if already processing
    if (_isProcessing) return;
    _isProcessing = true;

    // 1. Add user message
    _messages.add(
      ChatMessage(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        sender: MessageSender.user,
        text: query,
        timestamp: DateTime.now(),
      ),
    );

    // Update quota
    if (_dailyUsed < _dailyLimit) {
      _dailyUsed++;
    }
    if (_hourlyRemaining > 0) {
      _hourlyRemaining--;
    }
    notifyListeners();

    // 2. Add transient status message ("✓ Veriler okunuyor...")
    final statusMsgId = 'status_${DateTime.now().millisecondsSinceEpoch}';
    final statusMessage = ChatMessage(
      id: statusMsgId,
      sender: MessageSender.status,
      text: '✓ Veriler okunuyor...',
      timestamp: DateTime.now(),
    );
    _messages.add(statusMessage);
    notifyListeners();

    // Simulate smart AI response generation delay
    await Future.delayed(const Duration(milliseconds: 700));

    // 3. Remove transient status message before outputting response
    _messages.removeWhere((msg) => msg.id == statusMsgId);

    // 4. Generate accurate, non-duplicated response based on specific intent
    final responseText = _resolveResponse(query);

    _messages.add(
      ChatMessage(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        sender: MessageSender.ai,
        text: responseText,
        timestamp: DateTime.now(),
      ),
    );

    _isProcessing = false;
    notifyListeners();
  }

  String _resolveResponse(String query) {
    final lower = query.toLowerCase();

    // Check specifically for DAILY analysis (fixing the bug where daily routed to weekly!)
    if (lower.contains('günün analizi') ||
        lower.contains('bugün') && lower.contains('analiz') ||
        lower.contains('günü değerlendir')) {
      return _generateDailyAnalysis();
    }

    // Check for weekly recap
    if (lower.contains('hafta') ||
        lower.contains('haftalık') ||
        lower.contains('weekly')) {
      return _generateWeeklyRecap();
    }

    // Focus session prompt
    if (lower.contains('odak') || lower.contains('focus')) {
      return '⏱️ 15 dakikalık odaklanma seansın için hazır mısın?\n\n'
          'Bildirimlerini sessize al ve dikkatini dağıtacak her şeyi uzaklaştır. Seansı başlatmak istediğinde haber ver, senin için zamanlayıcıyı hemen kuralım.';
    }

    // Add task prompt
    if (lower.contains('görev ekle') || lower.contains('yeni görev')) {
      return '➕ Yeni bir görev eklemek harika bir adım!\n\n'
          'Görevin adı nedir ve saat kaçta tamamlamayı planlıyorsun? İstersen bunu senin adına hemen Bugünün Görevleri listesine ekleyebilirim.';
    }

    // Default intelligent assistant response
    return 'Mesajını aldım: "$query"\n\n'
        'Planlarını düzenlemene, günlük görevlerini optimize etmene ve alışkanlıklarını takip etmene yardımcı olmak için buradayım. Başka bir konuda yardımcı olmamı ister misin?';
  }

  String _generateDailyAnalysis() {
    return 'İşte bugünün özeti ve analizi (1 Ekim):\n\n'
        '📊 Görev Durumu\n'
        '• Tamamlanan: 2/3 (%67) — "Staj Görüşmesi" (13:30) ve "Arkadaşlarla Dışarı Çıkma" (20:00) tamamlandı.\n'
        '• Açık Görev: 1 görev açık ("Uygulamayı Tanı").\n\n'
        '🧘 Odaklanma (Focus)\n'
        '• Bugün kaydedilen odak süren: 1 dakika. Verimli bir çalışma için 25 dakikalık bir Pomodoro seansı planlamanı öneririm.\n\n'
        '🎯 Alışkanlık Takibi\n'
        '• Alışkanlıklarının 4/5\'i tamamlandı (%80). İstikrarlı bir ilerleme!\n\n'
        '💡 Önerilerim:\n'
        '1. Kalan son açık görevini tamamlayarak bugünün hedefini %100 yapabilirsin.\n'
        '2. Yarın için sabah saatlerine bir odak seansı ekleyerek güne dinamik başlayabilirsin.';
  }

  String _generateWeeklyRecap() {
    return 'Haftan şöyle geçmiş Görkem (28 Eylül – 4 Ekim):\n\n'
        '📊 Genel Görünüm\n'
        '• Görev tamamlama: 1/2 (%50) — sadece 2 görevin vardı, biri tamam, geciken görev yok 👍\n'
        '• En verimli gün: Perşembe (Staj Görüşmesi + Arkadaşlarla Çıkma ile yoğundu)\n\n'
        '🧘 Odak (Focus)\n'
        '• Hafta boyunca toplam 1 dakika odaklanmışsın. Odak seanslarını artırmak haftalık verimini katlayacaktır.\n\n'
        '🎯 Alışkanlıklar\n'
        '• 3 tamamlama. Uyku, Beslenme ve Yarını Planla seride. Sosyal Medya Detoksu için biraz daha özen gerekiyor.';
  }
}
