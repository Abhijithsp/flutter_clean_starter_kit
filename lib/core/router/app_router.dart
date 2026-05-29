import 'package:go_router/go_router.dart';

import '../../features/auth/presentation/screens/splash_screen.dart';
import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/auth/presentation/screens/register_screen.dart';
import '../../features/dashboard/presentation/screens/dashboard_screen.dart';
import '../../features/shop/domain/entities/product.dart';
import '../../features/shop/domain/entities/shop_order.dart';
import '../../features/shop/presentation/screens/cart_screen.dart';
import '../../features/shop/presentation/screens/payment_screen.dart';
import '../../features/shop/presentation/screens/payment_success_screen.dart';
import '../../features/shop/presentation/screens/product_list_screen.dart';
import '../../features/shop/presentation/screens/wishlist_screen.dart';
import '../../features/shop/presentation/screens/order_history_screen.dart';
import '../../features/shop/presentation/screens/order_tracking_screen.dart';

final appRouter = GoRouter(
  initialLocation: '/splash',
  routes: [
    GoRoute(path: '/splash', builder: (context, state) => const SplashScreen()),
    GoRoute(path: '/login', builder: (context, state) => const LoginScreen()),
    GoRoute(path: '/register', builder: (context, state) => const RegisterScreen()),
    GoRoute(path: '/dashboard', builder: (context, state) => const DashboardScreen()),
    GoRoute(path: '/shop', builder: (context, state) => const DashboardScreen()),
    GoRoute(
      path: '/shop/products',
      builder: (context, state) => ProductListScreen(
        initialProduct: state.extra as Product?,
      ),
    ),
    GoRoute(path: '/shop/cart', builder: (context, state) => const CartScreen()),
    GoRoute(path: '/shop/payment', builder: (context, state) => const PaymentScreen()),
    GoRoute(path: '/shop/success', builder: (context, state) => PaymentSuccessScreen(order: state.extra as ShopOrder?)),
    GoRoute(path: '/shop/wishlist', builder: (context, state) => const WishlistScreen()),
    GoRoute(path: '/shop/order-history', builder: (context, state) => const OrderHistoryScreen()),
    GoRoute(
      path: '/shop/order-tracking',
      builder: (context, state) => OrderTrackingScreen(
        initialOrder: state.extra as ShopOrder,
      ),
    ),
  ],
);
