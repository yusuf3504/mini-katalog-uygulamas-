# 📱 Mini Katalog Uygulaması

Merhaba, ben Yusuf. Bu proje Flutter kullanarak geliştirdiğim basit bir katalog ve sepet uygulamasıdır.  
Uygulamanın amacı ürünleri listelemek, detaylarını görmek ve sepete ekleyip sipariş oluşturabilmektir.

## 🚀 Özellikler
Bu uygulamada aşağıdaki özellikler bulunur:

- Ürün listeleme (JSON simülasyonu üzerinden)
- GridView tabanlı ürün kartları
- Ürün detay sayfası
- Favori ekleme/çıkarma simülasyonu
- Sepet sistemi simülasyonu
- Material tasarım bileşenleri
- Navigator ile sayfa geçişleri
- Model sınıfları ile veri yönetimi

## 🛠 Kullanılan Teknolojiler
- Flutter SDK
- Dart
- Material Design widget’ları
- fiziksel Android cihaz kullandım
- Visual Studio Code

## Ekran Görüntüleri
Aşağıda uygulamadan bazı ekran görüntüleri yer almaktadır:

![017755de-3d3e-4fde-a49b-02017b84b009](https://github.com/user-attachments/assets/ceeb17fc-d4ad-4eb4-a8f5-747f46a7ea29)
![1efa4f64-2747-4f25-b4fa-d737be7641c9](https://github.com/user-attachments/assets/5cf97eaf-2a72-4714-931c-46ad0a8a3bb7)
![6a858302-30ae-4d26-a985-6e44acfe34cf](https://github.com/user-attachments/assets/0d2fff8e-a28b-4659-84a3-60de6096c15c)
![809468c0-4431-4908-985d-ec3494c97ce6](https://github.com/user-attachments/assets/f78cae98-0eaa-4acf-8be2-2afa9a30d3ac)
![062329d7-ca4f-4523-b4be-c9f247f869ae](https://github.com/user-attachments/assets/d7ecc143-cbe0-41d5-9fa9-91cbf351d077)
![aee8752c-eb8d-4c1d-b0b5-e41d064ba205](https://github.com/user-attachments/assets/bd3a036d-7bd0-4362-96f7-b01378095df0)


## Proje Klasör Yapısı
Projede ekran görüntüsünde görülen klasör düzeni aşağıdaki gibidir:
lib/
 ├── data/
 │     └── products.json
 ├── models/
 │     └── product.dart
 ├── pages/
 │     ├── cart_page.dart
 │     ├── account_page.dart
 │     ├── favorites_page.dart
 │     ├── product_list_page.dart
 │     ├── product_detail_page.dart
 │     └── main_shell.dart
 ├── providers/
 │     ├── cart_scope.dart
 │     └── favorite_state_provider.dart
 ├── utils/
 │     └── top_banner.dart
 ├── widgets/
 │     └── product_card.dart
 └── main.dart

 
## ⚙️ Kurulum
Projeyi kendi bilgisayarında çalıştırmak için:

1. Repo’yu klonla:
   ```bash
   git clone https://github.com/yusuf3504/mini-katalog-uygulamas-.git
2. proje klösörüne gir: 
cd mini-katalog-uygulamas-

3. Bağımlılıkları yükle:
flutter pub get

4. Uygulamayı çalıştır:
flutter run
