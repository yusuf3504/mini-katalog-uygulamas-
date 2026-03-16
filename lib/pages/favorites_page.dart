import 'package:flutter/material.dart';
import '../state/favorites_state.dart';
import '../state/cart_scope.dart';
import '../utils/top_banner.dart';
import '../pages/product_detail_page.dart';

class FavoritesPage extends StatelessWidget {
  const FavoritesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final favs = FavoritesScope.of(context);
    final cart = CartScope.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Favorilerim')),
      body: AnimatedBuilder(
        animation: favs,
        builder: (context, _) {
          final items = favs.items;
          if (items.isEmpty) {
            return const Center(child: Text('Favoriniz yok'));
          }

          return ListView.separated(
            padding: const EdgeInsets.fromLTRB(12, 8, 12, 120),
            itemCount: items.length,
            separatorBuilder: (_, __) => const SizedBox(height: 10),
            itemBuilder: (context, i) {
              final p = items[i];
              return Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: ListTile(
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => ProductDetailPage(product: p)),
                  ),
                  contentPadding: const EdgeInsets.all(12),
                  leading: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: (p.thumbnail.startsWith('http'))
                        ? Image.network(p.thumbnail, width: 56, height: 56, fit: BoxFit.cover)
                        : Image.asset(p.thumbnail, width: 56, height: 56, fit: BoxFit.cover),
                  ),
                  title: Text(
                    p.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  subtitle: Text(
                    '${p.price.toStringAsFixed(2)} TL',
                    style: const TextStyle(color: Colors.blueAccent, fontWeight: FontWeight.bold),
                  ),
                  trailing: Wrap(
                    spacing: 6,
                    children: [
                      IconButton(
                        tooltip: 'Favoriden kaldır',
                        icon: const Icon(Icons.favorite, color: Colors.red),
                        onPressed: () => favs.toggle(p),
                      ),
                      IconButton(
                        tooltip: 'Sepete ekle',
                        icon: const Icon(Icons.add_shopping_cart_outlined),
                        onPressed: () {
                          cart.add(p);
                          TopBanner.show(context, '${p.title} sepete eklendi', extraTopMargin: 12);
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}