import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../domain/entities/product.dart';
import '../cubits/cart_cubit.dart';
import '../cubits/cart_state.dart';
import '../cubits/shop_cubit.dart';
import '../cubits/shop_state.dart';
import '../widgets/wishlist_heart_button.dart';

// ═══════════════════════════════════════════════════════════════════════════
// PRODUCT LIST & DETAIL SCREEN (Flipkart-Style & Fully Responsive)
// ═══════════════════════════════════════════════════════════════════════════

class ProductListScreen extends StatelessWidget {
  final Product? initialProduct;
  const ProductListScreen({super.key, this.initialProduct});

  @override
  Widget build(BuildContext context) {
    if (initialProduct != null) {
      return _ProductDetailView(product: initialProduct!);
    }
    return const _ProductGridView();
  }
}

// ─── Responsive Grid View for All Products ──────────────────────────────────
class _ProductGridView extends StatefulWidget {
  const _ProductGridView();

  @override
  State<_ProductGridView> createState() => _ProductGridViewState();
}

class _ProductGridViewState extends State<_ProductGridView> {
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final state = context.read<ShopCubit>().state;
    if (state is ShopLoaded) {
      _searchController.text = state.searchQuery;
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Widget _buildRatingChip(StateSetter setSheetState, String label, double ratingValue, double currentRating, Function(double) onSelected) {
    final isSelected = currentRating == ratingValue;
    return ChoiceChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (selected) {
        if (selected) {
          onSelected(ratingValue);
        }
      },
      selectedColor: const Color(0xFF2874F0).withValues(alpha: 0.15),
      labelStyle: GoogleFonts.outfit(
        fontSize: 12,
        color: isSelected ? const Color(0xFF2874F0) : Colors.black87,
        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
      ),
      checkmarkColor: const Color(0xFF2874F0),
    );
  }

