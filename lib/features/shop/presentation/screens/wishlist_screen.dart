import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../domain/entities/product.dart';
import '../cubits/cart_cubit.dart';
import '../cubits/wishlist_cubit.dart';
import '../cubits/wishlist_state.dart';

// ═══════════════════════════════════════════════════════════════════════════
// WISHLIST SCREEN (Flipkart-Style)
// ═══════════════════════════════════════════════════════════════════════════

class WishlistScreen extends StatelessWidget {
  const WishlistScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF1F3F6),
      appBar: AppBar(
        backgroundColor: const Color(0xFF2874F0),
        iconTheme: const IconThemeData(color: Colors.white),
        title: Text(
          'My Wishlist',
          style: GoogleFonts.outfit(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: BlocBuilder<WishlistCubit, WishlistState>(
        builder: (context, state) {
          if (state.items.isEmpty) {
            return _buildEmptyWishlist(context);
          }
          return ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: state.items.length,
            itemBuilder: (context, i) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: _WishlistCard(product: state.items[i]),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildEmptyWishlist(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.favorite_border_rounded,
            size: 80,
            color: Colors.grey,
          ),
          const SizedBox(height: 16),
          Text(
            'Your Wishlist is empty!',
            style: GoogleFonts.outfit(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF1A1A1A),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Save items that you like to buy later.',
            style: GoogleFonts.outfit(
              color: Colors.grey.shade500,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF2874F0),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 14),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
              elevation: 0,
            ),
            onPressed: () => context.go('/shop'),
            child: Text(
              'Shop Now',
              style: GoogleFonts.outfit(fontWeight: FontWeight.bold, fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }
}

class _WishlistCard extends StatelessWidget {
  final Product product;
  const _WishlistCard({required this.product});

  @override
  Widget build(BuildContext context) {
    final wishlistCubit = context.read<WishlistCubit>();
    final cartCubit = context.read<CartCubit>();

    return GestureDetector(
      onTap: () => context.push('/shop/products', extra: product),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(4),
          border: Border.all(color: Colors.grey.shade200),
        ),
        padding: const EdgeInsets.all(12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product Image
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: CachedNetworkImage(
                imageUrl: product.imageUrl,
                width: 80,
                height: 90,
                fit: BoxFit.cover,
                errorWidget: (context, url, error) => Container(
                  width: 80,
                  height: 90,
                  color: Colors.grey.shade100,
                  child: const Icon(Icons.image_outlined, color: Colors.grey),
                ),
              ),
            ),
            const SizedBox(width: 12),
            // Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          product.name,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.outfit(
                            fontWeight: FontWeight.w600,
                            fontSize: 13,
                            color: const Color(0xFF1A1A1A),
                            height: 1.3,
                          ),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.favorite, color: Colors.red, size: 20),
                        onPressed: () => wishlistCubit.toggleProduct(product),
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    product.category,
                    style: GoogleFonts.outfit(
                      color: Colors.grey.shade500,
                      fontSize: 11,
                    ),
                  ),
                  const SizedBox(height: 12),
                  // Price and Move to Cart button
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '\$${product.price.toStringAsFixed(2)}',
                        style: GoogleFonts.outfit(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: const Color(0xFF1A1A1A),
                        ),
                      ),
                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFFF9F00), // Flipkart Yellow/Orange
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                          elevation: 0,
                        ),
                        onPressed: product.inStock
                            ? () {
                                // Default selection for variants is chosen automatically if product has them
                                final defaultColor = product.colors.isNotEmpty ? product.colors.first : null;
                                final defaultSize = product.sizes.isNotEmpty ? product.sizes.first : null;
                                final defaultStorage = product.storage.isNotEmpty ? product.storage.first : null;
                                
                                wishlistCubit.moveToCart(
                                  product, 
                                  cartCubit,
                                  color: defaultColor,
                                  size: defaultSize,
                                  storage: defaultStorage,
                                );
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Moved to Cart!')),
                                );
                              }
                            : null,
                        icon: const Icon(Icons.shopping_cart_outlined, size: 14),
                        label: Text(
                          product.inStock ? 'MOVE TO CART' : 'OUT OF STOCK',
                          style: GoogleFonts.outfit(
                            fontWeight: FontWeight.bold,
                            fontSize: 10,
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
  }
}
