import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/widgets/app_widgets.dart';
import '../cubits/auth_cubit.dart';
import '../cubits/auth_state.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool _delayCompleted = false;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          _delayCompleted = true;
        });
        _checkStateAndNavigate(context.read<AuthCubit>().state);
      }
    });
  }

  void _checkStateAndNavigate(AuthState state) {
    if (!_delayCompleted) return;

    state.maybeWhen(
      authenticated: (user) => context.go('/dashboard'),
      unauthenticated: () => context.go('/login'),
      error: (_) => context.go('/login'),
      orElse: () {
        // Keep waiting in splash until state changes from loading
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final gradientColors = isDark
        ? [const Color(0xFF0F172A), const Color(0xFF1E1B4B)]
        : [const Color(0xFFE0F2FE), const Color(0xFFE2F3EB), const Color(0xFFF1F5F9)];

    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        _checkStateAndNavigate(state);
      },
      child: Scaffold(
        body: Stack(
          children: [
            // Background cooling gradient
            Container(
              width: double.infinity,
              height: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: gradientColors,
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
            ),

            // Decorative background glowing spheres
            Positioned(
              top: size.height * 0.2,
              left: -40,
              child: Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(0xFF2874F0).withValues(alpha: 0.1),
                ),
              ),
            ),
            Positioned(
              bottom: size.height * 0.2,
              right: -40,
              child: Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(0xFF388E3C).withValues(alpha: 0.08),
                ),
              ),
            ),

            // Logo & Title
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AnimatedFadeSlide(
                    delay: Duration.zero,
                    duration: const Duration(milliseconds: 800),
                    offset: const Offset(0.0, 40.0),
                    child: Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: isDark ? 0.08 : 0.8),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.05),
                            blurRadius: 15,
                            offset: const Offset(0, 8),
                          )
                        ],
                      ),
                      child: const Icon(
                        Icons.shopping_bag,
                        size: 64,
                        color: Color(0xFF2874F0),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  AnimatedFadeSlide(
                    delay: const Duration(milliseconds: 200),
                    duration: const Duration(milliseconds: 600),
                    child: Text(
                      'PREMIUM STORE',
                      style: GoogleFonts.outfit(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 2.0,
                        color: isDark ? Colors.white : const Color(0xFF0F172A),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  AnimatedFadeSlide(
                    delay: const Duration(milliseconds: 350),
                    duration: const Duration(milliseconds: 500),
                    child: Text(
                      'Responsive Clean starter kit',
                      style: GoogleFonts.outfit(
                        fontSize: 14,
                        color: isDark ? Colors.white54 : Colors.grey.shade600,
                      ),
                    ),
                  ),
                  const SizedBox(height: 48),
                  // Sleek loading bar
                  AnimatedFadeSlide(
                    delay: const Duration(milliseconds: 500),
                    child: SizedBox(
                      width: 140,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: const LinearProgressIndicator(
                          color: Color(0xFF2874F0),
                          backgroundColor: Colors.white24,
                          minHeight: 3,
                        ),
                      ),
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
}
