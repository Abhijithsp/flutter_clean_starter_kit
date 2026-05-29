import 'package:flutter/material.dart';
import '../../../../core/widgets/app_widgets.dart';

class WidgetShowcaseScreen extends StatefulWidget {
  const WidgetShowcaseScreen({super.key});

  @override
  State<WidgetShowcaseScreen> createState() => _WidgetShowcaseScreenState();
}

class _WidgetShowcaseScreenState extends State<WidgetShowcaseScreen> {
  final _emailCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  final _searchCtrl = TextEditingController();
  final _notesCtrl = TextEditingController();

  String? _selectedRole;
  Set<String> _selectedSegment = {'monthly'};
  bool _isLoadingBtn = false;

  final List<Map<String, dynamic>> _gridItems = [
    {'icon': Icons.people_alt_rounded, 'label': 'Users', 'value': '2,483', 'color': Color(0xFF6750A4)},
    {'icon': Icons.shopping_bag_rounded, 'label': 'Orders', 'value': '1,204', 'color': Color(0xFF006E1C)},
    {'icon': Icons.bar_chart_rounded, 'label': 'Revenue', 'value': '\$48K', 'color': Color(0xFF8B3DFF)},
    {'icon': Icons.star_rounded, 'label': 'Rating', 'value': '4.9', 'color': Color(0xFFE67E00)},
  ];

