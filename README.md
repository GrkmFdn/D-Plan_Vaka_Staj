# 📱 D-Plan — Kişisel Planlama & Yapay Zekâ Asistanı

> **Staj Vaka Çalışması & Proje Teslim Dokümantasyonu**  
> Bu proje, referans ekran tasarımlarına birebir sadık kalınarak, modern Flutter mimarisi ve best practice'leri ile geliştirilmiş kapsamlı bir üretkenlik ve kişisel planlama uygulamasıdır.

---

## 📌 Proje Genel Bakışı

D-Plan; kullanıcıların günlük görevlerini, alışkanlıklarını, notlarını ve odaklanma süreçlerini yönetmesini sağlayan, yerleşik bir yapay zekâ planlama asistanı (D-Plan AI) ile desteklenmiş karanlık tema odaklı bir mobil uygulamadır.

Bu çalışma kapsamında:
1. **Referans Ekran Tasarımları**: Gönderilen arayüzler piksel ve renk uyumuyla korunmuş, keyfi tasarım değişikliklerinden kaçınılmıştır.
2. **Notlar Modülü Etkileşimi & Kaydet Butonu**: Not listeleme ve düzenleme ekranları bağlanmış; çıkış oku yerine kullanıcı deneyimini hızlandıran **"Kaydet"** butonu entegre edilmiştir.
3. **D-Plan AI Asistanı Hata Giderme & İyileştirmeler**: Asistan tarafındaki prompt sızıntısı (`[SYSTEM/WEEKLY RECAP]`), "Günün analizi" sorgusunda haftalık özet gelmesi ve yanıtların 3 kez tekrarlanması problemleri çözülerek stabil ve interaktif bir sohbet yapısı kurulmuştur.
4. **Alışkanlık Takibi & Kaydırarak Silme (Swipe-to-Delete)**: Alışkanlıklar listesinde menü tıklamaları yerine kartı **sağdan sola kaydırarak (Dismissible)** otomatik silme ve anında geri alma ("Geri Al") fonksiyonu geliştirilmiştir.

---

## 💡 Vaka Çalışması Soruları & Çözüm Raporu

