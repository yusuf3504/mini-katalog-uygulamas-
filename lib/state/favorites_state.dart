import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import '../models/product.dart';

class FavoritesController extends ChangeNotifier {
  final Map<int, Product> _map = {}; 

  List<Product> get items => _map.values.toList(growable: false);
  bool isFav(int productId) => _map.containsKey(productId);

  void toggle(Product p) {
    if (_map.containsKey(p.id)) {
      _map.remove(p.id);
    } else {
      _map[p.id] = p;
    }
    notifyListeners();
  }

  void remove(int productId) {
    _map.remove(productId);
    notifyListeners();
  }

  void clear() {
    _map.clear();
    notifyListeners();
  }
}

class FavoritesScope extends InheritedNotifier<FavoritesController> {
  const FavoritesScope({
    Key? key,
    required FavoritesController notifier,
    required Widget child,
  }) : super(key: key, notifier: notifier, child: child);

  static FavoritesController of(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<FavoritesScope>();
    assert(scope != null, 'FavoritesScope yukarida tanimli degil.');
    return scope!.notifier!;
  }
}
