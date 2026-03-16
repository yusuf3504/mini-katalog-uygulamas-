import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../models/product.dart';
import '../widgets/product_card.dart';
import '../pages/product_detail_page.dart';

import '../state/cart_scope.dart';
import '../state/favorites_state.dart';
import '../utils/top_banner.dart';

enum SortMode { none, priceAsc, priceDesc }

class ProductListPage extends StatefulWidget {
  const ProductListPage({super.key});

  @override
  State<ProductListPage> createState() => _ProductListPageState();
}

class _ProductListPageState extends State<ProductListPage> {
  late Future<void> _futureInit;
  final TextEditingController _searchCtl = TextEditingController();

  List<Product> _all = [];
  List<Product> _filtered = [];
  String _query = '';
  double? _minPrice;
  double? _maxPrice;
  SortMode _sort = SortMode.none;

  bool _showBanner = true;
  static const String _bannerUrl = 'https://wantapi.com/assets/banner.png'; 

  @override
  void initState() {
    super.initState();
    _futureInit = _load();
  }

  Future<void> _load() async {
    final uri = Uri.parse('https://wantapi.com/products.php');
    final resp = await http.get(uri).timeout(const Duration(seconds: 20));
    if (resp.statusCode != 200) {
      throw Exception('Sunucu hatası: ${resp.statusCode}');
    }
    final decoded = json.decode(resp.body.trim());
    List<dynamic> list;
    if (decoded is List) {
      list = decoded;
    } else if (decoded is Map<String, dynamic>) {
      list = (decoded['data'] ?? decoded['products'] ?? decoded['items'] ?? []) as List<dynamic>;
    } else {
      list = const [];
    }
    _all = list.map((e) => Product.fromJson(e as Map<String, dynamic>)).toList(growable: false);
    _applyFilters();
  }

  void _applyFilters() {
    var out = _all;

   
    final q = _query.trim().toLowerCase();
    if (q.isNotEmpty) {
      out = out
          .where((p) =>
              p.title.toLowerCase().contains(q) ||
              p.description.toLowerCase().contains(q))
          .toList(growable: false);
    }

    
    if (_minPrice != null) {
      out = out.where((p) => p.price >= _minPrice!).toList(growable: false);
    }
    if (_maxPrice != null) {
      out = out.where((p) => p.price <= _maxPrice!).toList(growable: false);
    }

    
    switch (_sort) {
      case SortMode.priceAsc:
        out.sort((a, b) => a.price.compareTo(b.price));
        break;
      case SortMode.priceDesc:
        out.sort((a, b) => b.price.compareTo(a.price));
        break;
      case SortMode.none:
        break;
    }

    setState(() => _filtered = out);
  }

