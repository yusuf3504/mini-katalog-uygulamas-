import 'package:flutter/widgets.dart';

class MainTabController extends ChangeNotifier {
  int _index = 0;
  int get index => _index;

  void setIndex(int i) {
    if (i == _index) return;
    _index = i;
    notifyListeners();
  }
}

class MainTabScope extends InheritedNotifier<MainTabController> {
  const MainTabScope({
    super.key,
    required MainTabController notifier,
    required Widget child,
  }) : super(notifier: notifier, child: child);

  static MainTabController of(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<MainTabScope>();
    assert(scope != null, 'MainTabScope yukarida tanimli degil.');
    return scope!.notifier!;
  }
}