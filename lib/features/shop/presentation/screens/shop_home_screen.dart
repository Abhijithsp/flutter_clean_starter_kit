import 'dart:async';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/widgets/app_widgets.dart';
import '../../domain/entities/offer.dart';
import '../../domain/entities/product.dart';
import '../cubits/cart_cubit.dart';
import '../cubits/cart_state.dart';
import '../cubits/shop_cubit.dart';
import '../cubits/shop_state.dart';
import '../widgets/wishlist_heart_button.dart';

// ═══════════════════════════════════════════════════════════════════════════
// FLIPKART-STYLE SHOP HOME
// ═══════════════════════════════════════════════════════════════════════════

class ShopHomeScreen extends StatefulWidget {
  const ShopHomeScreen({super.key});
  @override
  State<ShopHomeScreen> createState() => _ShopHomeScreenState();
}

class _ShopHomeScreenState extends State<ShopHomeScreen> {
  final _searchController = TextEditingController();
  final _bannerPageCtrl = PageController();
  Timer? _bannerTimer;
  int _bannerPage = 0;

  // Category icon data – easily extendable
  static const _categories = [
    ('All', '🛒'),
    ('Mobiles', '📱'),
    ('Electronics', '💻'),
    ('Fashion', '👗'),
    ('Home', '🏠'),
    ('Beauty', '💄'),
    ('Sports', '🏋️'),
    ('Toys', '🧸'),
    ('Books', '📚'),
    ('Grocery', '🛍️'),
  ];



  @override
  void initState() {
    super.initState();
    context.read<ShopCubit>().loadAll();
    _startBannerTimer();
  }

  void _startBannerTimer() {
    _bannerTimer = Timer.periodic(const Duration(seconds: 4), (_) {
      if (!mounted) return;
      final state = context.read<ShopCubit>().state;
      if (state is! ShopLoaded || state.offers.isEmpty) return;
      final next = (_bannerPage + 1) % state.offers.length;
      _bannerPageCtrl.animateToPage(next,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut);
    });
  }

