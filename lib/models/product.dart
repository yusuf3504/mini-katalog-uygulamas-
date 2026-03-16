class Product {
  final int id;
  final String title;
  final double price;
  final String thumbnail;
  final String description;

  Product({
    required this.id,
    required this.title,
    required this.price,
    required this.thumbnail,
    required this.description,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    // API bazen farklı isimlerle dönebilir: name/title, image/thumbnail, desc/description, price/price_text vs.
    final dynamic idRaw = json['id'] ?? json['product_id'] ?? 0;
    final dynamic titleRaw = json['title'] ?? json['name'] ?? 'Ürün';
    final dynamic priceRaw = json['price'] ?? json['unit_price'] ?? json['price_text'] ?? 0;
    final dynamic thumbRaw = json['thumbnail'] ?? json['image'] ?? json['img'] ?? '';
    final dynamic descRaw = json['description'] ?? json['desc'] ?? '';

    double parsePrice(dynamic v) {
      if (v is num) return v.toDouble();
      if (v is String) {
        final cleaned = v.replaceAll(RegExp(r'[^0-9\.,]'), '').replaceAll(',', '.');
        return double.tryParse(cleaned) ?? 0.0;
      }
      return 0.0;
    }

    return Product(
      id: (idRaw is int) ? idRaw : int.tryParse('$idRaw') ?? 0,
      title: '$titleRaw',
      price: parsePrice(priceRaw),
      thumbnail: '$thumbRaw',
      description: '$descRaw',
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'price': price,
        'thumbnail': thumbnail,
        'description': description,
      };
}