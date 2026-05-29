import 'package:flutter/material.dart';
import '../../../../core/widgets/app_widgets.dart';

class HomeTab extends StatelessWidget {
  const HomeTab({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: cs.surfaceContainerLowest,
      appBar: AppBar(
        title: const Text('Dashboard'),
        centerTitle: true,
        actions: [
          AppAvatar(initials: 'JD', size: 32, onTap: () {}),
          const SizedBox(width: 16),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Welcome banner
          AppCard(
            variant: AppCardVariant.filled,
            color: cs.primaryContainer,
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Welcome back, John! 👋',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: cs.onPrimaryContainer,
                            ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'You have 4 pending tasks today.',
                        style: TextStyle(color: cs.onPrimaryContainer.withValues(alpha: 0.75)),
                      ),
                      const SizedBox(height: 12),
                      AppButton(
                        label: 'View Tasks',
                        size: AppButtonSize.small,
                        prefixIcon: Icons.task_alt_rounded,
                        onPressed: () {},
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                AppAvatar(initials: 'JD', size: 64),
              ],
            ),
          ),
          const SizedBox(height: 24),

          AppSectionHeader(
            title: 'Quick Stats',
            leading: Icon(Icons.bar_chart_rounded, size: 18, color: cs.primary),
          ),
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 1.6,
            children: [
              AppStatsCard(
                label: 'Total Users',
                value: '12.4K',
                icon: Icons.people_rounded,
                accentColor: cs.primary,
                trend: '+8%',
              ),
              AppStatsCard(
                label: 'Revenue',
                value: '\$94K',
                icon: Icons.attach_money_rounded,
                accentColor: Colors.teal,
                trend: '+22%',
              ),
              AppStatsCard(
                label: 'Orders',
                value: '2,108',
                icon: Icons.shopping_bag_rounded,
                accentColor: Colors.orange,
                trend: '+5%',
              ),
              AppStatsCard(
                label: 'Rating',
                value: '4.8',
                icon: Icons.star_rounded,
                accentColor: Colors.amber,
                trend: '+0.2',
              ),
            ],
          ),
          const SizedBox(height: 24),

          AppSectionHeader(
            title: 'Recent Activity',
            leading: Icon(Icons.history_rounded, size: 18, color: cs.primary),
            actionLabel: 'See All',
            onAction: () {},
          ),
          AppCard(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Column(
              children: const [
                AppListTile(
                  title: 'New user registered',
                  subtitle: '2 minutes ago',
                  leading: Icon(Icons.person_add_alt_1_rounded, color: Colors.green),
                  showDivider: true,
                ),
                AppListTile(
                  title: 'Order #4821 completed',
                  subtitle: '15 minutes ago',
                  leading: Icon(Icons.check_circle_outline_rounded, color: Colors.blue),
                  showDivider: true,
                ),
                AppListTile(
                  title: 'Server backup completed',
                  subtitle: '1 hour ago',
                  leading: Icon(Icons.cloud_done_outlined, color: Colors.teal),
                  showDivider: true,
                ),
                AppListTile(
                  title: 'New support ticket opened',
                  subtitle: '3 hours ago',
                  leading: Icon(Icons.support_agent_rounded, color: Colors.orange),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
