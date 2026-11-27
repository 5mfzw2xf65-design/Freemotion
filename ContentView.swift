import SwiftUI
import PhotosUI

struct ContentView: View {
    @State private var photoItem: PhotosPickerItem?
    @State private var selectedImage: UIImage?
    @State private var prompt = ""
    @State private var serverURL = ""
    @State private var connectionMessage = "Sunucu adresini girerek bağlantıyı kontrol et."
    @State private var isChecking = false

    private let accent = Color(red: 0.45, green: 0.82, blue: 0.72)

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    header

                    PhotosPicker(selection: $photoItem, matching: .images) {
                        photoPickerCard
                    }
                    .onChange(of: photoItem) { _, item in
                        Task { await loadImage(from: item) }
                    }

                    VStack(alignment: .leading, spacing: 9) {
                        sectionLabel("HAREKET AÇIKLAMASI")
                        TextField("Örn. Kamera yavaşça yaklaşsın, doğal hareket...", text: $prompt, axis: .vertical)
                            .lineLimit(3...5)
                            .padding(14)
                            .background(Color.white.opacity(0.06), in: RoundedRectangle(cornerRadius: 15))
                    }

                    VStack(alignment: .leading, spacing: 9) {
                        sectionLabel("COMFYUI SUNUCU ADRESİ")
                        TextField("https://sunucu-adresin", text: $serverURL)
                            .textInputAutocapitalization(.never)
                            .keyboardType(.URL)
                            .autocorrectionDisabled()
                            .padding(14)
                            .background(Color.white.opacity(0.06), in: RoundedRectangle(cornerRadius: 15))

                        Button {
                            Task { await checkConnection() }
                        } label: {
                            HStack {
                                if isChecking { ProgressView().tint(.black) }
                                Text(isChecking ? "Kontrol ediliyor..." : "Bağlantıyı test et")
                            }
                            .fontWeight(.semibold)
                            .frame(maxWidth: .infinity)
                            .padding(14)
                            .foregroundStyle(.black)
                            .background(accent, in: RoundedRectangle(cornerRadius: 15))
                        }
                        .disabled(isChecking || serverURL.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)

                        Text(connectionMessage)
                            .font(.footnote)
                            .foregroundStyle(.secondary)
                    }

                    Text("Bu derleme, iOS arayüzünü ve ComfyUI sağlık kontrolünü içerir. Wan 2.2 üretim düğmesi, doğrulanmış API workflow ve node eşlemesi bağlandıktan sonra etkinleştirilecektir.")
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                        .padding(14)
                        .background(Color.white.opacity(0.045), in: RoundedRectangle(cornerRadius: 14))
                }
                .padding(20)
            }
            .background(Color(red: 0.035, green: 0.045, blue: 0.065).ignoresSafeArea())
            .toolbar(.hidden, for: .navigationBar)
        }
    }

    private var header: some View {
        VStack(alignment: .leading, spacing: 7) {
            HStack {
                Text("FREEMOTION")
                    .font(.system(size: 12, weight: .bold, design: .rounded))
                    .tracking(3)
                    .foregroundStyle(accent)
                Spacer()
                Text("BETA")
                    .font(.system(size: 10, weight: .bold))
                    .padding(.horizontal, 9)
                    .padding(.vertical, 5)
                    .background(accent.opacity(0.15), in: Capsule())
                    .foregroundStyle(accent)
            }
            Text("Fotoğrafını
hareketlendir.")
                .font(.system(size: 34, weight: .bold, design: .rounded))
                .lineSpacing(1)
            Text("Kendi model sunucuna bağlan.")
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
    }

    private var photoPickerCard: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.white.opacity(0.055))
                .overlay(RoundedRectangle(cornerRadius: 20).strokeBorder(Color.white.opacity(0.1), style: StrokeStyle(lineWidth: 1, dash: [6, 5])))
            if let selectedImage {
                Image(uiImage: selectedImage)
                    .resizable()
                    .scaledToFit()
                    .frame(maxHeight: 260)
                    .clipShape(RoundedRectangle(cornerRadius: 15))
                    .padding(10)
            } else {
                VStack(spacing: 10) {
                    Image(systemName: "photo.badge.plus")
                        .font(.system(size: 32))
                        .foregroundStyle(accent)
                    Text("Fotoğraf seç")
                        .fontWeight(.semibold)
                    Text("JPG · PNG · HEIC")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                .padding(.vertical, 35)
            }
        }
        .frame(maxWidth: .infinity)
        .frame(minHeight: 175)
    }

    private func sectionLabel(_ value: String) -> some View {
        Text(value)
            .font(.system(size: 10, weight: .bold))
            .tracking(1.5)
            .foregroundStyle(accent)
    }

    @MainActor
    private func loadImage(from item: PhotosPickerItem?) async {
        guard let item,
              let data = try? await item.loadTransferable(type: Data.self),
              let image = UIImage(data: data) else { return }
        selectedImage = image
    }

    @MainActor
    private func checkConnection() async {
        guard let base = URL(string: serverURL.trimmingCharacters(in: .whitespacesAndNewlines)),
              let url = URL(string: "/system_stats", relativeTo: base) else {
            connectionMessage = "Geçerli bir HTTPS sunucu adresi gir."
            return
        }

        isChecking = true
        defer { isChecking = false }

        do {
            var request = URLRequest(url: url)
            request.timeoutInterval = 12
            let (_, response) = try await URLSession.shared.data(for: request)
            guard let http = response as? HTTPURLResponse else {
                connectionMessage = "Sunucudan geçerli yanıt alınamadı."
                return
            }
            connectionMessage = (200..<300).contains(http.statusCode)
                ? "Bağlantı başarılı. ComfyUI API yanıt veriyor."
                : "Sunucu yanıt verdi ancak HTTP \(http.statusCode) döndürdü."
        } catch {
            connectionMessage = "Bağlantı kurulamadı: \(error.localizedDescription)"
        }
    }
}
