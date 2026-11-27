# FreeMotion iOS — GitHub Actions IPA build

Bu paket, FreeMotion için GitHub Actions üzerinde macOS runner kullanarak **imzasız IPA** üretir.

## Kurulum
1. GitHub'da mevcut FreeMotion deponu aç.
2. Bu ZIP'i çıkarıp içindeki dosyaları deponun kök dizinine yükle (mevcut dosyaların üzerine yazmadan; çakışan dosyaları önce kontrol et).
3. `Actions` sekmesine gir.
4. `Build unsigned iOS IPA` iş akışını seçip `Run workflow` düğmesine bas.
5. İş tamamlanınca çalışmanın altındaki `Artifacts` bölümünden `FreeMotion-unsigned-ipa` dosyasını indir.

## Önemli
- Bu çıktı **unsigned IPA** olacaktır. GitHub Actions, Apple hesabının sertifikası/provisioning profili olmadan uygulamayı imzalamaz.
- iPhone'a yüklemek için IPA'yı AltStore/Sideloadly gibi bir araçla kendi Apple hesabın üzerinden imzalaman gerekir.
- Bu paket uygulamanın iOS kabuğunu ve ComfyUI bağlantı kontrolünü içerir. Wan 2.2 üretimi için gerçek ComfyUI API workflow JSON'u ve node eşlemesi ayrıca bağlanmalıdır; bu paket tek başına video üretim sunucusu sağlamaz.
- Mevcut depondaki dosyaları silme veya tüm depoyu bu paketle değiştirme. Sadece gerekli yeni/düzeltilmiş dosyaları ekle.
