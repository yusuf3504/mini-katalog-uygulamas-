import 'package:flutter/foundation.dart';
import '../models/product.dart';

class CartItem {
  final Product product;
  int qty;
  bool selected; 

  CartItem({
    required this.product,
    this.qty = 1,
    this.selected = true, 
  });

  double get lineTotal => product.price * qty;
}

class CartController extends ChangeNotifier {
  final Map<int, CartItem> _items = {}; 

  List<CartItem> get items => _items.values.toList(growable: false);
  List<CartItem> get selectedItems =>
      _items.values.where((e) => e.selected).toList(growable: false);

  int get totalItems => _items.values.fold(0, (sum, e) => sum + e.qty);
  double get totalPrice => _items.values.fold(0.0, (sum, e) => sum + e.lineTotal);

  //  sadece seçili ürünlerin toplamı
  double get selectedTotal =>
      _items.values.where((e) => e.selected).fold(0.0, (s, e) => s + e.lineTotal);

  void add(Product p, {int qty = 1}) {
    final existing = _items[p.id];
    if (existing != null) {
      existing.qty += qty;
      existing.selected = true; 
    } else {
      _items[p.id] = CartItem(product: p, qty: qty, selected: true);
    }
    notifyListeners();
  }

  void setQty(int productId, int qty) {
    final item = _items[productId];
    if (item == null) return;
    item.qty = qty < 1 ? 1 : qty;
    notifyListeners();
  }

  void increment(int productId) {
    final item = _items[productId];
    if (item == null) return;
    item.qty += 1;
    notifyListeners();
  }

  void decrement(int productId) {
    final item = _items[productId];
    if (item == null) return;
    item.qty = (item.qty > 1) ? item.qty - 1 : 1;
    notifyListeners();
  }

  void remove(int productId) {
    _items.remove(productId);
    notifyListeners();
  }

  void clear() {
    _items.clear();
    notifyListeners();
  }

  //  seçme / seçimi kaldırma
  void toggleSelected(int productId) {
    final item = _items[productId];
    if (item == null) return;
    item.selected = !item.selected;
    notifyListeners();
  }

  void setSelected(int productId, bool value) {
    final item = _items[productId];
    if (item == null) return;
    item.selected = value;
    notifyListeners();
  }

  List<CartItem> checkoutSelected() {
    final purchased = selectedItems.toList(growable: false);
    _items.removeWhere((_, v) => v.selected);
    notifyListeners();
    return purchased;
  }
}