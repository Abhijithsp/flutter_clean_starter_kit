import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../showcase/presentation/screens/widget_showcase_screen.dart';
import '../../../shop/presentation/screens/shop_home_screen.dart';
import 'settings_tab.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _currentIndex = 0;

  static const _navItems = [
    (
      Icons.storefront_outlined,
      Icons.storefront_rounded,
      'Shop',
      AppColors.primary,
    ),
    (
      Icons.widgets_outlined,
      Icons.widgets_rounded,
      'Widgets',
      AppColors.pink,
    ),
    (
      Icons.settings_outlined,
      Icons.settings_rounded,
      'Settings',
      AppColors.cyan,
    ),
  ];

  Widget _buildTab(int index) {
    return switch (index) {
      0 => const ShopHomeScreen(),
      1 => const WidgetShowcaseScreen(),
      2 => const SettingsTab(),
      _ => const ShopHomeScreen(),
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: IndexedStack(
        index: _currentIndex,
        children: List.generate(_navItems.length, _buildTab),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withValues(alpha: 0.08),
              blurRadius: 20,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Row(
              children: List.generate(_navItems.length, (i) {
                final (icon, selectedIcon, label, color) = _navItems[i];
                final isSelected = i == _currentIndex;
                return Expanded(
                  child: GestureDetector(
                    onTap: () => setState(() => _currentIndex = i),
                    behavior: HitTestBehavior.opaque,
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.symmetric(vertical: 6),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Animated indicator + icon
                          AnimatedContainer(
                            duration: const Duration(milliseconds: 250),
                            curve: Curves.easeOutBack,
                            width: isSelected ? 52 : 40,
                            height: isSelected ? 36 : 32,
                            decoration: isSelected
                                ? BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [
                                        color.withValues(alpha: 0.15),
                                        color.withValues(alpha: 0.05),
                                      ],
                                    ),
                                    borderRadius: BorderRadius.circular(14),
                                  )
                                : null,
                            child: Icon(
                              isSelected ? selectedIcon : icon,
                              size: isSelected ? 24 : 22,
                              color: isSelected ? color : Colors.grey.shade400,
                            ),
                          ),
                          const SizedBox(height: 4),
                          AnimatedDefaultTextStyle(
                            duration: const Duration(milliseconds: 200),
                            style: GoogleFonts.outfit(
                              fontSize: 11,
                              fontWeight: isSelected
                                  ? FontWeight.w700
                                  : FontWeight.w500,
                              color: isSelected ? color : Colors.grey.shade400,
                            ),
                            child: Text(label),
                          ),
                          // Dot indicator
                          AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            margin: const EdgeInsets.only(top: 3),
                            width: isSelected ? 18 : 0,
                            height: 3,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(colors: [color, color.withValues(alpha: 0.4)]),
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }),
            ),
          ),
        ),
      ),
    );
  }
}
