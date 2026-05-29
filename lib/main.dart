import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';
import 'core/services/notification_service.dart';
import 'features/auth/data/repositories/auth_repository_impl.dart';
import 'features/auth/data/sources/auth_local_data_source.dart';
import 'features/auth/domain/repositories/auth_repository.dart';
import 'features/auth/presentation/cubits/auth_cubit.dart';
import 'features/shop/data/repositories/shop_repository_impl.dart';
import 'features/shop/data/sources/shop_data_source.dart';
import 'features/shop/domain/repositories/shop_repository.dart';
import 'features/shop/presentation/cubits/cart_cubit.dart';
import 'features/shop/presentation/cubits/shop_cubit.dart';
import 'features/shop/presentation/cubits/wishlist_cubit.dart';
import 'features/shop/presentation/cubits/order_history_cubit.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await NotificationService.init();

  // ── Auth dependencies ────────────────────────────────────────────────────────
  final sharedPreferences = await SharedPreferences.getInstance();
  final authLocalDataSource = AuthLocalDataSourceImpl(sharedPreferences);
  final authRepository = AuthRepositoryImpl(authLocalDataSource);

  // ── Shop dependencies ────────────────────────────────────────────────────────
  // To connect a real backend, replace ShopLocalDataSource with ShopRemoteDataSource(dio)
  final shopDataSource = ShopLocalDataSource();
  final shopRepository = ShopRepositoryImpl(shopDataSource);

  runApp(
    MultiRepositoryProvider(
      providers: [
        RepositoryProvider<AuthRepository>.value(value: authRepository),
        RepositoryProvider<ShopRepository>.value(value: shopRepository),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider<AuthCubit>(
            create: (_) => AuthCubit(authRepository: authRepository)..checkSession(),
          ),
          BlocProvider<ShopCubit>(
            create: (_) => ShopCubit(shopRepository: shopRepository),
          ),
          // CartCubit is global — persists across all shop screens
          BlocProvider<CartCubit>(create: (_) => CartCubit()),
          BlocProvider<WishlistCubit>(create: (_) => WishlistCubit()),
          BlocProvider<OrderHistoryCubit>(create: (_) => OrderHistoryCubit()),
        ],
        child: const MyApp(),
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Flutter Clean Starter',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      routerConfig: appRouter,
      debugShowCheckedModeBanner: false,
    );
  }
}
