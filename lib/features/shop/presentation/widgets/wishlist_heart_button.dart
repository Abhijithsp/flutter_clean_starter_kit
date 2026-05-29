import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/product.dart';
import '../cubits/wishlist_cubit.dart';
import '../cubits/wishlist_state.dart';

class WishlistHeartButton extends StatelessWidget {
  final Product product;
  final double size;
  const WishlistHeartButton({
    super.key,
    required this.product,
    this.size = 16,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WishlistCubit, WishlistState>(
      builder: (context, state) {
        final isFav = context.read<WishlistCubit>().containsProduct(product.id);
        return GestureDetector(
          onTap: () {
            context.read<WishlistCubit>().toggleProduct(product);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  isFav ? 'Removed from Wishlist' : 'Added to Wishlist!',
                ),
                duration: const Duration(seconds: 1),
              ),
            );
          },
          child: Container(
            padding: const EdgeInsets.all(5),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.9),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                )
              ],
            ),
            child: Icon(
              isFav ? Icons.favorite : Icons.favorite_border_rounded,
              color: isFav ? Colors.red : Colors.grey.shade600,
              size: size,
            ),
          ),
        );
      },
    );
  }
}