  @override
  void dispose() {
    _bannerTimer?.cancel();
    _searchController.dispose();
    _bannerPageCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final isTablet = w >= 600;

    return Scaffold(
      backgroundColor: const Color(0xFFF1F3F6),
      body: BlocBuilder<ShopCubit, ShopState>(
        builder: (context, state) {
          return CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              // ── Flipkart-style top bar ──────────────────────────────────
              _SliverFlipkartTopBar(
                controller: _searchController,
                onSearch: (q) => context.read<ShopCubit>().searchProducts(q),
                onClear: () {
                  _searchController.clear();
                  context.read<ShopCubit>().searchProducts('');
                  setState(() {});
                },
              ),

              if (state is ShopLoaded) ...[
                // ── Category icon strip (always visible, pinned below app bar)
                _SliverCategoryStrip(
                  categories: _categories,
                  selected: state.selectedCategory,
                  onTap: (cat) =>
                      context.read<ShopCubit>().filterByCategory(cat),
                ),

                // ── Filtered Category View vs. Home View ────────────────
                if (state.selectedCategory != 'All') ..._buildFilteredCategoryView(
                  state,
                  isTablet,
                ) else ...[
                  // ── Banner carousel ───────────────────────────────────
                  SliverToBoxAdapter(
                    child: _BannerCarousel(
                      offers: state.offers,
                      controller: _bannerPageCtrl,
                      currentPage: _bannerPage,
                      onPageChanged: (i) => setState(() => _bannerPage = i),
                    ),
                  ),

                  // ── Deal of the Day ───────────────────────────────────
                  _SliverSectionHeader(
                    title: 'Deal of the Day',
                    emoji: '⚡',
                    color: const Color(0xFF2874F0),
                    showTimer: true,
                    actionLabel: 'View All',
                    onAction: () => context.push('/shop/products'),
                  ),
                  SliverToBoxAdapter(
                    child: _HorizontalProductList(
                      products: state.filteredProducts
                          .where((p) => p.discount >= 27)
                          .toList(),
                      cardStyle: _CardStyle.dealCard,
                    ),
                  ),

                  // ── Best Sellers ──────────────────────────────────────
                  _SliverSectionHeader(
                    title: 'Best Sellers',
                    emoji: '🏆',
                    color: const Color(0xFFFF6161),
                    actionLabel: 'See All',
                    onAction: () => context.push('/shop/products'),
                  ),
                  SliverToBoxAdapter(
                    child: _HorizontalProductList(
                      products: state.filteredProducts
                          .where((p) => p.tags.contains('bestseller'))
                          .toList(),
                      cardStyle: _CardStyle.standardCard,
                    ),
                  ),

                  // ── Trending Now ──────────────────────────────────────
                  _SliverSectionHeader(
                    title: 'Trending Now',
                    emoji: '🔥',
                    color: const Color(0xFFFF6161),
                    actionLabel: 'Explore',
                    onAction: () => context.push('/shop/products'),
                  ),
                  SliverToBoxAdapter(
                    child: _HorizontalProductList(
                      products: state.filteredProducts
                          .where((p) => p.tags.contains('trending'))
                          .toList(),
                      cardStyle: _CardStyle.standardCard,
                    ),
                  ),

                  // ── Top Picks grid ────────────────────────────────────
                  _SliverSectionHeader(
                    title: 'Top Picks For You',
                    emoji: '✨',
                    color: const Color(0xFF2874F0),
                    actionLabel: 'View All',
                    onAction: () => context.push('/shop/products'),
                  ),
                  _SliverProductGrid(
                    products: state.filteredProducts.take(12).toList(),
                    isTablet: isTablet,
                  ),
                ],

                const SliverToBoxAdapter(child: SizedBox(height: 32)),
              ] else if (state is ShopLoading)
                const _SliverHomeShimmer()
              else if (state is ShopError)
                SliverFillRemaining(
                  child: AppEmptyState(
                    icon: Icons.cloud_off_rounded,
                    title: 'Could not load shop',
                    subtitle: state.message,
                    actionLabel: 'Retry',
                    onAction: () => context.read<ShopCubit>().loadAll(),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }

  /// Renders a clean filtered view when a specific category is selected.
  List<Widget> _buildFilteredCategoryView(ShopLoaded state, bool isTablet) {
    final cat = state.selectedCategory;
    final products = state.filteredProducts;

    // Map category to display info
    const categoryMeta = {
      'Mobiles': ('📱', Color(0xFF2874F0)),
      'Electronics': ('💻', Color(0xFF1A73E8)),
      'Fashion': ('👗', Color(0xFFE91E63)),
      'Home': ('🏠', Color(0xFF00897B)),
      'Beauty': ('💄', Color(0xFFAD1457)),
      'Sports': ('🏋️', Color(0xFFF57C00)),
      'Toys': ('🧸', Color(0xFFFF8F00)),
      'Books': ('📚', Color(0xFF6D4C41)),
      'Grocery': ('🛍️', Color(0xFF43A047)),
    };
    final meta = categoryMeta[cat] ?? ('🛒', const Color(0xFF2874F0));
    final emoji = meta.$1;
    final color = meta.$2;

    return [
      // Category hero header
      SliverToBoxAdapter(
        child: _CategoryFilterHeader(
          category: cat,
          emoji: emoji,
          color: color,
          productCount: products.length,
          onClear: () => context.read<ShopCubit>().filterByCategory('All'),
        ),
      ),

      // Products grid or empty state
      if (products.isEmpty)
        SliverFillRemaining(
          child: AppEmptyState(
            icon: Icons.search_off_rounded,
            title: 'No products in $cat',
            subtitle: 'Try a different category',
            actionLabel: 'Browse All',
            onAction: () => context.read<ShopCubit>().filterByCategory('All'),
          ),
        )
      else
        _SliverProductGrid(
          products: products,
          isTablet: isTablet,
        ),
    ];
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// FLIPKART TOP BAR
// ═══════════════════════════════════════════════════════════════════════════
class _SliverFlipkartTopBar extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String> onSearch;
  final VoidCallback onClear;
  const _SliverFlipkartTopBar({
    required this.controller,
    required this.onSearch,
    required this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      pinned: true,
      floating: false,
      elevation: 2,
      backgroundColor: const Color(0xFF2874F0),
      expandedHeight: 65,
      automaticallyImplyLeading: false,
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          color: const Color(0xFF2874F0),
          padding: EdgeInsets.only(
            top: MediaQuery.of(context).padding.top + 8,
            left: 12,
            right: 12,
            bottom: 8,
          ),
          child: Row(
            children: [
              // Logo text
              Text(
                'ShopNow',
                style: GoogleFonts.outfit(
                  color: Colors.white,
                  fontWeight: FontWeight.w900,
                  fontSize: 22,
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(width: 10),
              // Search bar
              Expanded(
                child: Container(
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: TextField(
                    controller: controller,
                    onChanged: onSearch,
                    style: GoogleFonts.outfit(fontSize: 13),
                    decoration: InputDecoration(
                      hintText: 'Search for products, brands...',
                      hintStyle: GoogleFonts.outfit(
                        color: Colors.grey.shade500,
                        fontSize: 13,
                      ),
                      prefixIcon: const Icon(
                        Icons.search_rounded,
                        color: Color(0xFF2874F0),
                        size: 20,
                      ),
                      suffixIcon: controller.text.isNotEmpty
                          ? IconButton(
                              icon: const Icon(Icons.close_rounded,
                                  size: 18, color: Colors.grey),
                              onPressed: onClear,
                            )
                          : null,
                      border: InputBorder.none,
                      contentPadding:
                          const EdgeInsets.symmetric(vertical: 10),
                      isDense: true,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              // Cart
              BlocBuilder<CartCubit, CartState>(
                builder: (context, cartState) => GestureDetector(
                  onTap: () => context.push('/shop/cart'),
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      const Icon(Icons.shopping_cart_outlined,
                          color: Colors.white, size: 26),
                      if (cartState.totalItems > 0)
                        Positioned(
                          top: -6,
                          right: -6,
                          child: Container(
                            width: 17,
                            height: 17,
                            decoration: BoxDecoration(
                              color: const Color(0xFFFFBE00),
                              shape: BoxShape.circle,
                              border: Border.all(
                                  color: const Color(0xFF2874F0), width: 1.5),
                            ),
                            child: Center(
                              child: Text(
                                '${cartState.totalItems}',
                                style: GoogleFonts.outfit(
                                  color: Colors.black87,
                                  fontSize: 9,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 14),
              // Wishlist
              GestureDetector(
                onTap: () => context.push('/shop/wishlist'),
                child: const Icon(Icons.favorite_border_rounded,
                    color: Colors.white, size: 26),
              ),
              const SizedBox(width: 14),
              // Orders
              GestureDetector(
                onTap: () => context.push('/shop/order-history'),
                child: const Icon(Icons.receipt_long_outlined,
                    color: Colors.white, size: 26),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// CATEGORY STRIP
// ═══════════════════════════════════════════════════════════════════════════
class _SliverCategoryStrip extends StatelessWidget {
  final List<(String, String)> categories;
  final String selected;
  final ValueChanged<String> onTap;
  const _SliverCategoryStrip({
    required this.categories,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Container(
        color: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: SizedBox(
          height: 72,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 8),
            itemCount: categories.length,
            itemBuilder: (context, i) {
              final (label, emoji) = categories[i];
              final isActive = label == selected;
              return GestureDetector(
                onTap: () => onTap(label),
                child: Container(
                  width: 64,
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        width: 46,
                        height: 46,
                        decoration: BoxDecoration(
                          color: isActive
                              ? const Color(0xFF2874F0).withValues(alpha: 0.10)
                              : const Color(0xFFF1F3F6),
                          shape: BoxShape.circle,
                          border: isActive
                              ? Border.all(
                                  color: const Color(0xFF2874F0), width: 2)
                              : null,
                        ),
                        child: Center(
                          child: Text(emoji,
                              style: const TextStyle(fontSize: 22)),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        label,
                        textAlign: TextAlign.center,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.outfit(
                          fontSize: 10,
                          fontWeight: isActive
                              ? FontWeight.bold
                              : FontWeight.w500,
                          color: isActive
                              ? const Color(0xFF2874F0)
                              : Colors.grey.shade700,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// BANNER CAROUSEL (full-width, Flipkart style)
// ═══════════════════════════════════════════════════════════════════════════
class _BannerCarousel extends StatelessWidget {
  final List<Offer> offers;
  final PageController controller;
  final int currentPage;
  final ValueChanged<int> onPageChanged;
  const _BannerCarousel({
    required this.offers,
    required this.controller,
    required this.currentPage,
    required this.onPageChanged,
  });

  Color _hex(String hex) =>
      Color(int.parse('FF${hex.replaceAll('#', '')}', radix: 16));

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 8),
        SizedBox(
          height: 170,
          child: PageView.builder(
            controller: controller,
            onPageChanged: onPageChanged,
            itemCount: offers.length,
            itemBuilder: (context, i) {
              final o = offers[i];
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      // Gradient bg
                      Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                            colors: [
                              _hex(o.gradientStart),
                              _hex(o.gradientEnd),
                            ],
                          ),
                        ),
                      ),
                      // Right-aligned product image
                      Positioned(
                        right: 0,
                        top: 0,
                        bottom: 0,
                        width: 170,
                        child: CachedNetworkImage(
                          imageUrl: o.imageUrl,
                          fit: BoxFit.cover,
                          errorWidget: (context, url, error) => const SizedBox.shrink(),
                        ),
                      ),
                      // Gradient overlay to blend and support text readability
                      Positioned.fill(
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                              colors: [
                                _hex(o.gradientStart),
                                _hex(o.gradientStart).withValues(alpha: 0.85),
                                _hex(o.gradientEnd).withValues(alpha: 0.1),
                              ],
                              stops: const [0.0, 0.45, 1.0],
                            ),
                          ),
                        ),
                      ),
                      // Text content
                      Padding(
                        padding: const EdgeInsets.all(18),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // Badge
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: const Color(0xFFFFBE00),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                o.badgeText,
                                style: GoogleFonts.outfit(
                                  color: Colors.black87,
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              o.title,
                              style: GoogleFonts.outfit(
                                color: Colors.white,
                                fontSize: 22,
                                fontWeight: FontWeight.w900,
                                height: 1.1,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              o.subtitle,
                              style: GoogleFonts.outfit(
                                color: Colors.white.withValues(alpha: 0.80),
                                fontSize: 12,
                              ),
                            ),
                            const SizedBox(height: 12),
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 4, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Text(
                                    '${o.discountPercent}% OFF',
                                    style: GoogleFonts.outfit(
                                      color: _hex(o.gradientStart),
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                GestureDetector(
                                  onTap: () =>
                                      context.push('/shop/products'),
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 14, vertical: 7),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Text(
                                      'Shop Now →',
                                      style: GoogleFonts.outfit(
                                        color: _hex(o.gradientStart),
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 8),
        // Dots
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(offers.length, (i) {
            final active = i == currentPage;
            return AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              margin: const EdgeInsets.symmetric(horizontal: 2),
              width: active ? 20 : 5,
              height: 5,
              decoration: BoxDecoration(
                color: active
                    ? const Color(0xFF2874F0)
                    : Colors.grey.shade300,
                borderRadius: BorderRadius.circular(4),
              ),
            );
          }),
        ),
        const SizedBox(height: 8),
      ],
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// SECTION HEADER
// ═══════════════════════════════════════════════════════════════════════════
class _SliverSectionHeader extends StatefulWidget {
  final String title;
  final String emoji;
  final Color color;
  final String? actionLabel;
  final VoidCallback? onAction;
  final bool showTimer;
  const _SliverSectionHeader({
    required this.title,
    required this.emoji,
    required this.color,
    this.actionLabel,
    this.onAction,
    this.showTimer = false,
  });

  @override
  State<_SliverSectionHeader> createState() => _SliverSectionHeaderState();
}

class _SliverSectionHeaderState extends State<_SliverSectionHeader> {
  Timer? _timer;
  int _remainingSeconds = 3 * 3600 + 24 * 60 + 17; // 3h 24m 17s deal timer

  @override
  void initState() {
    super.initState();
    if (widget.showTimer) {
      _timer = Timer.periodic(const Duration(seconds: 1), (_) {
        if (mounted && _remainingSeconds > 0) {
          setState(() => _remainingSeconds--);
        }
      });
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  String _formatTimer() {
    final h = _remainingSeconds ~/ 3600;
    final m = (_remainingSeconds % 3600) ~/ 60;
    final s = _remainingSeconds % 60;
    return '${h.toString().padLeft(2, '0')}:${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Container(
        margin: const EdgeInsets.only(top: 8),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        color: Colors.white,
        child: Row(
          children: [
            // Left color accent
            Container(
              width: 4,
              height: 20,
              decoration: BoxDecoration(
                color: widget.color,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            const SizedBox(width: 8),
            Text(
              widget.title,
              style: GoogleFonts.outfit(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: const Color(0xFF1A1A1A),
              ),
            ),
            if (widget.showTimer) ...[
              const SizedBox(width: 10),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: const Color(0xFF2874F0),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.timer_outlined,
                        color: Colors.white, size: 13),
                    const SizedBox(width: 4),
                    Text(
                      _formatTimer(),
                      style: GoogleFonts.outfit(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        fontFeatures: [
                          const FontFeature.tabularFigures()
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
            const Spacer(),
            if (widget.actionLabel != null && widget.onAction != null)
              GestureDetector(
                onTap: widget.onAction,
                child: Text(
                  widget.actionLabel!,
                  style: GoogleFonts.outfit(
                    color: widget.color,
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}


// ═══════════════════════════════════════════════════════════════════════════
// HORIZONTAL PRODUCT LIST
// ═══════════════════════════════════════════════════════════════════════════
enum _CardStyle { dealCard, standardCard }

class _HorizontalProductList extends StatelessWidget {
  final List<Product> products;
  final _CardStyle cardStyle;
  const _HorizontalProductList({
    required this.products,
    required this.cardStyle,
  });

  @override
  Widget build(BuildContext context) {
    if (products.isEmpty) {
      return Container(
        color: Colors.white,
        height: 60,
        child: Center(
          child: Text('No products',
              style: GoogleFonts.outfit(color: Colors.grey)),
        ),
      );
    }
    final cardW = cardStyle == _CardStyle.dealCard ? 155.0 : 150.0;
    final cardH = cardStyle == _CardStyle.dealCard ? 245.0 : 225.0;
    return Container(
      color: Colors.white,
      height: cardH,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
        itemCount: products.length,
        itemBuilder: (context, i) {
          return Padding(
            padding: const EdgeInsets.only(right: 10),
            child: SizedBox(
              width: cardW,
              child: cardStyle == _CardStyle.dealCard
                  ? _DealProductCard(
                      product: products[i],
                      index: i,
                    )
                  : _StandardProductCard(
                      product: products[i],
                      index: i,
                    ),
            ),
          );
        },
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// DEAL PRODUCT CARD (with big discount badge, rating bar)
// ═══════════════════════════════════════════════════════════════════════════
class _DealProductCard extends StatelessWidget {
  final Product product;
  final int index;
  const _DealProductCard({required this.product, required this.index});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.push('/shop/products', extra: product),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.grey.shade200),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image with discount pill (Auto-scales to fill remaining space)
            Expanded(
              child: Stack(
                fit: StackFit.expand,
                children: [
                  ClipRRect(
                    borderRadius:
                        const BorderRadius.vertical(top: Radius.circular(8)),
                    child: CachedNetworkImage(
                      imageUrl: product.imageUrl,
                      fit: BoxFit.cover,
                      errorWidget: (context, url, error) => Container(
                        color: Colors.grey.shade100,
                        child: const Icon(Icons.image_outlined,
                            color: Colors.grey, size: 36),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 6,
                    right: 6,
                    child: WishlistHeartButton(product: product),
                  ),
                  Positioned(
                    top: 6,
                    left: 6,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 6, vertical: 3),
                      decoration: BoxDecoration(
                        color: const Color(0xFF388E3C),
                        borderRadius: BorderRadius.circular(3),
                      ),
                      child: Text(
                        '${product.discount}% OFF',
                        style: GoogleFonts.outfit(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.outfit(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF1A1A1A),
                      height: 1.3,
                    ),
                  ),
                  const SizedBox(height: 4),
                  // Rating row
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 5, vertical: 2),
                        decoration: BoxDecoration(
                          color: const Color(0xFF388E3C),
                          borderRadius: BorderRadius.circular(3),
                        ),
                        child: Row(
                          children: [
                            Text(
                              '${product.rating}',
                              style: GoogleFonts.outfit(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const Icon(Icons.star_rounded,
                                color: Colors.white, size: 10),
                          ],
                        ),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '(${_formatCount(product.reviewCount)})',
                        style: GoogleFonts.outfit(
                            color: Colors.grey.shade500, fontSize: 10),
                      ),
                    ],
                  ),
                  const SizedBox(height: 5),
                  // Price row (horizontal alignment saves height)
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    children: [
                      Text(
                        '\$${product.price.toStringAsFixed(0)}',
                        style: GoogleFonts.outfit(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                          color: const Color(0xFF1A1A1A),
                        ),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '\$${product.originalPrice.toStringAsFixed(0)}',
                        style: GoogleFonts.outfit(
                          fontSize: 10,
                          color: Colors.grey.shade400,
                          decoration: TextDecoration.lineThrough,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatCount(int count) {
    if (count >= 1000) return '${(count / 1000).toStringAsFixed(1)}k';
    return '$count';
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// STANDARD PRODUCT CARD (compact flipkart-style)
// ═══════════════════════════════════════════════════════════════════════════
class _StandardProductCard extends StatelessWidget {
  final Product product;
  final int index;
  const _StandardProductCard({
    required this.product,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    const accent = Color(0xFF2874F0);
    return GestureDetector(
      onTap: () => context.push('/shop/products', extra: product),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(6),
          border: Border.all(color: Colors.grey.shade100),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Stack(
                fit: StackFit.expand,
                children: [
                  ClipRRect(
                    borderRadius:
                        const BorderRadius.vertical(top: Radius.circular(6)),
                    child: CachedNetworkImage(
                      imageUrl: product.imageUrl,
                      fit: BoxFit.cover,
                      errorWidget: (context, url, error) => Container(
                        color: accent.withValues(alpha: 0.08),
                        child: Icon(Icons.shopping_bag_outlined,
                            color: accent, size: 32),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 6,
                    right: 6,
                    child: WishlistHeartButton(product: product),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(6),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.outfit(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      height: 1.3,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Row(
                    children: [
                      Text(
                        '\$${product.price.toStringAsFixed(0)}',
                        style: GoogleFonts.outfit(
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                          color: const Color(0xFF1A1A1A),
                        ),
                      ),
                      const SizedBox(width: 4),
                      Flexible(
                        child: Text(
                          '${product.discount}% off',
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.outfit(
                            color: const Color(0xFF388E3C),
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 2),
                  // Add to cart button
                  BlocBuilder<CartCubit, CartState>(
                    builder: (ctx, cartState) {
                      final inCart =
                          cartState.containsProduct(product.id);
                      return SizedBox(
                        width: double.infinity,
                        height: 26,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                inCart ? const Color(0xFF388E3C) : accent,
                            foregroundColor: Colors.white,
                            padding: EdgeInsets.zero,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(4)),
                            elevation: 0,
                          ),
                          onPressed: product.inStock
                              ? () => ctx
                                  .read<CartCubit>()
                                  .addItem(product)
                              : null,
                          child: Text(
                            inCart ? '✓ Added' : 'Add to Cart',
                            style: GoogleFonts.outfit(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// TOP PICKS GRID (Flipkart-style 2-col card grid)
// ═══════════════════════════════════════════════════════════════════════════
class _SliverProductGrid extends StatelessWidget {
  final List<Product> products;
  final bool isTablet;
  const _SliverProductGrid({required this.products, required this.isTablet});

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      sliver: SliverGrid(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: isTablet ? 3 : 2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 0.66,
        ),
        delegate: SliverChildBuilderDelegate(
          (context, i) => _GridProductCard(product: products[i], index: i),
          childCount: products.length,
        ),
      ),
    );
  }
}

class _GridProductCard extends StatelessWidget {
  final Product product;
  final int index;
  const _GridProductCard({required this.product, required this.index});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return GestureDetector(
      onTap: () => context.push('/shop/products', extra: product),
      child: Container(
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1E1E2E) : Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isDark ? Colors.white12 : const Color(0xFFEEEEEE),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image with discount pill (Auto-scales to fill remaining space)
            Expanded(
              child: Stack(
                fit: StackFit.expand,
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(10)),
                    child: CachedNetworkImage(
                      imageUrl: product.imageUrl,
                      fit: BoxFit.cover,
                      errorWidget: (context, url, error) => Container(
                        color: Colors.grey.shade100,
                        child: const Icon(Icons.image_outlined,
                            color: Colors.grey, size: 36),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 6,
                    right: 6,
                    child: WishlistHeartButton(product: product),
                  ),
                  if (product.discount > 0)
                    Positioned(
                      top: 6,
                      left: 6,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 6, vertical: 3),
                        decoration: BoxDecoration(
                          color: const Color(0xFF388E3C),
                          borderRadius: BorderRadius.circular(3),
                        ),
                        child: Text(
                          '${product.discount}% OFF',
                          style: GoogleFonts.outfit(
                            color: Colors.white,
                            fontSize: 9,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  if (!product.inStock)
                    Positioned.fill(
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.black45,
                          borderRadius: const BorderRadius.vertical(top: Radius.circular(10)),
                        ),
                        child: Center(
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 4),
                            color: Colors.white,
                            child: Text(
                              'Out of Stock',
                              style: GoogleFonts.outfit(
                                color: Colors.red,
                                fontWeight: FontWeight.bold,
                                fontSize: 10,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
            
            // Info (takes natural size with tight spacing)
            Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start, // Sit together nicely
                children: [
                  Text(
                    product.name,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.outfit(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: isDark ? Colors.white : const Color(0xFF1A1A1A),
                      height: 1.25,
                    ),
                  ),
                  const SizedBox(height: 6),
                  // Rating & Reviews Count
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 4, vertical: 1),
                        decoration: BoxDecoration(
                          color: const Color(0xFF388E3C),
                          borderRadius: BorderRadius.circular(3),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              '${product.rating}',
                              style: GoogleFonts.outfit(
                                color: Colors.white,
                                fontSize: 9,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const Icon(Icons.star_rounded,
                                color: Colors.white, size: 9),
                          ],
                        ),
                      ),
                      const SizedBox(width: 4),
                      Flexible(
                        child: Text(
                          '(${_formatCount(product.reviewCount)})',
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.outfit(
                              fontSize: 9,
                              color: Colors.grey.shade500),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  // Price
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    children: [
                      Text(
                        '\$${product.price.toStringAsFixed(0)}',
                        style: GoogleFonts.outfit(
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                          color: isDark ? Colors.white : const Color(0xFF1A1A1A),
                        ),
                      ),
                      const SizedBox(width: 4),
                      Flexible(
                        child: Text(
                          '\$${product.originalPrice.toStringAsFixed(0)}',
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.outfit(
                            fontSize: 9,
                            color: Colors.grey.shade400,
                            decoration: TextDecoration.lineThrough,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  // Free delivery tag
                  Text(
                    'Free Delivery',
                    style: GoogleFonts.outfit(
                      fontSize: 9,
                      color: Colors.teal.shade600,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatCount(int count) {
    if (count >= 1000) return '${(count / 1000).toStringAsFixed(1)}k';
    return '$count';
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// CATEGORY FILTER HEADER
// ═══════════════════════════════════════════════════════════════════════════
class _CategoryFilterHeader extends StatelessWidget {
  final String category;
  final String emoji;
  final Color color;
  final int productCount;
  final VoidCallback onClear;

  const _CategoryFilterHeader({
    required this.category,
    required this.emoji,
    required this.color,
    required this.productCount,
    required this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(12, 12, 12, 4),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            color.withValues(alpha: 0.12),
            color.withValues(alpha: 0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.20)),
      ),
      child: Row(
        children: [
          // Emoji circle
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.15),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(emoji, style: const TextStyle(fontSize: 22)),
            ),
          ),
          const SizedBox(width: 12),
          // Text info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  category,
                  style: GoogleFonts.outfit(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: color,
                    height: 1.1,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '$productCount product${productCount != 1 ? 's' : ''} found',
                  style: GoogleFonts.outfit(
                    fontSize: 12,
                    color: Colors.grey.shade600,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          // Clear filter button
          GestureDetector(
            onTap: onClear,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: color.withValues(alpha: 0.30)),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.close_rounded, size: 14, color: color),
                  const SizedBox(width: 4),
                  Text(
                    'All',
                    style: GoogleFonts.outfit(
                      fontSize: 12,
                      color: color,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// SKELETON HOME SHIMMER LOADER
// ═══════════════════════════════════════════════════════════════════════════
class _SliverHomeShimmer extends StatelessWidget {
  const _SliverHomeShimmer();

  @override
  Widget build(BuildContext context) {
    final isTablet = MediaQuery.of(context).size.width >= 600;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardBg = isDark ? const Color(0xFF1E1E2E) : Colors.white;
    final borderColor = isDark ? Colors.white12 : const Color(0xFFEEEEEE);

    return SliverList(
      delegate: SliverChildListDelegate([
        const SizedBox(height: 16),
        // 1. Category strip shimmer
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: List.generate(6, (index) => const Padding(
              padding: EdgeInsets.only(right: 20),
              child: Column(
                children: [
                  ShimmerPlaceholder(width: 56, height: 56, borderRadius: 28),
                  SizedBox(height: 8),
                  ShimmerPlaceholder(width: 45, height: 10, borderRadius: 4),
                ],
              ),
            )),
          ),
        ),
        const SizedBox(height: 24),
        
        // 2. Banner carousel shimmer
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: ShimmerPlaceholder(width: double.infinity, height: 170, borderRadius: 8),
        ),
        const SizedBox(height: 24),

        // 3. Section Title shimmer
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ShimmerPlaceholder(width: 140, height: 20, borderRadius: 4),
              ShimmerPlaceholder(width: 60, height: 16, borderRadius: 4),
            ],
          ),
        ),
        const SizedBox(height: 12),

        // 4. Horizontal deals list shimmer
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: List.generate(3, (index) => Padding(
              padding: const EdgeInsets.only(right: 12),
              child: Container(
                width: 150,
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: cardBg,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: borderColor),
                ),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ShimmerPlaceholder(width: double.infinity, height: 105, borderRadius: 6),
                    SizedBox(height: 8),
                    ShimmerPlaceholder(width: 100, height: 12, borderRadius: 4),
                    SizedBox(height: 6),
                    ShimmerPlaceholder(width: 40, height: 10, borderRadius: 4),
                    SizedBox(height: 6),
                    ShimmerPlaceholder(width: 60, height: 14, borderRadius: 4),
                  ],
                ),
              ),
            )),
          ),
        ),
        const SizedBox(height: 24),

        // 5. Grid picks title shimmer
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ShimmerPlaceholder(width: 160, height: 20, borderRadius: 4),
              ShimmerPlaceholder(width: 60, height: 16, borderRadius: 4),
            ],
          ),
        ),
        const SizedBox(height: 12),

        // 6. Grid picks cards shimmer
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: 4,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: isTablet ? 3 : 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 0.66,
            ),
            itemBuilder: (context, index) {
              return Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: cardBg,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: borderColor),
                ),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ShimmerPlaceholder(width: double.infinity, height: 110, borderRadius: 6),
                    SizedBox(height: 8),
                    ShimmerPlaceholder(width: double.infinity, height: 12, borderRadius: 4),
                    SizedBox(height: 4),
                    ShimmerPlaceholder(width: 80, height: 12, borderRadius: 4),
                    SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ShimmerPlaceholder(width: 40, height: 12, borderRadius: 4),
                        ShimmerPlaceholder(width: 50, height: 14, borderRadius: 4),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 32),
      ]),
    );
  }
}


