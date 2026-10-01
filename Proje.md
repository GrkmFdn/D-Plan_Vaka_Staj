Flutter Projesi – Tasarım ve Geliştirme Talimatları

Bu projede mevcut çalışan bir Flutter uygulamasını temel alarak ilerleyeceğiz.

Projenin Amacı

Elimde halihazırda çalışan bir Flutter uygulaması bulunmaktadır. Bu uygulamanın mevcut ekranlarını ve tasarımını referans alarak projeyi geliştireceğiz.

İlk aşamada sana uygulamanın ana ekranlarına ait ekran görüntülerini sağlayacağım.

Bu ekran görüntülerini tasarım referansı olarak kabul etmeni istiyorum.

Temel Kural

Mevcut tasarımın mümkün olduğunca birebir korunması gerekiyor.

Ben açıkça istemediğim sürece:

- Tasarımı değiştirme.
- Renkleri değiştirme.
- Fontları değiştirme.
- Butonların görünümünü değiştirme.
- Kartların, listelerin veya bileşenlerin tasarımını değiştirme.
- Padding / margin / spacing değerlerini keyfi olarak değiştirme.
- Yeni UI bileşenleri ekleme.
- Mevcut bileşenleri farklı bir tasarım anlayışıyla yeniden oluşturma.
- Ekranın genel yerleşimini değiştirme.
- Responsive tasarım bahanesiyle mevcut görünümü değiştirme.
- Kullanıcı deneyimini kendi yorumuna göre değiştirme.

Ben istemediğim sürece mevcut tasarımda herhangi bir iyileştirme veya yeniden tasarım yapma.

---

Çalışma Şeklimiz

Projeyi aşamalı olarak geliştireceğiz.

Ben sana:

1. Öncelikle mevcut uygulamanın ana ekranlarının ekran görüntülerini göndereceğim.
2. Daha sonra hangi ekranın veya hangi bölümün değiştirileceğini söyleyeceğim.
3. Gerekli olduğunda yeni ekran görüntüleri veya tasarım referansları göndereceğim.
4. Hangi alanların interaktif hale getirileceğini açıkça belirteceğim.

Sen ise yalnızca belirttiğim kapsam içerisinde değişiklik yapacaksın.

---

Ekranların İlk Aşamada Ele Alınması

İlk gönderdiğim ekran görüntülerindeki ekranları:

- Görsel olarak analiz et.
- UI hiyerarşisini belirle.
- Kullanılan bileşenleri tespit et.
- Sayfadaki layout yapısını incele.
- Navigasyon ilişkilerini anlamaya çalış.
- Mevcut tasarım dilini tespit et.

Ancak ilk aşamada kendiliğinden herhangi bir değişiklik yapma.

Öncelikli amaç mevcut uygulamanın yapısını ve tasarımını doğru anlamaktır.

---

Etkileşim ve Fonksiyonellik

Uygulamanın bazı bölümleri mevcut durumda statik olabilir.

Ben sana örneğin:

"Bu buton çalışsın."

"Bu kart tıklanabilir olsun."

"Bu alan açılır menü olsun."

"Bu ekran diğer ekrana yönlendirsin."

"Buradaki liste veritabanından gelsin."

gibi spesifik talimatlar verdiğimde yalnızca ilgili alanı işlevsel hale getir.

Önemli

Bir alanı interaktif hale getirirken görsel tasarımını değiştirme.

Örneğin bir butonun işlevini eklerken:

- Butonun boyutunu değiştirme.
- Rengini değiştirme.
- Yazı tipini değiştirme.
- Konumunu değiştirme.
- Padding değerlerini gereksiz yere değiştirme.

Amaç:

Aynı UI + yeni fonksiyonellik

olmalıdır.

---

Mevcut Kod Yapısı

Projede mevcut kodları mümkün olduğunca koru.

Bir özelliği eklemek için mevcut kodu tamamen yeniden yazmak yerine öncelikle mevcut yapıya nasıl entegre edilebileceğini değerlendir.

Gereksiz refactor yapma.

Ben istemediğim sürece:

- Dosya yapısını değiştirme.
- Klasörleri yeniden düzenleme.
- State management yapısını değiştirme.
- Kullanılan paketleri değiştirme.
- Flutter/Dart sürümünü değiştirme.
- Mimariyi değiştirme.
  Çalışan kodları yeniden yazma.

Mevcut yapı içerisinde en küçük ve güvenli değişiklikle ilerle.

---

Kod Yazarken

Kod üretirken:

- Flutter ve Dart best practice'lerini kullan.
- Null safety kurallarına uy.
- Mevcut proje yapısına uyum sağla.
- Mevcut naming convention'ı koru.
- Gereksiz dependency ekleme.
- Aynı işi yapan yeni bir yapı oluşturma.
- Mevcut bir widget veya utility kullanılabiliyorsa tekrar oluşturma.
- Hata durumlarını dikkate al.
- Mevcut çalışan özellikleri bozma.

---

Değişiklik Yapmadan Önce

Bir geliştirme istediğimde öncelikle mevcut kodu ve ilgili ekranı incele.

Değişiklik yapmadan önce:

1. İlgili dosyaları belirle.
2. Mevcut yapının nasıl çalıştığını anla.
3. Değişikliğin mevcut özellikleri etkileyip etkilemeyeceğini kontrol et.
4. Gerekli minimum dosyalarda değişiklik yap.
5. Tasarımın mevcut halini koru.

Eğer istediğim özellik mevcut yapı ile çelişiyorsa veya belirsizse, kendi kararını vererek büyük bir değişiklik yapmak yerine bunu bana bildir.

---

asarım Önceliği

Bu projede tasarım konusunda temel öncelik:

Referans ekran görüntüsü > mevcut tasarım > benim açık talimatım

Ben belirli bir alan için yeni bir tasarım istediğimde yalnızca o alanı değiştir.

Diğer tüm alanlar mevcut haliyle korunmalıdır.

---

Genel Çalışma Prensibi

Bu projede senden beklediğim yaklaşım:

Analiz et → Mevcut yapıyı anla → Benim talimatımı uygula → Minimum değişiklik yap → Mevcut tasarımı ve çalışan özellikleri koru

Kendi başına yeni özellik, yeni ekran veya yeni tasarım ekleme.

Ben hangi ekranın veya hangi bölümün geliştirileceğini adım adım belirleyeceğim.

Her aşamada yalnızca belirttiğim kapsam üzerinde çalış.
