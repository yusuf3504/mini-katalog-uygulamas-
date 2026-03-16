import 'package:flutter/material.dart';
import '../state/main_tab_scope.dart';
import 'product_list_page.dart';
import 'favorites_page.dart';
import 'cart_page.dart';
import 'account_page.dart';

class MainShell extends StatelessWidget {
  const MainShell({super.key});

  @override
  Widget build(BuildContext context) {
    final tabs = MainTabScope.of(context);

    return AnimatedBuilder(
      animation: tabs,
      builder: (context, _) {
        return Scaffold(
          body: IndexedStack(
            index: tabs.index,
            children: const [
              ProductListPage(), // 0: Ana Sayfa
              FavoritesPage(),   // 1: Favoriler
              CartPage(),        // 2: Sepetim
              AccountPage(),     // 3: Hesabım
            ],
          ),

          bottomNavigationBar: SafeArea(
            top: false,
            child: NavigationBar(
              selectedIndex: tabs.index,
              onDestinationSelected: tabs.setIndex,
              destinations: const [
                NavigationDestination(icon: Icon(Icons.home_outlined), selectedIcon: Icon(Icons.home), label: 'Ana Sayfa'),
                NavigationDestination(icon: Icon(Icons.favorite_border), selectedIcon: Icon(Icons.favorite), label: 'Favoriler'),
                NavigationDestination(icon: Icon(Icons.shopping_cart_outlined), selectedIcon: Icon(Icons.shopping_cart), label: 'Sepetim'),
                NavigationDestination(icon: Icon(Icons.person_outline), selectedIcon: Icon(Icons.person), label: 'Hesabım'),
              ],
            ),
          ),
        );
      },
    );
  }
}