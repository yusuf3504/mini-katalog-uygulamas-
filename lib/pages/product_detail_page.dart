import 'package:flutter/material.dart';
import '../models/product.dart';
import '../state/favorites_state.dart';
import '../state/cart_scope.dart';
import '../utils/top_banner.dart';

class ProductDetailPage extends StatelessWidget {
  const ProductDetailPage({super.key, required this.product});

  final Product product;

  @override
  Widget build(BuildContext context) {
    final favs = FavoritesScope.of(context);
    final cart = CartScope.of(context);
    final isFav = favs.isFav(product.id);
    final priceText = "${product.price.toStringAsFixed(2)} TL";

    void toggleFav() {
      favs.toggle(product);
      TopBanner.show(
        context,
        isFav ? 'Favorilerden çıkarıldı' : 'Favorilere eklendi',
        extraTopMargin: 12,
        duration: const Duration(milliseconds: 900),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(product.title, maxLines: 1, overflow: TextOverflow.ellipsis),
      ),

      body: ListView(
        padding: const EdgeInsets.only(bottom: 100),
        children: [
          AspectRatio(
            aspectRatio: 1.2,
            child: Stack(
              children: [
                Positioned.fill(
                  child: GestureDetector(
                    onDoubleTap: toggleFav, 
                    child: (product.thumbnail.startsWith('http'))
                        ? Image.network(
                            product.thumbnail,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) =>
                                const Center(child: Icon(Icons.broken_image, size: 48)),
                            loadingBuilder: (context, child, progress) {
                              if (progress == null) return child;
                              return const Center(child: CircularProgressIndicator());
                            },
                          )
                        : Image.asset(product.thumbnail, fit: BoxFit.cover),
                  ),
                ),
                Positioned(
                  right: 3,
                  top: 3,
                  child: Material(
                    color: Colors.white.withOpacity(0.9),
                    shape: const CircleBorder(),
                    child: InkWell(
                      customBorder: const CircleBorder(),
                      onTap: toggleFav, 
                      child: const Padding(
                        padding: EdgeInsets.all(3), 
                        child: Icon(
                          Icons.favorite_border,
                          size: 22,
                          color: Colors.transparent,
                        ),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  right: 3,
                  top: 3,
                  child: IgnorePointer(
                    ignoring: true,
                    child: Container(
                      padding: const EdgeInsets.all(3),
                      decoration: const BoxDecoration(shape: BoxShape.circle),
                      child: Icon(
                        isFav ? Icons.favorite : Icons.favorite_border,
                        color: isFav ? Colors.red : Colors.black54,
                        size: 22,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 6),
            child: Text(
              product.title,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
            child: Text(
              priceText,
              style: const TextStyle(
                color: Colors.blueAccent,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          // --- AÇIKLAMA ---
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              product.description,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),

      bottomNavigationBar: SafeArea(
        top: false,
        child: Container(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.06),
                blurRadius: 10,
                offset: const Offset(0, -4),
              ),
            ],
          ),
          child: SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              icon: const Icon(Icons.add_shopping_cart),
              label: const Text("Sepete Ekle"),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 14),
                textStyle: const TextStyle(fontWeight: FontWeight.w600),
              ),
              onPressed: () {
                cart.add(product);
                TopBanner.show(context, '${product.title} sepete eklendi',
                    extraTopMargin: 12, duration: const Duration(milliseconds: 1200));
              },
            ),
          ),
        ),
      ),
    );
  }
}