import 'package:flutter/material.dart';

import 'pages/main_shell.dart';

import 'state/cart_state.dart';
import 'state/cart_scope.dart';

import 'state/main_tab_scope.dart';
import 'state/favorites_state.dart';

import 'state/profile_state.dart'; 

void main() {
  runApp(const MiniKatalogApp());
}

class MiniKatalogApp extends StatelessWidget {
  const MiniKatalogApp({super.key});

  @override
  Widget build(BuildContext context) {
    final cart = CartController();
    final tabs = MainTabController();
    final favs = FavoritesController();
    final profile = ProfileController(); 

    return CartScope(
      notifier: cart,
      child: MainTabScope(
        notifier: tabs,
        child: FavoritesScope(
          notifier: favs,
          child: ProfileScope(
            notifier: profile,
            child: MaterialApp(
              title: 'Mini Katalog',
              theme: ThemeData(
                colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
                useMaterial3: true,
                scaffoldBackgroundColor: const Color(0xFFF6F7FB),
                appBarTheme: const AppBarTheme(centerTitle: false),
              ),
              home: const MainShell(),
              debugShowCheckedModeBanner: false,
            ),
          ),
        ),
      ),
    );
  }
}