  final List<Map<String, dynamic>> _contacts = [
    {'name': 'Alice Johnson', 'detail': 'Product Designer', 'initials': 'AJ', 'status': 'Active', 'variant': AppBadgeVariant.success},
    {'name': 'Bob Smith', 'detail': 'Backend Engineer', 'initials': 'BS', 'status': 'Away', 'variant': AppBadgeVariant.warning},
    {'name': 'Carol White', 'detail': 'Marketing Lead', 'initials': 'CW', 'status': 'Offline', 'variant': AppBadgeVariant.neutral},
    {'name': 'David Lee', 'detail': 'DevOps Engineer', 'initials': 'DL', 'status': 'Active', 'variant': AppBadgeVariant.success},
  ];

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    _searchCtrl.dispose();
    _notesCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: cs.surfaceContainerLowest,
      appBar: AppBar(
        title: const Text('Widget Showcase'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () => AppSnackbar.show(
              context,
              message: 'No new notifications',
              variant: AppSnackbarVariant.info,
            ),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // ── Stats Grid ──────────────────────────────────────────────────
          AppSectionHeader(
            title: 'Stats Cards (Grid)',
            leading: Icon(Icons.grid_view_rounded, size: 18, color: cs.primary),
            actionLabel: 'View All',
            onAction: () {},
          ),
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 1.5,
            children: _gridItems
                .map((item) => AppGridCard(
                      icon: item['icon'] as IconData,
                      label: item['label'] as String,
                      value: item['value'] as String,
                      color: item['color'] as Color,
                      onTap: () => AppSnackbar.show(
                        context,
                        message: '${item['label']} tapped',
                        variant: AppSnackbarVariant.success,
                      ),
                    ))
                .toList(),
          ),
          const SizedBox(height: 24),

          // ── Stats Cards (Horizontal) ────────────────────────────────────
          AppSectionHeader(
            title: 'Stats Cards (Scroll)',
            leading: Icon(Icons.insights_rounded, size: 18, color: cs.primary),
          ),
          SizedBox(
            height: 140,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                SizedBox(
                  width: 180,
                  child: AppStatsCard(
                    label: 'Total Users',
                    value: '12,543',
                    icon: Icons.people_rounded,
                    accentColor: cs.primary,
                    trend: '+12%',
                    isTrendUp: true,
                  ),
                ),
                const SizedBox(width: 12),
                SizedBox(
                  width: 180,
                  child: AppStatsCard(
                    label: 'Active Sessions',
                    value: '3,128',
                    icon: Icons.sensors_rounded,
                    accentColor: Colors.green,
                    trend: '+5%',
                    isTrendUp: true,
                  ),
                ),
                const SizedBox(width: 12),
                SizedBox(
                  width: 180,
                  child: AppStatsCard(
                    label: 'Churn Rate',
                    value: '2.4%',
                    icon: Icons.moving_rounded,
                    accentColor: Colors.orange,
                    trend: '-0.3%',
                    isTrendUp: false,
                  ),
                ),
                const SizedBox(width: 12),
                SizedBox(
                  width: 180,
                  child: AppStatsCard(
                    label: 'Revenue',
                    value: '\$92.4K',
                    icon: Icons.attach_money_rounded,
                    accentColor: Colors.teal,
                    trend: '+18%',
                    isTrendUp: true,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // ── Info Cards ──────────────────────────────────────────────────
          AppSectionHeader(
            title: 'Info Cards',
            leading: Icon(Icons.info_outline, size: 18, color: cs.primary),
          ),
          AppInfoCard(
            icon: Icons.shield_outlined,
            title: 'Security Status',
            subtitle: 'Your account is secured with 2FA enabled.',
            iconColor: Colors.green,
            onTap: () {},
          ),
          const SizedBox(height: 8),
          AppInfoCard(
            icon: Icons.cloud_sync_outlined,
            title: 'Backup Status',
            subtitle: 'Last synced 2 minutes ago',
            iconColor: cs.primary,
            onTap: () {},
          ),
          const SizedBox(height: 8),
          AppCard(
            variant: AppCardVariant.outlined,
            child: Row(
              children: [
                AppAvatar(initials: 'JD', size: 48, showOnlineIndicator: true),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('John Doe',
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium
                              ?.copyWith(fontWeight: FontWeight.w700)),
                      Text('john@example.com',
                          style: TextStyle(color: cs.onSurfaceVariant, fontSize: 13)),
                    ],
                  ),
                ),
                AppBadge(
                  label: 'Admin',
                  variant: AppBadgeVariant.primary,
                  icon: Icons.verified,
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // ── ListView ─────────────────────────────────────────────────────
          AppSectionHeader(
            title: 'List View (Contacts)',
            leading: Icon(Icons.list_alt_rounded, size: 18, color: cs.primary),
            actionLabel: 'See All',
            onAction: () {},
          ),
          AppCard(
            variant: AppCardVariant.elevated,
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 0),
            child: Column(
              children: _contacts.asMap().entries.map((e) {
                final item = e.value;
                return AppContactTile(
                  name: item['name'] as String,
                  detail: item['detail'] as String,
                  initials: item['initials'] as String,
                  statusLabel: item['status'] as String,
                  statusVariant: item['variant'] as AppBadgeVariant,
                  onTap: () => AppSnackbar.show(
                    context,
                    message: '${item['name']} selected',
                    variant: AppSnackbarVariant.info,
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 24),

          // ── Avatars ──────────────────────────────────────────────────────
          AppSectionHeader(
            title: 'Avatars',
            leading: Icon(Icons.account_circle_outlined, size: 18, color: cs.primary),
          ),
          AppCard(
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    AppAvatar(initials: 'AB', size: 32),
                    AppAvatar(initials: 'CD', size: 40, showOnlineIndicator: true),
                    AppAvatar(initials: 'EF', size: 52, backgroundColor: Colors.orange.shade200),
                    AppAvatar(initials: 'GH', size: 64, showOnlineIndicator: true),
                    AppAvatar(
                      imageUrl: 'https://i.pravatar.cc/150?img=5',
                      size: 52,
                      showOnlineIndicator: true,
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    const Text('Group:', style: TextStyle(fontWeight: FontWeight.w500)),
                    const SizedBox(width: 12),
                    AppAvatarGroup(
                      initials: ['AB', 'CD', 'EF', 'GH', 'IJ', 'KL'],
                      maxVisible: 4,
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // ── Badges ───────────────────────────────────────────────────────
          AppSectionHeader(
            title: 'Badges',
            leading: Icon(Icons.label_outline, size: 18, color: cs.primary),
          ),
          AppCard(
            child: Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                AppBadge(label: 'Primary', variant: AppBadgeVariant.primary),
                AppBadge(label: 'Success', variant: AppBadgeVariant.success, icon: Icons.check),
                AppBadge(label: 'Warning', variant: AppBadgeVariant.warning, icon: Icons.warning_amber),
                AppBadge(label: 'Error', variant: AppBadgeVariant.error, icon: Icons.error_outline),
                AppBadge(label: 'Info', variant: AppBadgeVariant.info, icon: Icons.info_outline),
                AppBadge(label: 'Neutral', variant: AppBadgeVariant.neutral),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // ── Chips ────────────────────────────────────────────────────────
          AppSectionHeader(
            title: 'Chips & Filters',
            leading: Icon(Icons.filter_alt_outlined, size: 18, color: cs.primary),
          ),
          AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Filter (single select)',
                    style: TextStyle(color: cs.onSurfaceVariant, fontSize: 12)),
                const SizedBox(height: 8),
                AppChipGroup(
                  options: const ['All', 'Design', 'Dev', 'Marketing', 'Support'],
                  onChanged: (selected) {},
                ),
                const SizedBox(height: 12),
                Text('Filter (multi select)',
                    style: TextStyle(color: cs.onSurfaceVariant, fontSize: 12)),
                const SizedBox(height: 8),
                AppChipGroup(
                  options: const ['Flutter', 'Dart', 'Firebase', 'Riverpod', 'Figma'],
                  multiSelect: true,
                  onChanged: (selected) {},
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // ── Text Fields ──────────────────────────────────────────────────
          AppSectionHeader(
            title: 'Text Fields',
            leading: Icon(Icons.text_fields_rounded, size: 18, color: cs.primary),
          ),
          AppCard(
            child: Column(
              children: [
                AppTextField(
                  label: 'Email Address',
                  hint: 'you@example.com',
                  controller: _emailCtrl,
                  prefixIcon: Icons.email_outlined,
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 12),
                AppPasswordField(controller: _passwordCtrl),
                const SizedBox(height: 12),
                AppSearchField(
                  controller: _searchCtrl,
                  onChanged: (_) => setState(() {}),
                  onClear: () => setState(() {}),
                ),
                const SizedBox(height: 12),
                AppTextField(
                  label: 'Notes',
                  hint: 'Write something...',
                  controller: _notesCtrl,
                  maxLines: 4,
                  prefixIcon: Icons.edit_note_rounded,
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // ── Dropdowns & Pickers ──────────────────────────────────────────
          AppSectionHeader(
            title: 'Dropdowns & Pickers',
            leading: Icon(Icons.expand_circle_down_outlined, size: 18, color: cs.primary),
          ),
          AppCard(
            child: Column(
              children: [
                AppDropdown<String>(
                  label: 'Select Role',
                  hint: 'Choose a role',
                  prefixIcon: Icons.badge_outlined,
                  value: _selectedRole,
                  items: const [
                    DropdownMenuItem(value: 'admin', child: Text('Admin')),
                    DropdownMenuItem(value: 'editor', child: Text('Editor')),
                    DropdownMenuItem(value: 'viewer', child: Text('Viewer')),
                    DropdownMenuItem(value: 'guest', child: Text('Guest')),
                  ],
                  onChanged: (val) => setState(() => _selectedRole = val),
                ),
                const SizedBox(height: 16),
                AppSegmentedPicker<String>(
                  segments: const {
                    'weekly': Text('Weekly'),
                    'monthly': Text('Monthly'),
                    'yearly': Text('Yearly'),
                  },
                  selected: _selectedSegment,
                  onSelectionChanged: (val) => setState(() => _selectedSegment = val),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // ── Buttons ──────────────────────────────────────────────────────
          AppSectionHeader(
            title: 'Buttons',
            leading: Icon(Icons.smart_button_rounded, size: 18, color: cs.primary),
          ),
          AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Variants row
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    AppButton(label: 'Filled', variant: AppButtonVariant.filled, onPressed: () {}),
                    AppButton(label: 'Tonal', variant: AppButtonVariant.tonal, onPressed: () {}),
                    AppButton(label: 'Outlined', variant: AppButtonVariant.outlined, onPressed: () {}),
                    AppButton(label: 'Text', variant: AppButtonVariant.text, onPressed: () {}),
                    AppButton(label: 'Elevated', variant: AppButtonVariant.elevated, onPressed: () {}),
                  ],
                ),
                const SizedBox(height: 12),
                // Sizes row
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    AppButton(label: 'Small', size: AppButtonSize.small, onPressed: () {}),
                    AppButton(label: 'Medium', size: AppButtonSize.medium, onPressed: () {}),
                    AppButton(label: 'Large', size: AppButtonSize.large, onPressed: () {}),
                  ],
                ),
                const SizedBox(height: 12),
                // With icons
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    AppButton(
                      label: 'Add Item',
                      prefixIcon: Icons.add,
                      onPressed: () => AppSnackbar.show(
                        context,
                        message: 'Item added!',
                        variant: AppSnackbarVariant.success,
                      ),
                    ),
                    AppButton(
                      label: 'Share',
                      suffixIcon: Icons.share,
                      variant: AppButtonVariant.outlined,
                      onPressed: () {},
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                // Loading + full width
                AppButton(
                  label: 'Save Changes',
                  fullWidth: true,
                  isLoading: _isLoadingBtn,
                  prefixIcon: Icons.save_outlined,
                  onPressed: () async {
                    final messenger = ScaffoldMessenger.of(context);
                    setState(() => _isLoadingBtn = true);
                    await Future.delayed(const Duration(seconds: 2));
                    if (!mounted) return;
                    setState(() => _isLoadingBtn = false);
                    AppSnackbar.showWithMessenger(
                      messenger,
                      message: 'Changes saved successfully!',
                      variant: AppSnackbarVariant.success,
                      actionLabel: 'Undo',
                    );
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // ── Dialogs & Snackbars ──────────────────────────────────────────
          AppSectionHeader(
            title: 'Dialogs & Snackbars',
            leading: Icon(Icons.chat_bubble_outline_rounded, size: 18, color: cs.primary),
          ),
          AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    AppButton(
                      label: 'Show Dialog',
                      prefixIcon: Icons.open_in_new_rounded,
                      onPressed: () => AppDialog.show(
                        context,
                        title: 'Delete Item?',
                        message: 'This action cannot be undone. Are you sure you want to delete this item?',
                        icon: Icons.delete_outline_rounded,
                        iconColor: Theme.of(context).colorScheme.error,
                        confirmLabel: 'Delete',
                        cancelLabel: 'Cancel',
                        onConfirm: () => AppSnackbar.show(
                          context,
                          message: 'Item deleted',
                          variant: AppSnackbarVariant.error,
                        ),
                      ),
                    ),
                    AppButton(
                      label: 'Success',
                      variant: AppButtonVariant.tonal,
                      prefixIcon: Icons.check_circle_outline,
                      onPressed: () => AppSnackbar.show(
                        context,
                        message: 'Operation completed successfully!',
                        variant: AppSnackbarVariant.success,
                      ),
                    ),
                    AppButton(
                      label: 'Error',
                      variant: AppButtonVariant.tonal,
                      prefixIcon: Icons.error_outline,
                      onPressed: () => AppSnackbar.show(
                        context,
                        message: 'Something went wrong. Please retry.',
                        variant: AppSnackbarVariant.error,
                        actionLabel: 'Retry',
                      ),
                    ),
                    AppButton(
                      label: 'Warning',
                      variant: AppButtonVariant.tonal,
                      prefixIcon: Icons.warning_amber_outlined,
                      onPressed: () => AppSnackbar.show(
                        context,
                        message: 'Your session is about to expire.',
                        variant: AppSnackbarVariant.warning,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // ── Skeleton / Loading ───────────────────────────────────────────
          AppSectionHeader(
            title: 'Skeleton / Loading States',
            leading: Icon(Icons.hourglass_top_rounded, size: 18, color: cs.primary),
          ),
          AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    AppSkeletonLoader(width: 48, height: 48, borderRadius: 24),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AppSkeletonLoader(width: 140, height: 14),
                          const SizedBox(height: 6),
                          AppSkeletonLoader(width: 200, height: 12),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                AppSkeletonLoader(height: 12),
                const SizedBox(height: 6),
                AppSkeletonLoader(height: 12, width: 220),
                const SizedBox(height: 6),
                AppSkeletonLoader(height: 12, width: 170),
                const SizedBox(height: 16),
                AppSkeletonLoader(height: 80, borderRadius: 12),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // ── Empty State ──────────────────────────────────────────────────
          AppSectionHeader(
            title: 'Empty State',
            leading: Icon(Icons.inbox_outlined, size: 18, color: cs.primary),
          ),
          AppCard(
            child: AppEmptyState(
              icon: Icons.inbox_outlined,
              title: 'No Items Found',
              subtitle: 'Start by adding a new item to see it appear here.',
              actionLabel: 'Add First Item',
              onAction: () => AppSnackbar.show(
                context,
                message: 'Add item tapped!',
                variant: AppSnackbarVariant.info,
              ),
            ),
          ),

          const SizedBox(height: 32),
        ],
      ),
    );
  }
}