  Future<void> _openFilterSheet() async {
    final minCtl = TextEditingController(text: _minPrice?.toStringAsFixed(0) ?? '');
    final maxCtl = TextEditingController(text: _maxPrice?.toStringAsFixed(0) ?? '');
    SortMode localSort = _sort;

    await showModalBottomSheet(
      context: context,
      isScrollControlled: true, 
      showDragHandle: true,
      builder: (sheetContext) {
        return StatefulBuilder(
          builder: (ctx, setSheetState) {
            final bottomInset = MediaQuery.of(ctx).viewInsets.bottom;
            return SafeArea(
              top: false,
              child: AnimatedPadding(
                duration: const Duration(milliseconds: 150),
                padding: EdgeInsets.only(bottom: bottomInset),
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Filtrele & Sırala',
                            style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
                          ),
                        ),
                        const SizedBox(height: 12),

                      
                        Row(
                          children: [
                            Expanded(
                              child: TextField(
                                controller: minCtl,
                                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                                decoration: const InputDecoration(
                                  labelText: 'Min ₺',
                                  border: OutlineInputBorder(),
                                  isDense: true,
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: TextField(
                                controller: maxCtl,
                                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                                decoration: const InputDecoration(
                                  labelText: 'Max ₺',
                                  border: OutlineInputBorder(),
                                  isDense: true,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 14),

                        
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('Sırala', style: TextStyle(fontWeight: FontWeight.w600)),
                              const SizedBox(height: 8),
                              SegmentedButton<SortMode>(
                                segments: const [
                                  ButtonSegment(
                                    value: SortMode.none,
                                    label: Text('Sırasız'),
                                    icon: Icon(Icons.remove),
                                  ),
                                  ButtonSegment(
                                    value: SortMode.priceAsc,
                                    label: Text('Fiyat ↑'),
                                    icon: Icon(Icons.arrow_upward),
                                  ),
                                  ButtonSegment(
                                    value: SortMode.priceDesc,
                                    label: Text('Fiyat ↓'),
                                    icon: Icon(Icons.arrow_downward),
                                  ),
                                ],
                                selected: {localSort},
                                onSelectionChanged: (s) => setSheetState(() => localSort = s.first),
                              ),
                             
                            ],
                          ),
                        ),

                        const SizedBox(height: 16),

                        Row(
                          children: [
                            TextButton(
                              onPressed: () {
                                minCtl.clear();
                                maxCtl.clear();
                                setSheetState(() => localSort = SortMode.none);
                              },
                              child: const Text('Temizle'),
                            ),
                            const Spacer(),
                            ElevatedButton(
                              onPressed: () {
                                _minPrice = double.tryParse(minCtl.text.replaceAll(',', '.'));
                                _maxPrice = double.tryParse(maxCtl.text.replaceAll(',', '.'));
                                _sort = localSort;
                                Navigator.pop(ctx);
                                _applyFilters();
                              },
                              child: const Text('Uygula'),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  void dispose() {
    _searchCtl.dispose();
    super.dispose();
  }

  Widget _buildTopBanner(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 12, 12, 4),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Stack(
          children: [
            _NetworkBanner(
              url: _bannerUrl,
              fallbackAspectRatio: 16 / 6,
              backgroundColor: const Color(0xFFECEFF5),
            ),

            Positioned(
              left: 14,
              bottom: 12,
              right: 52, 
              child: Row(
                children: [
                  const Expanded(
                    child: Text(
                      'Mini Katalog Kampanyaları',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.black87,
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      textStyle: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                    onPressed: () {
                      TopBanner.show(
                        context,
                        'Kampanyalar yakında 🎉',
                        extraTopMargin: 12,
                        duration: const Duration(milliseconds: 1200),
                      );
                    },
                    child: const Text('İncele'),
                  ),
                ],
              ),
            ),

            Positioned(
              right: 8,
              top: 8,
              child: Material(
                color: Colors.black.withOpacity(0.35),
                shape: const CircleBorder(),
                child: InkWell(
                  customBorder: const CircleBorder(),
                  onTap: () => setState(() => _showBanner = false),
                  child: const Padding(
                    padding: EdgeInsets.all(6),
                    child: Icon(Icons.close, size: 18, color: Colors.white),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final favs = FavoritesScope.of(context);
    final cart = CartScope.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mini Katalog'),
        actions: [
          IconButton(
            tooltip: 'Filtre',
            icon: const Icon(Icons.tune),
            onPressed: _openFilterSheet,
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(56),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(12, 0, 12, 10),
            child: TextField(
              controller: _searchCtl,
              decoration: InputDecoration(
                hintText: 'Ara: ürün adı veya açıklama',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: (_query.isNotEmpty)
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _query = '';
                          _searchCtl.clear();
                          _applyFilters();
                        },
                      )
                    : null,
                filled: true,
                isDense: true,
                contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              ),
              onChanged: (v) {
                _query = v;
                _applyFilters();
              },
            ),
          ),
        ),
      ),

      body: FutureBuilder<void>(
        future: _futureInit,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting && _all.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError && _all.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text('Hata: ${snapshot.error}', textAlign: TextAlign.center),
              ),
            );
          }

          final products = _filtered;
          if (products.isEmpty) {
            return const Center(child: Text('Sonuç bulunamadı'));
          }

          final width = MediaQuery.of(context).size.width;
          final cross = width > 900
              ? 5
              : width > 700
                  ? 4
                  : width > 500
                      ? 3
                      : 2;

          final ratio = (cross == 2)
              ? 0.60
              : (cross == 3)
                  ? 0.68
                  : (cross == 4)
                      ? 0.74
                      : 0.78;

          return CustomScrollView(
            slivers: [
              if (_showBanner)
                SliverToBoxAdapter(child: _buildTopBanner(context)),

              SliverPadding(
                padding: const EdgeInsets.all(12.0),
                sliver: SliverGrid(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: cross,
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                    childAspectRatio: ratio,
                  ),
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final p = products[index];
                      return ProductCard(
                        product: p,
                        isFavorite: favs.isFav(p.id),
                        onToggleFavorite: () => favs.toggle(p),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => ProductDetailPage(product: p)),
                          );
                        },
                        onAddToCart: () {
                          cart.add(p);
                          TopBanner.show(
                            context,
                            '${p.title} sepete eklendi',
                            extraTopMargin: 12,
                            duration: const Duration(milliseconds: 1200),
                          );
                        },
                      );
                    },
                    childCount: products.length,
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _NetworkBanner extends StatefulWidget {
  const _NetworkBanner({
    required this.url,
    this.fallbackAspectRatio = 16 / 6,
    this.backgroundColor = const Color(0xFFECEFF5),
  });

  final String url;
  final double fallbackAspectRatio;
  final Color backgroundColor;

  @override
  State<_NetworkBanner> createState() => _NetworkBannerState();
}

class _NetworkBannerState extends State<_NetworkBanner> {
  double? _aspect; 
  ImageStream? _stream;
  ImageStreamListener? _listener;

  @override
  void initState() {
    super.initState();
    _resolveImage();
  }

  @override
  void didUpdateWidget(covariant _NetworkBanner oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.url != widget.url) {
      _resolveImage();
    }
  }

  void _resolveImage() {
    if (_stream != null && _listener != null) {
      _stream!.removeListener(_listener!);
    }
    final img = Image.network(widget.url);
    final stream = img.image.resolve(const ImageConfiguration());
    _listener = ImageStreamListener((info, _) {
      final w = info.image.width.toDouble();
      final h = info.image.height.toDouble();
      if (h > 0) setState(() => _aspect = w / h);
    }, onError: (_, __) {});
    stream.addListener(_listener!);
    _stream = stream;
  }

  @override
  void dispose() {
    if (_stream != null && _listener != null) {
      _stream!.removeListener(_listener!);
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final aspect = _aspect ?? widget.fallbackAspectRatio;

    return AspectRatio(
      aspectRatio: aspect, 
      child: Stack(
        fit: StackFit.expand,
        children: [
          ColoredBox(color: widget.backgroundColor),

          Image.network(
            widget.url,
            fit: BoxFit.contain,
            alignment: Alignment.center,
            loadingBuilder: (context, child, progress) {
              if (progress == null) return child;
              return const Center(child: CircularProgressIndicator());
            },
            errorBuilder: (_, __, ___) => const Center(
              child: Icon(Icons.image_not_supported_outlined, size: 36, color: Colors.black38),
            ),
          ),

          IgnorePointer(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [Colors.black.withOpacity(0.30), Colors.transparent],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}