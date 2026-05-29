import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/widgets/app_widgets.dart';
import '../../../../core/services/notification_service.dart';
import '../../../auth/presentation/cubits/auth_cubit.dart';
import '../../../auth/presentation/cubits/auth_state.dart';

class SettingsTab extends StatefulWidget {
  const SettingsTab({super.key});

  @override
  State<SettingsTab> createState() => _SettingsTabState();
}

class _SettingsTabState extends State<SettingsTab> {
  bool _notifications = true;
  bool _darkMode = false;
  bool _biometrics = false;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final authState = context.watch<AuthCubit>().state;
    final user = authState.maybeWhen(
      authenticated: (u) => u,
      orElse: () => null,
    );
    
    final name = user?.name ?? 'John Doe';
    final email = user?.email ?? 'john.doe@example.com';
    final initials = name.isNotEmpty
        ? name.split(' ').where((s) => s.isNotEmpty).map((s) => s[0]).take(2).join().toUpperCase()
        : 'JD';

    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        state.maybeWhen(
          unauthenticated: () {
            context.go('/login');
          },
          error: (message) {
            AppSnackbar.show(context, message: message, variant: AppSnackbarVariant.error);
          },
          orElse: () {},
        );
      },
      child: Scaffold(
        backgroundColor: cs.surfaceContainerLowest,
        appBar: AppBar(title: const Text('Settings'), centerTitle: true),
        body: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Profile card
            AppCard(
              variant: AppCardVariant.elevated,
              child: Row(
                children: [
                  AppAvatar(initials: initials, size: 56, showOnlineIndicator: true),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(name,
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(fontWeight: FontWeight.bold)),
                        Text(email,
                            style: TextStyle(fontSize: 13, color: cs.onSurfaceVariant)),
                        const SizedBox(height: 6),
                        AppBadge(label: 'Pro Plan', variant: AppBadgeVariant.primary, icon: Icons.star),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.edit_outlined, color: cs.primary),
                    onPressed: () => AppSnackbar.show(context, message: 'Edit profile', variant: AppSnackbarVariant.info),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            AppSectionHeader(title: 'Preferences', leading: Icon(Icons.tune_rounded, size: 18, color: cs.primary)),
            AppCard(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Column(
                children: [
                  SwitchListTile.adaptive(
                    title: const Text('Push Notifications'),
                    subtitle: const Text('Receive alerts and updates'),
                    secondary: Icon(Icons.notifications_outlined, color: cs.primary),
                    value: _notifications,
                    onChanged: (val) => setState(() => _notifications = val),
                  ),
                  if (_notifications) ...[
                    const Divider(height: 1, indent: 16, endIndent: 16),
                    AppListTile(
                      title: 'Send Test Notification',
                      subtitle: 'Test the local notifications API',
                      leading: Icon(Icons.send_rounded, color: cs.primary),
                      onTap: () {
                        NotificationService.showNotification(
                          title: 'Test Notification 🔔',
                          body: 'This is a test notification from the Settings panel.',
                        );
                      },
                    ),
                  ],
                  const Divider(height: 1, indent: 16, endIndent: 16),
                  SwitchListTile.adaptive(
                    title: const Text('Dark Mode'),
                    subtitle: const Text('Switch to dark appearance'),
                    secondary: Icon(Icons.dark_mode_outlined, color: cs.primary),
                    value: _darkMode,
                    onChanged: (val) => setState(() => _darkMode = val),
                  ),
                  const Divider(height: 1, indent: 16, endIndent: 16),
                  SwitchListTile.adaptive(
                    title: const Text('Biometric Login'),
                    subtitle: const Text('Use fingerprint or Face ID'),
                    secondary: Icon(Icons.fingerprint_rounded, color: cs.primary),
                    value: _biometrics,
                    onChanged: (val) => setState(() => _biometrics = val),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            AppSectionHeader(title: 'Account', leading: Icon(Icons.manage_accounts_outlined, size: 18, color: cs.primary)),
            AppCard(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Column(
                children: [
                  AppListTile(title: 'Change Password', leading: Icon(Icons.lock_outline, color: cs.primary), onTap: () {}, showDivider: true),
                  AppListTile(title: 'Privacy & Security', leading: Icon(Icons.security_outlined, color: cs.primary), onTap: () {}, showDivider: true),
                  AppListTile(title: 'Billing & Payments', leading: Icon(Icons.credit_card_outlined, color: cs.primary), onTap: () {}, showDivider: true),
                  AppListTile(title: 'Connected Apps', leading: Icon(Icons.link_rounded, color: cs.primary), onTap: () {}),
                ],
              ),
            ),
            const SizedBox(height: 24),

            AppButton(
              label: 'Sign Out',
              variant: AppButtonVariant.outlined,
              fullWidth: true,
              prefixIcon: Icons.logout_rounded,
              onPressed: () => AppDialog.show(
                context,
                title: 'Sign Out?',
                message: 'Are you sure you want to sign out of your account?',
                icon: Icons.logout_rounded,
                confirmLabel: 'Sign Out',
                cancelLabel: 'Cancel',
                onConfirm: () {
                  context.read<AuthCubit>().logout();
                },
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}
