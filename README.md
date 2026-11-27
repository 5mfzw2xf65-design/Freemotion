# FreeMotion iOS

GitHub Actions ile iPhone için imzasız IPA derlemesi.

## Platform
- Minimum desteklenen iOS: **16.0**
- Hedef cihaz: iPhone 11 ve daha yeni iPhone'lar
- Derleme: GitHub Actions macOS 26 runner ve üzerinde bulunan Xcode/iOS SDK
- Bundle ID: `com.freemotion.app`

Minimum iOS 16 seçimi, iOS 26 kullanan cihazı engellemez; uygulama iOS 16 ve üzerindeki sürümlerde çalışabilecek şekilde derlenir.

## IPA oluşturma
1. Depoda **Actions** sekmesini aç.
2. **Build unsigned iOS IPA** iş akışını seç.
3. **Run workflow** düğmesine bas. `main` dalına ilgili dosya değişiklikleri gönderildiğinde de otomatik çalışır.
4. İşlem tamamlanınca **Artifacts** bölümünden `FreeMotion-unsigned-ipa` dosyasını indir.

## iPhone'a yükleme
Üretilen IPA **imzasızdır**. iPhone'a yüklemeden önce AltStore veya Sideloadly gibi bir araçla kendi Apple hesabın üzerinden imzalaman gerekir. Bu GitHub Actions iş akışı Apple sertifikası ya da provisioning profile üretmez.

## Mevcut uygulama kapsamı
Bu sürüm fotoğraf seçme arayüzünü ve ComfyUI `/system_stats` bağlantı kontrolünü içerir. Wan 2.2 ile gerçek video üretimi henüz bağlanmış değildir; bunun için çalışan ComfyUI sunucusu, API workflow JSON'u ve node eşlemesi gerekir.
