import 'package:flutter/widgets.dart';
import 'cart_state.dart';

class CartScope extends InheritedNotifier<CartController> {
  const CartScope({
    super.key,
    required CartController notifier,
    required Widget child,
  }) : super(notifier: notifier, child: child);

  static CartController of(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<CartScope>();
    assert(scope != null, 'CartScope yukarda tanimli degil.');
    return scope!.notifier!;
  }
}