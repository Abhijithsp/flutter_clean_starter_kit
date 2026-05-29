import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/widgets/app_widgets.dart';
import '../cubits/auth_cubit.dart';
import '../cubits/auth_state.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _onRegisterPressed() {
    final name = _nameController.text.trim();
    final email = _emailController.text.trim();
    final password = _passwordController.text;

    if (name.isEmpty) {
      AppSnackbar.show(context, message: 'Please enter your name', variant: AppSnackbarVariant.error);
      return;
    }
    if (email.isEmpty) {
      AppSnackbar.show(context, message: 'Please enter your email', variant: AppSnackbarVariant.error);
      return;
    }
    if (!email.contains('@')) {
      AppSnackbar.show(context, message: 'Please enter a valid email address', variant: AppSnackbarVariant.error);
      return;
    }
    if (password.isEmpty) {
      AppSnackbar.show(context, message: 'Please enter your password', variant: AppSnackbarVariant.error);
      return;
    }
    if (password.length < 6) {
      AppSnackbar.show(context, message: 'Password must be at least 6 characters', variant: AppSnackbarVariant.error);
      return;
    }

    context.read<AuthCubit>().register(name, email, password);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final gradientColors = isDark
        ? [const Color(0xFF0F172A), const Color(0xFF1E1B4B)]
        : [const Color(0xFFE0F2FE), const Color(0xFFE2F3EB), const Color(0xFFF1F5F9)];

    return Scaffold(
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
            top: -50,
            right: -50,
            child: Container(
              width: 250,
              height: 250,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFF2874F0).withValues(alpha: 0.1),
              ),
            ),
          ),
          Positioned(
            bottom: size.height * 0.1,
            left: -80,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFF388E3C).withValues(alpha: 0.08),
              ),
            ),
          ),

          // Back button
          Positioned(
            top: 40,
            left: 16,
            child: Container(
              decoration: BoxDecoration(
                color: isDark ? Colors.black26 : Colors.white60,
                shape: BoxShape.circle,
              ),
              child: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => Navigator.pop(context),
              ),
            ),
          ),

          // Main scrollable content
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                child: BlocConsumer<AuthCubit, AuthState>(
                  listener: (context, state) {
                    state.maybeWhen(
                      authenticated: (user) {
                        AppSnackbar.show(
                          context,
                          message: 'Account created successfully! Welcome, ${user.name}!',
                          variant: AppSnackbarVariant.success,
                        );
                        context.go('/dashboard');
                      },
                      error: (message) {
                        AppSnackbar.show(
                          context,
                          message: message,
                          variant: AppSnackbarVariant.error,
                        );
                      },
                      orElse: () {},
                    );
                  },
                  builder: (context, state) {
                    final isLoading = state.maybeWhen(
                      loading: () => true,
                      orElse: () => false,
                    );

                    return AnimatedFadeSlide(
                      delay: Duration.zero,
                      offset: const Offset(0, 40),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(24),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                          child: Container(
                            padding: const EdgeInsets.all(32),
                            decoration: BoxDecoration(
                              color: isDark
                                  ? Colors.black.withValues(alpha: 0.4)
                                  : Colors.white.withValues(alpha: 0.72),
                              borderRadius: BorderRadius.circular(24),
                              border: Border.all(
                                color: isDark
                                    ? Colors.white.withValues(alpha: 0.1)
                                    : Colors.white.withValues(alpha: 0.5),
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.06),
                                  blurRadius: 20,
                                  offset: const Offset(0, 10),
                                )
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                // Header Icon
                                AnimatedFadeSlide(
                                  delay: const Duration(milliseconds: 100),
                                  child: Center(
                                    child: Container(
                                      padding: const EdgeInsets.all(16),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFFF9F00).withValues(alpha: 0.1),
                                        shape: BoxShape.circle,
                                      ),
                                      child: const Icon(
                                        Icons.person_add_outlined,
                                        size: 40,
                                        color: Color(0xFFFF9F00),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 20),

                                // Title
                                AnimatedFadeSlide(
                                  delay: const Duration(milliseconds: 150),
                                  child: Text(
                                    'Create Account',
                                    style: GoogleFonts.outfit(
                                      fontSize: 26,
                                      fontWeight: FontWeight.bold,
                                      color: isDark ? Colors.white : const Color(0xFF0F172A),
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                AnimatedFadeSlide(
                                  delay: const Duration(milliseconds: 200),
                                  child: Text(
                                    'Register now to explore best deals and track orders',
                                    style: GoogleFonts.outfit(
                                      fontSize: 13,
                                      color: isDark ? Colors.white70 : Colors.grey.shade600,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                                const SizedBox(height: 32),

                                // Name Input
                                AnimatedFadeSlide(
                                  delay: const Duration(milliseconds: 250),
                                  child: AppTextField(
                                    controller: _nameController,
                                    label: 'Full Name',
                                    hint: 'enter name...',
                                    prefixIcon: Icons.person_outline,
                                    focusedBorderColor: const Color(0xFFFF9F00),
                                  ),
                                ),
                                const SizedBox(height: 16),

                                // Email Input
                                AnimatedFadeSlide(
                                  delay: const Duration(milliseconds: 300),
                                  child: AppTextField(
                                    controller: _emailController,
                                    label: 'Email Address',
                                    hint: 'enter email...',
                                    prefixIcon: Icons.email_outlined,
                                    keyboardType: TextInputType.emailAddress,
                                    focusedBorderColor: const Color(0xFFFF9F00),
                                  ),
                                ),
                                const SizedBox(height: 16),

                                // Password Input
                                AnimatedFadeSlide(
                                  delay: const Duration(milliseconds: 350),
                                  child: AppPasswordField(
                                    controller: _passwordController,
                                    label: 'Password',
                                    focusedBorderColor: const Color(0xFFFF9F00),
                                  ),
                                ),
                                const SizedBox(height: 32),

                                // Register Button
                                AnimatedFadeSlide(
                                  delay: const Duration(milliseconds: 400),
                                  child: Container(
                                    height: 52,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(14),
                                      gradient: const LinearGradient(
                                        colors: [Color(0xFFFF9F00), Color(0xFFFF8F00)],
                                      ),
                                      boxShadow: [
                                        BoxShadow(
                                          color: const Color(0xFFFF9F00).withValues(alpha: 0.24),
                                          blurRadius: 8,
                                          offset: const Offset(0, 4),
                                        )
                                      ],
                                    ),
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.transparent,
                                        foregroundColor: Colors.white,
                                        shadowColor: Colors.transparent,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(14),
                                        ),
                                      ),
                                      onPressed: isLoading ? null : _onRegisterPressed,
                                      child: isLoading
                                          ? const SizedBox(
                                              width: 20,
                                              height: 20,
                                              child: CircularProgressIndicator(
                                                strokeWidth: 2,
                                                color: Colors.white,
                                              ),
                                            )
                                          : Text(
                                              'SIGN UP',
                                              style: GoogleFonts.outfit(
                                                fontWeight: FontWeight.bold,
                                                letterSpacing: 1.1,
                                                fontSize: 14,
                                              ),
                                            ),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 28),

                                // Login Link
                                AnimatedFadeSlide(
                                  delay: const Duration(milliseconds: 450),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        "Already have an account? ",
                                        style: GoogleFonts.outfit(
                                          fontSize: 13,
                                          color: isDark ? Colors.white60 : Colors.grey.shade600,
                                        ),
                                      ),
                                      GestureDetector(
                                        onTap: isLoading
                                            ? null
                                            : () {
                                                Navigator.pop(context);
                                              },
                                        child: Text(
                                          'Login',
                                          style: GoogleFonts.outfit(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 13,
                                            color: const Color(0xFFFF9F00),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
