import 'package:flutter/material.dart';
import '../state/cart_scope.dart';
import '../utils/top_banner.dart';
import '../pages/product_detail_page.dart';

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    final cart = CartScope.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text("Sepetim")),
      body: AnimatedBuilder(
        animation: cart,
        builder: (context, _) {
          final items = cart.items;

          if (items.isEmpty) {
            return const Center(child: Text("Sepetiniz boş"));
          }

          return ListView.separated(
            padding: const EdgeInsets.fromLTRB(12, 8, 12, 130),
            itemCount: items.length,
            separatorBuilder: (_, __) => const SizedBox(height: 10),
            itemBuilder: (context, index) {
              final item = items[index];
              final p = item.product;

              return Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.06),
                      blurRadius: 8,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Checkbox(
                      value: item.selected,
                      onChanged: (v) => cart.setSelected(p.id, v ?? false),
                    ),

                    GestureDetector(
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => ProductDetailPage(product: p)),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: p.thumbnail.startsWith("http")
                            ? Image.network(
                                p.thumbnail,
                                width: 70,
                                height: 70,
                                fit: BoxFit.cover,
                              )
                            : Image.asset(
                                p.thumbnail,
                                width: 70,
                                height: 70,
                                fit: BoxFit.cover,
                              ),
                      ),
                    ),

                    const SizedBox(width: 12),

                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // ÜRÜN ADI
                          Text(
                            p.title,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                            ),
                          ),

                          const SizedBox(height: 10),

                          // ALT SATIR: ADET + SİL + FİYAT
                          Row(
                            children: [
                              _QtyBtn(
                                  icon: Icons.remove,
                                  onTap: () => cart.decrement(p.id)),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8),
                                child: Text(
                                  "${item.qty}",
                                  style: const TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.orange,
                                  ),
                                ),
                              ),
                              _QtyBtn(
                                  icon: Icons.add,
                                  onTap: () => cart.increment(p.id)),
                              const SizedBox(width: 8),
                              GestureDetector(
                                onTap: () => cart.remove(p.id),
                                child: Row(
                                  children: const [
                                    Icon(Icons.delete_outline,
                                        color: Colors.blue),
                                    SizedBox(width: 4),
                                  ],
                                ),
                              ),
                              const Spacer(),
                              Text(
                                "${item.lineTotal.toStringAsFixed(2)} TL",
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.orange,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
      bottomNavigationBar: _bottomSummary(context),
    );
  }
}

// ---- ALT ÖZET ALANI ----
Widget _bottomSummary(BuildContext context) {
  final cart = CartScope.of(context);
  final selected = cart.selectedItems;

  return SafeArea(
    child: Container(
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black .withOpacity(0.08),
            blurRadius: 10,
            offset: const Offset(0, -3),
          )
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ExpansionTile(
            title: Text(
              "Sipariş Detayı (${selected.length} seçili)",
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
            children: selected
                .map(
                  (e) => Padding(
                    padding: const EdgeInsets.only(bottom: 4),
                    child: Row(
                      children: [
                        const Icon(Icons.check_circle,
                            size: 16, color: Colors.green),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            "${e.qty} × ${e.product.title} — ${e.lineTotal.toStringAsFixed(2)} TL",
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(fontSize: 13),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
                .toList(),
          ),
          const Divider(height: 18),
          Row(
            children: [
              const Expanded(
                child: Text(
                  "Toplam (seçili)",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
              ),
              Text(
                "${cart.selectedTotal.toStringAsFixed(2)} TL",
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: selected.isEmpty
                      ? null
                      : () {
                          cart.checkoutSelected();
                          TopBanner.show(
                            context,
                            "Siparişiniz alındı 🎉",
                            extraTopMargin: 12,
                          );
                          Navigator.pop(context);
                        },
                  child: const Text("Siparişi Tamamla"),
                ),
              ),
              const SizedBox(width: 10),
              IconButton(
                icon: const Icon(Icons.delete_sweep_outlined),
                onPressed: cart.items.isEmpty ? null : cart.clear,
              )
            ],
          )
        ],
      ),
    ),
  );
}

// ---- küçük adet butonu ----
class _QtyBtn extends StatelessWidget {
  const _QtyBtn({required this.icon, required this.onTap});
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(6),
      child: Ink(
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: const Color(0xFFF3F5FA),
          borderRadius: BorderRadius.circular(6),
        ),
        child: Icon(icon, size: 18, color: Colors.orange),
      ),
    );
  }
}