> Bu bölüm, vaka değerlendirmesinde talep edilen soruların yanıtlarını ve proje kök dizinindeki [`Vaka Çalışması.docx`](file:///c:/Users/GorkemPC/Documents/GitHub/D-Plan_Vaka_Staj/Vaka%20%C3%87al%C4%B1%C5%9Fmas%C4%B1.docx) dosyasındaki analizleri özetlemektedir.

### 1. Çözümünü Anlat

#### (a) Hangi problemi, kim için çözüyorsun?
D-Plan uygulamasını günlük hayatında, derslerinde ve iş planlamasında aktif kullanan üretkenlik odaklı kullanıcılar için 3 temel problemi çözüyorum:
1. **Not Kayıt Zorluğu:** Not yazarken çıkış okuna basma zorunluluğunun yarattığı ergonomik yorgunluk ve kaydetme belirsizliği.
2. **AI Asistanı Hataları:** "Günün analizini yap" denildiğinde sistem promptunun sızması (`[SYSTEM/WEEKLY RECAP]`), günlük yerine yanlışlıkla haftalık özet getirilmesi ve aynı yanıtın 3 kez tekrarlanması.
3. **Alışkanlık Silme Verimsizliği:** Alışkanlıklar listesinde bir kartı silmek için her defasında üç noktalı menüye girme zorunluluğunun getirdiği hız ve akış kaybı.

---

#### (b) Önerin nasıl çalışır? (Taslak & Kod Parçaları)

##### 1️⃣ Notlar Modülü — Ergonomik "Kaydet" Butonu
* **Akış:** `[Not Yazılır]` ➔ `[Alttaki 'Kaydet' Butonuna Basılır]` ➔ `[NotesService.addNote()]` ➔ `[Anında Listelenir]`
* **Kod Taslağı:**
```dart
// lib/screens/note_edit_screen.dart
Widget _buildSaveButton() {
  return InkWell(
    onTap: () {
      NotesService.instance.addNote(_titleController.text, _contentController.text);
      Navigator.pop(context); // Anında listeye döner ve yeni not görünür
    },
    child: Container(
      decoration: BoxDecoration(gradient: AppGradients.cyanBlue, borderRadius: BorderRadius.circular(16)),
      child: const Text('Kaydet'),
    ),
  );
}
```

##### 2️⃣ D-Plan AI Planer — Prompt Ayrımı & İşlem Kilidi
* **Akış:** `[Kullanıcı: "Günün analizini yap"]` ➔ `[İşlem Kilidi: _isProcessing = true]` ➔ `[Günün Verileri (Görevler, Odak, Alışkanlık) Hesaplanır]` ➔ `[Tekil ve Doğru Günlük Analiz Yanıtlanır]` (Ham sistem promptları asla UI'a eklenmez).
* **Kod Taslağı:**
```dart
// lib/services/ai_assistant_service.dart
Future<void> sendMessage(String text) async {
  if (_isProcessing) return; // Mükerrer 3x tekrarları kesin olarak önler
  _isProcessing = true;
  _messages.add(ChatMessage(sender: MessageSender.user, text: text));
  
  // Günlük analiz isteği ayrımı (Weekly recap ile karışmaz)
  final responseText = text.contains('günün analizi')
      ? _generateDailyAnalysis() 
      : _generateWeeklyRecap();
  
  _messages.add(ChatMessage(sender: MessageSender.ai, text: responseText));
  _isProcessing = false;
  notifyListeners();
}
```

##### 3️⃣ Alışkanlık Takibi — Sağdan Sola Kaydırarak Silme (Swipe-to-Delete)
* **Akış:** `[Alışkanlık Kartı]` ➔ `[Sağdan Sola Sürükleme (Dismissible)]` ➔ `[Kırmızı Zemin & Çöp Kutusu]` ➔ `[Otomatik Silme]` ➔ `[Dinamik Sayaç (3/5 -> 3/4)]` ➔ `[SnackBar: "Geri Al"]`
* **Kod Taslağı:**
```dart
// lib/screens/habits_screen.dart
Dismissible(
  key: Key(habit.id),
  direction: DismissDirection.endToStart, // Yalnızca sağdan sola kaydırma
  background: Container(
    alignment: Alignment.centerRight,
    color: const Color(0xFFDC2626), // Kırmızı silme alanı
    child: const Icon(Icons.delete_outline_rounded, color: Colors.white),
  ),
  onDismissed: (_) {
    HabitsService.instance.deleteHabit(habit.id);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('"${habit.title}" silindi'), action: SnackBarAction(label: 'Geri Al', onPressed: HabitsService.instance.undoDelete)),
    );
  },
  child: _buildHabitCard(habit),
)
```

---

#### (c) Neden bu çözüm? (Gerekçelendirme)
* **Başparmak Ergonomisi (Thumb Zone):** Modern büyük ekranlı telefonlarda ekranın sol üstündeki geri okuna uzanmak zordur. Ekranın altına yerleştirilen "Kaydet" butonu tek elle kullanımı kolaylaştırır ve kayıt işlemini netleştirir.
* **Kullanıcı Güveni ve Maliyet Kontrolü:** AI asistanının ham sistem direktiflerini kullanıcıya göstermemesi profesyonel bir deneyim sağlar. İşlem kilidi (`_isProcessing`) ise gereksiz token tüketimini ve ekran kirliliğini sıfırlar.
* **Modern Mobil Deneyim (Gesture-Driven UX):** Üç noktalı menüye basıp "Sil" demek yerine sağdan sola kaydırma (Swipe-to-delete), iOS ve Android platform standartlarında en hızlı ve sezgisel silme yöntemidir. "Geri Al" seçeneğiyle de kullanıcı güvenliği garanti altına alınmıştır.

---

### 2. Yapay Zekayı Nasıl Kullandın?

* **Kullanılan Araç & Model:** Google Antigravity IDE ortamında **Gemini 3.8 Flash (High)** modeli kullanıldı.
* **Kullanılan Sorular ve Yönlendirmeler (Prompt Stratejisi):**
  1. **Tasarım Bütünlüğü Kontrolü:** Projeye başlamadan önce bir kontrol listesi oluşturuldu (`Proje.md`) ve *"Mevcut tasarımı, renkleri, fontları ve padding değerlerini keyfi olarak değiştirme; aynı UI + yeni fonksiyonellik kuralına uy"* direktifi verildi.
  2. **Notlar Modülü:** Ekran görüntüleri referans verilerek `Notlar → Tümünü Gör` akışı bağlandı, çıkış oku yerine ekranın altına tasarım diliyle tam uyumlu bir "Kaydet" butonu ekletildi.
  3. **AI Asistanı Analizi:** AI Planer ekranındaki 3 kritik hata (Haftalık özet karışıklığı, prompt sızıntısı ve 3x tekrarlama) analiz ettirilerek kök nedenleri tespit edildi ve tekil istek mekanizmasıyla giderildi.
  4. **Alışkanlık Takibi:** Üç noktalı menüye bağımlılığı azaltmak için sağdan sola kaydırma (Swipe-to-delete) eşiği ve reaktif sayaç güncellemeleri talep edildi.
* **Çıktıları Değiştirme ve Geliştirme Süreci:**
  - AI tarafından oluşturulan kodlar yalnızca görsel olarak değil; `flutter analyze` ile statik koda, `flutter test` ile otomatik widget testlerine tabi tutularak denetlendi.
  - Test aşamasında tespit edilen çift "Tümünü gör" butonu gibi durumlar için test filtreleri özelleştirildi.
  - Kazara kaydırmalara karşı "Geri Al" (Undo) mekanizması eklenerek çözüm daha güvenli hale getirildi.
* **Belge Referansı:** Çalışmanın ham notları ve detayları proje dizinindeki [`Vaka Çalışması.docx`](file:///c:/Users/GorkemPC/Documents/GitHub/D-Plan_Vaka_Staj/Vaka%20%C3%87al%C4%B1%C5%9Fmas%C4%B1.docx) dosyasında yer almaktadır.

---

## 🚀 Hızlı Başlangıç & Kurulum

Uygulamayı yerel ortamınızda çalıştırmak ve test etmek için aşağıdaki adımları izleyebilirsiniz.

### 📋 Gereksinimler
- **Flutter SDK**: `^3.19.0` veya üzeri (Örn: Flutter 3.41.x / Dart 3.11.x)
- **Cihaz / Emülatör**: Android Emülatör / Fiziksel Cihaz, iOS Simülatör, Windows Desktop veya Chrome

### ⚙️ Çalıştırma Adımları

1. **Projeyi Klonlayın / Proje Dizinine Gidin:**
   ```bash
   cd D-Plan_Vaka_Staj
   ```

2. **Bağımlılıkları Yükleyin:**
   ```bash
   flutter pub get
   ```

3. **Statik Kod Analizini Doğrulayın:**
   ```bash
   flutter analyze
   ```
   *(Çıktı: `No issues found!`)*

4. **Otomatik Testleri Çalıştırın:**
   ```bash
   flutter test
   ```
   *(Tüm test senaryoları `00:03 +4: All tests passed!` ile başarıyla tamamlanır.)*

5. **Uygulamayı Başlatın:**
   ```bash
   # Bağlı tüm cihazları listelemek için:
   flutter devices

   # Varsayılan cihazda başlatmak için:
   flutter run

   # Windows masaüstü için:
   flutter run -d windows

   # Chrome üzerinde çalıştırmak için:
   flutter run -d chrome
   ```

---

## 🧪 Değerlendirme & Test Senaryoları

Yetkililerin geliştirilen işlevleri adım adım test edebilmesi için senaryolar aşağıda detaylandırılmıştır:

### 1️⃣ Senaryo: Notlar Modülü ve "Kaydet" Butonu
* **Adım 1:** Ana ekranda (`Bugün`) yer alan **Notlar** kartının sağ üstündeki **"Tümünü gör"** butonuna dokunun.
* **Adım 2:** Açılan `Notlar` listeleme ekranında **"Yazılı"** ve **"Tuval"** sekmelerini inceleyin.
* **Adım 3:** Sağ üstteki **`+` (Yeni Not)** butonuna veya ana ekrandaki **"+ Yeni not"** satırına dokunun.
* **Adım 4:** Açılan `Yeni Not` ekranında başlık alanına (turkuaz çerçeveli kutu) bir başlık, içerik alanına notunuzu yazın.
* **Adım 5:** Ekranın altındaki turkuaz-mavi gradyanlı **"Kaydet"** butonuna basın.
* **Beklenen Sonuç:** Not kaydedilir, anında `Notlar` listesine eklenir ve ana ekrandaki sayaç/liste reaktif olarak güncellenir.

---

### 2️⃣ Senaryo: D-Plan AI Asistanı & Hata Çözümleri
* **Adım 1:** Alt gezinme çubuğundan **"Asistan"** sekmesine geçin.
* **Adım 2:** Üst bardaki **"Bugün 10/15"** kota rozetini ve giriş alanının üstündeki **"Bu saat 2 hakkın kaldı"** bilgisini gözlemleyin.
* **Adım 3:** Yatay kaydırılabilir çiplerden **"📊 Günün analizini yap"** butonuna dokunun.
* **Beklenen Sonuçlar (Çözülen Hataların Doğrulanması):**
  - **Doğru Yanıt:** Asistan haftalık özet (`Weekly Recap`) yerine **bugünün gerçek verilerini** (1 Ekim, 2/3 tamamlanan görevler, 1 dk odak süresi vb.) analiz eder.
  - **Sızıntı Yok:** Ekrana hiçbir zaman `[SYSTEM/WEEKLY RECAP]...` gibi ham sistem direktifleri düşmez; sadece geçici *"✓ Veriler okunuyor..."* durum bilgisi gösterilir.
  - **Tekil Yanıt:** İstek kilidi sayesinde yanıt **kesinlikle 3 kez tekrarlanmaz**, tek ve net bir mesaj olarak ekrana gelir.
  - **Kota Güncellemesi:** İstek sonrası kota sayacı `Bugün 11/15` ve `Bu saat 1 hakkın kaldı` olarak anında güncellenir.
* **Adım 4:** Sağ üstteki yenileme (refresh) ikonuna basarak sohbeti sıfırlayabilirsiniz.

---

### 3️⃣ Senaryo: Alışkanlık Takibi & Kaydırarak Silme (Swipe-to-Delete)
* **Adım 1:** Alt gezinme çubuğundan **"Kitaplık"** sekmesine geçin.
* **Adım 2:** `PLANLA & ODAK` başlığı altındaki **"Alışkanlık Takibi"** satırına dokunun.
* **Adım 3:** Ekranın üstündeki yatay gün şeridini (`P 1` seçili) ve ilerleme kartını (`3 / 5 tamamlandı`, `%60`) inceleyin.
* **Adım 4:** Herhangi bir alışkanlık kartını (örneğin *"Sosyal Medya Detoksu"*) **sağdan sola doğru kaydırın**.
* **Beklenen Sonuçlar:**
  - Kırmızı silme alanı ve çöp kutusu ikonu eşliğinde kart listeden akıcı bir şekilde kaldırılır.
  - Kart üzerindeki üç noktaya tıklamaya gerek kalmadan **otomatik silme** gerçekleşir.
  - Üstteki özet kartı anında `3 / 4 tamamlandı` ve `%75` olarak yeniden hesaplanır.
  - Kitaplık ekranındaki alışkanlık sayısı ve ana ekrandaki Hızlı İstatistikler dairesel göstergesi anlık olarak güncellenir.
  - Ekranın altında çıkan SnackBar üzerinden **"Geri Al"** butonuna basıldığında silinen alışkanlık eski yerine geri yüklenir.

---

## 🏗️ Mimari ve Proje Yapısı

Proje, harici ağır bağımlılıklara gerek duymadan, Flutter'ın yerleşik reaktif durum yönetimi (`ChangeNotifier` + `ListenableBuilder`) prensipleriyle modüler olarak yapılandırılmıştır.

```
lib/
├── constants/
│   └── app_colors.dart          # Referans ekranlardan çıkarılan HSL/Hex renk paleti
├── models/
│   ├── chat_message.dart        # AI sohbet mesajı ve gönderici rolleri
│   ├── habit_model.dart         # Alışkanlık veri modeli (streak, renk, tamamlanma)
│   └── note_model.dart          # Not veri modeli
├── screens/
│   ├── assistant_screen.dart    # D-Plan AI sohbet ekranı (kota, çipler, mesajlaşma)
│   ├── calendar_screen.dart     # Takvim ekranı (aylık görünüm & gün planı)
│   ├── habits_screen.dart       # Alışkanlık takibi & Swipe-to-delete ekranı
│   ├── library_screen.dart      # Kitaplık ekranı (kategoriler & reaktif sayaçlar)
│   ├── main_scaffold.dart       # Yüzen dock gezinme çubuğu ve IndexedStack
│   ├── note_edit_screen.dart    # Yeni not oluşturma & Kaydet butonu
│   ├── notes_screen.dart        # Notlar listesi (Yazılı & Tuval sekmeleri)
│   └── today_screen.dart        # Bugün ana ekranı (Günün sözü, görevler, istatistikler)
├── services/
│   ├── ai_assistant_service.dart # AI asistanı istek kilidi, kota ve analiz motoru
│   ├── habits_service.dart      # Alışkanlıklar merkezi reaktif durum yönetimi
│   └── notes_service.dart       # Notlar merkezi reaktif durum yönetimi
├── widgets/
│   └── custom_bottom_nav_bar.dart # Özel yüzen kapsül navigasyon çubuğu
└── main.dart                    # Uygulama başlangıcı ve koyu tema yapılandırması
```

---

## 🎨 Tasarım Standartları & Uyumluluk

`Proje.md` dosyasında yer alan yönergelere eksiksiz sadık kalınmıştır:
- **Zemin & Kart Renkleri**: Gece mavisi arka plan (`#131927`), derin kart yüzeyleri (`#1B2337`), ince sınırlar (`#27334D`).
- **Aksanlar**: Turkuaz (`#38BDF8`), Mavi (`#2563EB`), Sarı/Amber (`#F59E0B`), Yeşil (`#22C55E`), Mor (`#A78BFA`).
- **Mikro Etkileşimler**: Aktif sekmelerde kapsül animasyonları, pürüzsüz kaydırmalar, durum rozetleri.

---

## 🛡️ Testler & Kalite Güvencesi

Projedeki tüm kritik akışlar birim ve widget testleri ile teminat altına alınmıştır (`test/widget_test.dart`):

| Test Senaryosu | Kapsam | Durum |
| :--- | :--- | :---: |
| **Smoke & Home Test** | Ana ekran bileşenlerinin eksiksiz çizilmesi |  PASSED |
| **Notlar & Kaydet Testi** | Tümünü Gör navigasyonu, yeni not yazımı, Kaydet butonu ve liste güncellemesi |  PASSED |
| **AI Asistanı Testi** | Günün analizi ayrımı, prompt sızıntısı olmaması, tekil cevap ve kota tüketimi |  PASSED |
| **Swipe-to-Delete Testi** | Alışkanlığın sağdan sola kaydırılarak silinmesi ve sayaçların otomatik düşmesi |  PASSED |

Çalıştırmak için:
```bash
flutter test
```