  void _showSortBottomSheet(BuildContext context, ShopLoaded state) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (ctx) {
        return Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Sort By',
                style: GoogleFonts.outfit(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF1A1A1A),
                ),
              ),
              const Divider(),
              _buildSortOption(context, 'Relevance', 'relevance', state.sortBy),
              _buildSortOption(context, 'Price: Low to High', 'priceLowHigh', state.sortBy),
              _buildSortOption(context, 'Price: High to Low', 'priceHighLow', state.sortBy),
              _buildSortOption(context, 'Customer Rating', 'ratingHighLow', state.sortBy),
              _buildSortOption(context, 'Name: A to Z', 'nameAZ', state.sortBy),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSortOption(BuildContext context, String label, String value, String currentSelected) {
    return RadioListTile<String>(
      title: Text(label, style: GoogleFonts.outfit(fontSize: 14)),
      value: value,
      // ignore: deprecated_member_use
      groupValue: currentSelected,
      activeColor: const Color(0xFF2874F0),
      // ignore: deprecated_member_use
      onChanged: (newValue) {
        if (newValue != null) {
          context.read<ShopCubit>().applyFilters(sortBy: newValue);
          Navigator.pop(context);
        }
      },
    );
  }

  void _showFilterBottomSheet(BuildContext context, ShopLoaded state) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (ctx) {
        double localMin = state.minPrice;
        double localMax = state.maxPrice;
        double localRating = state.minRating;
        bool localStock = state.onlyInStock;

        return StatefulBuilder(
          builder: (context, setSheetState) {
            return Container(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Filters',
                        style: GoogleFonts.outfit(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF1A1A1A),
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          context.read<ShopCubit>().resetFilters();
                          Navigator.pop(context);
                          _searchController.clear();
                        },
                        child: Text(
                          'RESET ALL',
                          style: GoogleFonts.outfit(
                            color: const Color(0xFF2874F0),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const Divider(),
                  const SizedBox(height: 12),
                  Text(
                    'Price Range',
                    style: GoogleFonts.outfit(fontWeight: FontWeight.bold, fontSize: 14),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('\$${localMin.toStringAsFixed(0)}', style: GoogleFonts.outfit(fontSize: 12, fontWeight: FontWeight.bold)),
                      Text('\$${localMax.toStringAsFixed(0)}', style: GoogleFonts.outfit(fontSize: 12, fontWeight: FontWeight.bold)),
                    ],
                  ),
                  RangeSlider(
                    values: RangeValues(localMin, localMax),
                    min: 0.0,
                    max: 2000.0,
                    divisions: 40,
                    activeColor: const Color(0xFF2874F0),
                    inactiveColor: Colors.grey.shade300,
                    labels: RangeLabels(
                      '\$${localMin.toStringAsFixed(0)}',
                      '\$${localMax.toStringAsFixed(0)}',
                    ),
                    onChanged: (values) {
                      setSheetState(() {
                        localMin = values.start;
                        localMax = values.end;
                      });
                    },
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Minimum Rating',
                    style: GoogleFonts.outfit(fontWeight: FontWeight.bold, fontSize: 14),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      _buildRatingChip(setSheetState, 'All', 0.0, localRating, (val) {
                        setSheetState(() => localRating = val);
                      }),
                      const SizedBox(width: 8),
                      _buildRatingChip(setSheetState, '4★ & above', 4.0, localRating, (val) {
                        setSheetState(() => localRating = val);
                      }),
                      const SizedBox(width: 8),
                      _buildRatingChip(setSheetState, '3★ & above', 3.0, localRating, (val) {
                        setSheetState(() => localRating = val);
                      }),
                    ],
                  ),
                  const SizedBox(height: 16),
                  SwitchListTile(
                    title: Text(
                      'In Stock Only',
                      style: GoogleFonts.outfit(fontSize: 14, fontWeight: FontWeight.bold),
                    ),
                    value: localStock,
                    activeThumbColor: const Color(0xFF388E3C),
                    contentPadding: EdgeInsets.zero,
                    onChanged: (val) {
                      setSheetState(() {
                        localStock = val;
                      });
                    },
                  ),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            side: const BorderSide(color: Color(0xFF2874F0)),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                          ),
                          onPressed: () => Navigator.pop(context),
                          child: Text(
                            'CANCEL',
                            style: GoogleFonts.outfit(color: const Color(0xFF2874F0), fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFFB641B),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                            elevation: 0,
                          ),
                          onPressed: () {
                            context.read<ShopCubit>().applyFilters(
                              minPrice: localMin,
                              maxPrice: localMax,
                              minRating: localRating,
                              onlyInStock: localStock,
                            );
                            Navigator.pop(context);
                          },
                          child: Text(
                            'APPLY FILTERS',
                            style: GoogleFonts.outfit(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final isTablet = w >= 600;
    final isDesktop = w >= 1000;

    int crossAxisCount = 2;
    if (isDesktop) {
      crossAxisCount = 5;
    } else if (isTablet) {
      crossAxisCount = 3;
    }

    final childAspectRatio = isDesktop ? 0.72 : (isTablet ? 0.70 : 0.65);

    return Scaffold(
      backgroundColor: const Color(0xFFF1F3F6),
      appBar: AppBar(
        backgroundColor: const Color(0xFF2874F0),
        iconTheme: const IconThemeData(color: Colors.white),
        title: Text(
          'All Products',
          style: GoogleFonts.outfit(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          _CartBadgeIcon(),
          const SizedBox(width: 8),
        ],
      ),
      body: BlocBuilder<ShopCubit, ShopState>(
        builder: (context, state) {
          if (state is! ShopLoaded) {
            return const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF2874F0)),
              ),
            );
          }
          final products = state.filteredProducts;
          return Column(
            children: [
              Container(
                color: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        height: 40,
                        decoration: BoxDecoration(
                          color: const Color(0xFFF1F3F6),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: TextField(
                          controller: _searchController,
                          onChanged: (q) {
                            context.read<ShopCubit>().searchProducts(q);
                            setState(() {});
                          },
                          decoration: InputDecoration(
                            hintText: 'Search products...',
                            hintStyle: GoogleFonts.outfit(color: Colors.grey.shade500, fontSize: 13),
                            prefixIcon: const Icon(Icons.search, size: 18, color: Colors.grey),
                            suffixIcon: _searchController.text.isNotEmpty
                                ? IconButton(
                                    icon: const Icon(Icons.clear, size: 16, color: Colors.grey),
                                    onPressed: () {
                                      _searchController.clear();
                                      context.read<ShopCubit>().searchProducts('');
                                      setState(() {});
                                    },
                                  )
                                : null,
                            border: InputBorder.none,
                            isDense: true,
                            contentPadding: const EdgeInsets.symmetric(vertical: 10),
                          ),
                          style: GoogleFonts.outfit(fontSize: 14),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border(
                    bottom: BorderSide(color: Colors.grey.shade200),
                    top: BorderSide(color: Colors.grey.shade100),
                  ),
                ),
                height: 48,
                child: Row(
                  children: [
                    Expanded(
                      child: InkWell(
                        onTap: () => _showSortBottomSheet(context, state),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.sort_rounded, size: 18, color: Colors.black87),
                            const SizedBox(width: 8),
                            Text(
                              'SORT BY',
                              style: GoogleFonts.outfit(
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                                color: Colors.black87,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    VerticalDivider(color: Colors.grey.shade200, width: 1),
                    Expanded(
                      child: InkWell(
                        onTap: () => _showFilterBottomSheet(context, state),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.filter_alt_outlined, size: 18, color: Colors.black87),
                            const SizedBox(width: 8),
                            Text(
                              'FILTER',
                              style: GoogleFonts.outfit(
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                                color: Colors.black87,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: products.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.search_off_rounded, size: 64, color: Colors.grey),
                            const SizedBox(height: 16),
                            Text(
                              'No products match your filters',
                              style: GoogleFonts.outfit(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey.shade700,
                              ),
                            ),
                            const SizedBox(height: 8),
                            TextButton(
                              onPressed: () {
                                context.read<ShopCubit>().resetFilters();
                                _searchController.clear();
                                setState(() {});
                              },
                              child: Text(
                                'Clear All Filters',
                                style: GoogleFonts.outfit(
                                  color: const Color(0xFF2874F0),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    : GridView.builder(
                        padding: const EdgeInsets.all(8),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: crossAxisCount,
                          crossAxisSpacing: 8,
                          mainAxisSpacing: 8,
                          childAspectRatio: childAspectRatio,
                        ),
                        itemCount: products.length,
                        itemBuilder: (_, i) => _ListProductCard(product: products[i], index: i),
                      ),
              ),
            ],
          );
        },
      ),
    );
  }
}

// ─── Compact Flipkart-Style Card ─────────────────────────────────────────────
class _ListProductCard extends StatelessWidget {
  final Product product;
  final int index;
  const _ListProductCard({required this.product, required this.index});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.push('/shop/products', extra: product),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(4),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image with discount badge
            Expanded(
              child: Stack(
                fit: StackFit.expand,
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
                    child: CachedNetworkImage(
                      imageUrl: product.imageUrl,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Container(
                        color: Colors.grey.shade100,
                        child: const Center(
                          child: SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(Colors.grey),
                            ),
                          ),
                        ),
                      ),
                      errorWidget: (context, url, error) => Container(
                        color: Colors.grey.shade100,
                        child: const Icon(Icons.image_outlined, color: Colors.grey, size: 36),
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
                      left: 0,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        color: const Color(0xFF388E3C), // Flipkart Green
                        child: Text(
                          '${product.discount}% off',
                          style: GoogleFonts.outfit(
                            color: Colors.white,
                            fontSize: 9,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  if (!product.inStock)
                    Container(
                      color: Colors.black45,
                      child: Center(
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
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
                ],
              ),
            ),
            // Product info
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
                      fontWeight: FontWeight.w500,
                      color: const Color(0xFF1A1A1A),
                      height: 1.3,
                    ),
                  ),
                  const SizedBox(height: 4),
                  // Rating bubble
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
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
                            const Icon(Icons.star_rounded, color: Colors.white, size: 10),
                          ],
                        ),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '(${_formatCount(product.reviewCount)})',
                        style: GoogleFonts.outfit(color: Colors.grey.shade500, fontSize: 10),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  // Price row
                  Row(
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
                      if (product.discount > 0) ...[
                        Text(
                          '\$${product.originalPrice.toStringAsFixed(0)}',
                          style: GoogleFonts.outfit(
                            fontSize: 11,
                            color: Colors.grey.shade500,
                            decoration: TextDecoration.lineThrough,
                          ),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 6),
                  // Add to cart button
                  BlocBuilder<CartCubit, CartState>(
                    builder: (ctx, cartState) {
                      final inCart = cartState.containsProduct(product.id);
                      return SizedBox(
                        width: double.infinity,
                        height: 28,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: inCart ? const Color(0xFF388E3C) : const Color(0xFFFF9F00), // Green if in cart, Orange/Yellow if not
                            foregroundColor: Colors.white,
                            padding: EdgeInsets.zero,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                            elevation: 0,
                          ),
                          onPressed: product.inStock
                              ? () => ctx.read<CartCubit>().addItem(product)
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

  String _formatCount(int count) {
    if (count >= 1000) return '${(count / 1000).toStringAsFixed(1)}k';
    return '$count';
  }
}

// ─── Responsive Product Detail View ──────────────────────────────────────────
class _ProductDetailView extends StatefulWidget {
  final Product product;
  const _ProductDetailView({required this.product});

  @override
  State<_ProductDetailView> createState() => _ProductDetailViewState();
}

class _ProductDetailViewState extends State<_ProductDetailView> {
  String? _selectedColor;
  String? _selectedSize;
  String? _selectedStorage;
  int _quantity = 1;

  final _nameController = TextEditingController();
  final _commentController = TextEditingController();
  int _userRating = 5;

  late List<Map<String, dynamic>> _reviews;
  late double _avgRating;
  late int _reviewCount;

  @override
  void initState() {
    super.initState();
    _selectedColor = widget.product.colors.isNotEmpty ? widget.product.colors.first : null;
    _selectedSize = widget.product.sizes.isNotEmpty ? widget.product.sizes.first : null;
    _selectedStorage = widget.product.storage.isNotEmpty ? widget.product.storage.first : null;

    _reviews = [
      {
        'userName': 'Rajesh Kumar',
        'rating': 5.0,
        'comment': 'Superb sound quality and deep bass. Worth every penny! Delivered in just 2 days.',
        'date': DateTime.now().subtract(const Duration(days: 2)),
        'verified': true,
      },
      {
        'userName': 'Vikram S.',
        'rating': 4.0,
        'comment': 'Great build quality and very comfortable to wear. Noise cancellation is decent.',
        'date': DateTime.now().subtract(const Duration(days: 5)),
        'verified': true,
      },
      {
        'userName': 'Neha Gupta',
        'rating': 5.0,
        'comment': 'Awesome battery life. Charged once and it lasted for a whole week of moderate usage.',
        'date': DateTime.now().subtract(const Duration(days: 8)),
        'verified': true,
      },
    ];

    _avgRating = widget.product.rating;
    _reviewCount = widget.product.reviewCount + _reviews.length;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _commentController.dispose();
    super.dispose();
  }

  void _submitReview() {
    if (_nameController.text.trim().isEmpty || _commentController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill out all review fields!')),
      );
      return;
    }

    final newReview = {
      'userName': _nameController.text.trim(),
      'rating': _userRating.toDouble(),
      'comment': _commentController.text.trim(),
      'date': DateTime.now(),
      'verified': true,
    };

    setState(() {
      _reviews.insert(0, newReview);
      
      double totalSum = widget.product.rating * widget.product.reviewCount;
      for (var r in _reviews) {
        totalSum += r['rating'] as double;
      }
      _reviewCount = widget.product.reviewCount + _reviews.length;
      _avgRating = totalSum / _reviewCount;

      _nameController.clear();
      _commentController.clear();
      _userRating = 5;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Review submitted successfully! Thank you. 🎉')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final isTablet = w >= 750;

    return Scaffold(
      backgroundColor: const Color(0xFFF1F3F6),
      appBar: AppBar(
        backgroundColor: const Color(0xFF2874F0),
        iconTheme: const IconThemeData(color: Colors.white),
        title: Text(
          widget.product.name,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: GoogleFonts.outfit(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        actions: [
          _CartBadgeIcon(),
          const SizedBox(width: 8),
        ],
      ),
      body: isTablet ? _buildTabletLayout(context) : _buildMobileLayout(context),
      bottomNavigationBar: isTablet ? null : _buildMobileBottomBar(context),
    );
  }

  Widget _buildTabletLayout(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Left Side: Image and CTA buttons
          Expanded(
            flex: 4,
            child: Column(
              children: [
                Container(
                  height: 380,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(color: Colors.grey.shade200),
                  ),
                  padding: const EdgeInsets.all(16),
                  child: Stack(
                    children: [
                      Center(
                        child: CachedNetworkImage(
                          imageUrl: widget.product.imageUrl,
                          fit: BoxFit.contain,
                          placeholder: (context, url) => const Center(
                            child: CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF2874F0)),
                            ),
                          ),
                          errorWidget: (context, url, error) => const Icon(
                            Icons.image_outlined,
                            size: 80,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                      if (widget.product.discount > 0)
                        Positioned(
                          top: 0,
                          left: 0,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            color: const Color(0xFF388E3C),
                            child: Text(
                              '${widget.product.discount}% OFF',
                              style: GoogleFonts.outfit(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                // Action Buttons for Tablet
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFFF9F00), // Yellow/Orange
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 20),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                          elevation: 0,
                        ),
                        onPressed: widget.product.inStock
                            ? () {
                                context.read<CartCubit>().addItem(
                                      widget.product,
                                      color: _selectedColor,
                                      size: _selectedSize,
                                      storage: _selectedStorage,
                                      quantity: _quantity,
                                    );
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Added to Cart!')),
                                );
                              }
                            : null,
                        icon: const Icon(Icons.shopping_cart_outlined),
                        label: Text(
                          'ADD TO CART',
                          style: GoogleFonts.outfit(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFFB641B), // Solid orange
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 20),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                          elevation: 0,
                        ),
                        onPressed: widget.product.inStock
                            ? () {
                                context.read<CartCubit>().addItem(
                                      widget.product,
                                      color: _selectedColor,
                                      size: _selectedSize,
                                      storage: _selectedStorage,
                                      quantity: _quantity,
                                    );
                                context.push('/shop/cart');
                              }
                            : null,
                        icon: const Icon(Icons.flash_on),
                        label: Text(
                          'BUY NOW',
                          style: GoogleFonts.outfit(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 24),
          // Right Side: Scrollable Details Pane
          Expanded(
            flex: 5,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(4),
                border: Border.all(color: Colors.grey.shade200),
              ),
              padding: const EdgeInsets.all(24),
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: const Color(0xFF2874F0).withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(3),
                          ),
                          child: Text(
                            widget.product.category.toUpperCase(),
                            style: GoogleFonts.outfit(
                              color: const Color(0xFF2874F0),
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        if (!widget.product.inStock)
                          Text(
                            'OUT OF STOCK',
                            style: GoogleFonts.outfit(
                              color: Colors.red,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      widget.product.name,
                      style: GoogleFonts.outfit(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF1A1A1A),
                      ),
                    ),
                    const SizedBox(height: 12),
                    // Rating block
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: const Color(0xFF388E3C),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Row(
                            children: [
                              Text(
                                _avgRating.toStringAsFixed(1),
                                style: GoogleFonts.outfit(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13,
                                ),
                              ),
                              const SizedBox(width: 4),
                              const Icon(Icons.star, color: Colors.white, size: 12),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '$_reviewCount Ratings & Reviews',
                          style: GoogleFonts.outfit(
                            color: Colors.grey.shade600,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    // Price Block
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.baseline,
                      textBaseline: TextBaseline.alphabetic,
                      children: [
                        Text(
                          '\$${widget.product.price.toStringAsFixed(2)}',
                          style: GoogleFonts.outfit(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF1A1A1A),
                          ),
                        ),
                        const SizedBox(width: 12),
                        if (widget.product.discount > 0) ...[
                          Text(
                            '\$${widget.product.originalPrice.toStringAsFixed(2)}',
                            style: GoogleFonts.outfit(
                              fontSize: 18,
                              color: Colors.grey.shade500,
                              decoration: TextDecoration.lineThrough,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Text(
                            '${widget.product.discount}% Off',
                            style: GoogleFonts.outfit(
                              color: const Color(0xFF388E3C),
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      '+ \$4.99 Shipping (Free above \$99)',
                      style: GoogleFonts.outfit(color: Colors.grey.shade600, fontSize: 13),
                    ),
                    const Divider(height: 32),
                    // Variants Section
                    _buildVariantsSelection(),
                    const Divider(height: 32),
                    // Offers section
                    Text(
                      'Available Offers',
                      style: GoogleFonts.outfit(fontSize: 15, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    _buildOfferItem('Bank Offer: 10% instant discount on Cards up to \$15.'),
                    _buildOfferItem('Partner Offer: Get extra 5% off on shopping voucher purchases.'),
                    _buildOfferItem('Freebie: 3 months subscription of Music Premium with this order.'),
                    const Divider(height: 32),
                    // Description
                    Text(
                      'Product Description',
                      style: GoogleFonts.outfit(fontSize: 15, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      widget.product.description,
                      style: GoogleFonts.outfit(
                        color: Colors.grey.shade700,
                        height: 1.6,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: widget.product.tags
                          .map(
                            (tag) => Chip(
                              label: Text('#$tag'),
                              backgroundColor: const Color(0xFFF1F3F6),
                              side: BorderSide.none,
                              labelStyle: GoogleFonts.outfit(color: const Color(0xFF2874F0), fontSize: 12),
                            ),
                          )
                          .toList(),
                    ),
                    const Divider(height: 40),
                    // Ratings breakdown and reviews
                    _buildReviewsSection(),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMobileLayout(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image Box
          Container(
            color: Colors.white,
            height: 300,
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 24),
            child: Stack(
              children: [
                Center(
                  child: CachedNetworkImage(
                    imageUrl: widget.product.imageUrl,
                    fit: BoxFit.contain,
                    placeholder: (context, url) => const Center(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF2874F0)),
                      ),
                    ),
                    errorWidget: (context, url, error) => const Icon(
                      Icons.image_outlined,
                      size: 80,
                      color: Colors.grey,
                    ),
                  ),
                ),
                if (widget.product.discount > 0)
                  Positioned(
                    top: 0,
                    left: 16,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      color: const Color(0xFF388E3C),
                      child: Text(
                        '${widget.product.discount}% OFF',
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
          const SizedBox(height: 8),
          // Info Block
          Container(
            color: Colors.white,
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.product.category.toUpperCase(),
                  style: GoogleFonts.outfit(
                    color: const Color(0xFF2874F0),
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  widget.product.name,
                  style: GoogleFonts.outfit(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF1A1A1A),
                  ),
                ),
                const SizedBox(height: 10),
                // Rating Row
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: const Color(0xFF388E3C),
                        borderRadius: BorderRadius.circular(3),
                      ),
                      child: Row(
                        children: [
                          Text(
                            _avgRating.toStringAsFixed(1),
                            style: GoogleFonts.outfit(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 11,
                            ),
                          ),
                          const SizedBox(width: 2),
                          const Icon(Icons.star, color: Colors.white, size: 10),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '$_reviewCount Ratings & Reviews',
                      style: GoogleFonts.outfit(
                        color: Colors.grey.shade500,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                // Price block
                Row(
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.alphabetic,
                  children: [
                    Text(
                      '\$${widget.product.price.toStringAsFixed(2)}',
                      style: GoogleFonts.outfit(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF1A1A1A),
                      ),
                    ),
                    const SizedBox(width: 8),
                    if (widget.product.discount > 0) ...[
                      Text(
                        '\$${widget.product.originalPrice.toStringAsFixed(2)}',
                        style: GoogleFonts.outfit(
                          fontSize: 14,
                          color: Colors.grey.shade500,
                          decoration: TextDecoration.lineThrough,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '${widget.product.discount}% Off',
                        style: GoogleFonts.outfit(
                          color: const Color(0xFF388E3C),
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          // Variants Block (Mobile)
          Container(
            color: Colors.white,
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            child: _buildVariantsSelection(),
          ),
          const SizedBox(height: 8),
          // Offers Block
          Container(
            color: Colors.white,
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Available Offers',
                  style: GoogleFonts.outfit(fontSize: 14, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                _buildOfferItem('Bank Offer: 10% instant discount on Cards up to \$15.'),
                _buildOfferItem('Partner Offer: Get extra 5% off on voucher purchases.'),
              ],
            ),
          ),
          const SizedBox(height: 8),
          // Description Block
          Container(
            color: Colors.white,
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Description',
                  style: GoogleFonts.outfit(fontSize: 14, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(
                  widget.product.description,
                  style: GoogleFonts.outfit(
                    color: Colors.grey.shade700,
                    height: 1.5,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 16),
                Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: widget.product.tags
                      .map(
                        (tag) => Chip(
                          label: Text('#$tag'),
                          backgroundColor: const Color(0xFFF1F3F6),
                          side: BorderSide.none,
                          labelStyle: GoogleFonts.outfit(color: const Color(0xFF2874F0), fontSize: 11),
                        ),
                      )
                      .toList(),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          // Reviews Block (Mobile)
          Container(
            color: Colors.white,
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            child: _buildReviewsSection(),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildMobileBottomBar(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            Expanded(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFF9F00), // Yellow/Orange
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                  elevation: 0,
                ),
                onPressed: widget.product.inStock
                    ? () {
                        context.read<CartCubit>().addItem(
                              widget.product,
                              color: _selectedColor,
                              size: _selectedSize,
                              storage: _selectedStorage,
                              quantity: _quantity,
                            );
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Added to Cart!')),
                        );
                      }
                    : null,
                child: Text(
                  'ADD TO CART',
                  style: GoogleFonts.outfit(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFB641B), // Orange
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                  elevation: 0,
                ),
                onPressed: widget.product.inStock
                    ? () {
                        context.read<CartCubit>().addItem(
                              widget.product,
                              color: _selectedColor,
                              size: _selectedSize,
                              storage: _selectedStorage,
                              quantity: _quantity,
                            );
                        context.push('/shop/cart');
                      }
                    : null,
                child: Text(
                  'BUY NOW',
                  style: GoogleFonts.outfit(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOfferItem(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.local_offer, color: Color(0xFF388E3C), size: 14),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: GoogleFonts.outfit(fontSize: 12, color: Colors.black87),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVariantsSelection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.product.colors.isNotEmpty) ...[
          Text(
            'Color: ${_selectedColor ?? "Not Selected"}',
            style: GoogleFonts.outfit(fontWeight: FontWeight.bold, fontSize: 13, color: const Color(0xFF1A1A1A)),
          ),
          const SizedBox(height: 6),
          Wrap(
            spacing: 8,
            children: widget.product.colors.map((color) {
              final isSel = _selectedColor == color;
              return ChoiceChip(
                label: Text(color),
                selected: isSel,
                onSelected: (val) {
                  if (val) setState(() => _selectedColor = color);
                },
                selectedColor: const Color(0xFF2874F0).withValues(alpha: 0.15),
                labelStyle: GoogleFonts.outfit(
                  fontSize: 12,
                  color: isSel ? const Color(0xFF2874F0) : Colors.black87,
                  fontWeight: isSel ? FontWeight.bold : FontWeight.normal,
                ),
                checkmarkColor: const Color(0xFF2874F0),
              );
            }).toList(),
          ),
          const SizedBox(height: 16),
        ],
        if (widget.product.sizes.isNotEmpty) ...[
          Text(
            'Size: ${_selectedSize ?? "Not Selected"}',
            style: GoogleFonts.outfit(fontWeight: FontWeight.bold, fontSize: 13, color: const Color(0xFF1A1A1A)),
          ),
          const SizedBox(height: 6),
          Wrap(
            spacing: 8,
            children: widget.product.sizes.map((size) {
              final isSel = _selectedSize == size;
              return ChoiceChip(
                label: Text(size),
                selected: isSel,
                onSelected: (val) {
                  if (val) setState(() => _selectedSize = size);
                },
                selectedColor: const Color(0xFF2874F0).withValues(alpha: 0.15),
                labelStyle: GoogleFonts.outfit(
                  fontSize: 12,
                  color: isSel ? const Color(0xFF2874F0) : Colors.black87,
                  fontWeight: isSel ? FontWeight.bold : FontWeight.normal,
                ),
                checkmarkColor: const Color(0xFF2874F0),
              );
            }).toList(),
          ),
          const SizedBox(height: 16),
        ],
        if (widget.product.storage.isNotEmpty) ...[
          Text(
            'Storage: ${_selectedStorage ?? "Not Selected"}',
            style: GoogleFonts.outfit(fontWeight: FontWeight.bold, fontSize: 13, color: const Color(0xFF1A1A1A)),
          ),
          const SizedBox(height: 6),
          Wrap(
            spacing: 8,
            children: widget.product.storage.map((st) {
              final isSel = _selectedStorage == st;
              return ChoiceChip(
                label: Text(st),
                selected: isSel,
                onSelected: (val) {
                  if (val) setState(() => _selectedStorage = st);
                },
                selectedColor: const Color(0xFF2874F0).withValues(alpha: 0.15),
                labelStyle: GoogleFonts.outfit(
                  fontSize: 12,
                  color: isSel ? const Color(0xFF2874F0) : Colors.black87,
                  fontWeight: isSel ? FontWeight.bold : FontWeight.normal,
                ),
                checkmarkColor: const Color(0xFF2874F0),
              );
            }).toList(),
          ),
          const SizedBox(height: 16),
        ],
        Row(
          children: [
            Text(
              'Quantity:',
              style: GoogleFonts.outfit(fontWeight: FontWeight.bold, fontSize: 13, color: const Color(0xFF1A1A1A)),
            ),
            const SizedBox(width: 16),
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.remove, size: 16, color: Colors.black87),
                    onPressed: _quantity > 1 ? () => setState(() => _quantity--) : null,
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Text(
                      '$_quantity',
                      style: GoogleFonts.outfit(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.black87),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.add, size: 16, color: Colors.black87),
                    onPressed: () => setState(() => _quantity++),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildReviewsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Ratings & Reviews',
          style: GoogleFonts.outfit(fontSize: 16, fontWeight: FontWeight.bold, color: const Color(0xFF1A1A1A)),
        ),
        const SizedBox(height: 16),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              children: [
                Row(
                  textBaseline: TextBaseline.alphabetic,
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  children: [
                    Text(
                      _avgRating.toStringAsFixed(1),
                      style: GoogleFonts.outfit(fontSize: 32, fontWeight: FontWeight.bold, color: const Color(0xFF1A1A1A)),
                    ),
                    const SizedBox(width: 4),
                    const Icon(Icons.star, color: Colors.black54, size: 18),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  '$_reviewCount ratings',
                  style: GoogleFonts.outfit(color: Colors.grey.shade500, fontSize: 11),
                ),
              ],
            ),
            const SizedBox(width: 24),
            Expanded(
              child: Column(
                children: [
                  _buildBreakdownRow('5 ★', 0.72, const Color(0xFF388E3C)),
                  _buildBreakdownRow('4 ★', 0.18, const Color(0xFF388E3C)),
                  _buildBreakdownRow('3 ★', 0.06, const Color(0xFF388E3C)),
                  _buildBreakdownRow('2 ★', 0.02, Colors.orange),
                  _buildBreakdownRow('1 ★', 0.02, Colors.red),
                ],
              ),
            ),
          ],
        ),
        const Divider(height: 32),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFFF1F3F6),
            borderRadius: BorderRadius.circular(6),
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Rate this product & write a review',
                style: GoogleFonts.outfit(fontWeight: FontWeight.bold, fontSize: 13, color: const Color(0xFF1A1A1A)),
              ),
              const SizedBox(height: 10),
              Row(
                children: List.generate(5, (index) {
                  final starIndex = index + 1;
                  final isLit = starIndex <= _userRating;
                  return IconButton(
                    icon: Icon(
                      isLit ? Icons.star : Icons.star_border,
                      color: isLit ? const Color(0xFFFF9F00) : Colors.grey,
                    ),
                    onPressed: () => setState(() => _userRating = starIndex),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
                  );
                }),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'Your Name',
                  labelStyle: GoogleFonts.outfit(fontSize: 12, color: Colors.grey.shade600),
                  filled: true,
                  fillColor: Colors.white,
                  isDense: true,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(4), borderSide: BorderSide(color: Colors.grey.shade300)),
                  enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(4), borderSide: BorderSide(color: Colors.grey.shade300)),
                ),
                style: GoogleFonts.outfit(fontSize: 13),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _commentController,
                maxLines: 2,
                decoration: InputDecoration(
                  labelText: 'Share your review comment...',
                  labelStyle: GoogleFonts.outfit(fontSize: 12, color: Colors.grey.shade600),
                  filled: true,
                  fillColor: Colors.white,
                  isDense: true,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(4), borderSide: BorderSide(color: Colors.grey.shade300)),
                  enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(4), borderSide: BorderSide(color: Colors.grey.shade300)),
                ),
                style: GoogleFonts.outfit(fontSize: 13),
              ),
              const SizedBox(height: 12),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2874F0),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                  elevation: 0,
                ),
                onPressed: _submitReview,
                child: Text(
                  'SUBMIT REVIEW',
                  style: GoogleFonts.outfit(fontWeight: FontWeight.bold, fontSize: 11),
                ),
              ),
            ],
          ),
        ),
        const Divider(height: 32),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: _reviews.length,
          itemBuilder: (ctx, index) {
            final rev = _reviews[index];
            final rDate = rev['date'] as DateTime;
            final isVerified = rev['verified'] as bool;
            return Container(
              margin: const EdgeInsets.only(bottom: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: const Color(0xFF388E3C),
                          borderRadius: BorderRadius.circular(3),
                        ),
                        child: Row(
                          children: [
                            Text(
                              (rev['rating'] as double).toStringAsFixed(0),
                              style: GoogleFonts.outfit(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(width: 2),
                            const Icon(Icons.star, color: Colors.white, size: 8),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        rev['userName'] as String,
                        style: GoogleFonts.outfit(fontWeight: FontWeight.bold, fontSize: 12, color: const Color(0xFF1A1A1A)),
                      ),
                      if (isVerified) ...[
                        const SizedBox(width: 8),
                        const Icon(Icons.verified, color: Color(0xFF388E3C), size: 12),
                        const SizedBox(width: 2),
                        Text(
                          'Verified Purchaser',
                          style: GoogleFonts.outfit(color: const Color(0xFF388E3C), fontSize: 10, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    rev['comment'] as String,
                    style: GoogleFonts.outfit(fontSize: 13, color: Colors.black87, height: 1.4),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${rDate.day}/${rDate.month}/${rDate.year}',
                    style: GoogleFonts.outfit(color: Colors.grey.shade400, fontSize: 10),
                  ),
                  const Divider(height: 16),
                ],
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildBreakdownRow(String star, double pct, Color color) {
    return Container(
      margin: const EdgeInsets.only(bottom: 4),
      child: Row(
        children: [
          Text(star, style: GoogleFonts.outfit(fontSize: 11, color: Colors.black87)),
          const SizedBox(width: 8),
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(2),
              child: LinearProgressIndicator(
                value: pct,
                backgroundColor: Colors.grey.shade200,
                valueColor: AlwaysStoppedAnimation<Color>(color),
                minHeight: 5,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Text('${(pct * 100).toStringAsFixed(0)}%', style: GoogleFonts.outfit(fontSize: 10, color: Colors.grey.shade600)),
        ],
      ),
    );
  }
}

// ─── Pinned Cart Badge Icon ──────────────────────────────────────────────────
class _CartBadgeIcon extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        IconButton(
          icon: const Icon(Icons.shopping_cart, color: Colors.white),
          onPressed: () => context.push('/shop/cart'),
        ),
        BlocBuilder<CartCubit, CartState>(
          builder: (context, state) {
            if (state.totalItems == 0) return const SizedBox.shrink();
            return Positioned(
              top: 4,
              right: 4,
              child: Container(
                padding: const EdgeInsets.all(2),
                decoration: const BoxDecoration(
                  color: Color(0xFFFFBE00), // Flipkart Yellow
                  shape: BoxShape.circle,
                ),
                constraints: const BoxConstraints(
                  minWidth: 16,
                  minHeight: 16,
                ),
                child: Center(
                  child: Text(
                    '${state.totalItems}',
                    style: const TextStyle(
                      color: Color(0xFF2874F0),
                      fontSize: 9,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
