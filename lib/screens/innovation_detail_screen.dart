import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../theme/app_theme.dart';
import '../models/innovation_entry.dart';

class InnovationDetailScreen extends StatelessWidget {
  final InnovationEntry entry;

  const InnovationDetailScreen({super.key, required this.entry});

  @override
  Widget build(BuildContext context) {
    final categoryColor = AppTheme.getCategoryColor(entry.category);

    return Scaffold(
      backgroundColor: AppTheme.primaryDark,
      body: CustomScrollView(
        slivers: [
          // Hero area
          SliverAppBar(
            expandedHeight: 200,
            pinned: true,
            backgroundColor: AppTheme.primaryDark,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      categoryColor.withValues(alpha: 0.3),
                      AppTheme.primaryDark,
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
                child: Center(
                  child: Icon(
                    _categoryIcon(entry.category),
                    size: 64,
                    color: categoryColor.withValues(alpha: 0.5),
                  ),
                ),
              ),
            ),
          ),
          // Content
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Category + Status
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: categoryColor.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(_categoryIcon(entry.category),
                                size: 14, color: categoryColor),
                            const SizedBox(width: 6),
                            Text(
                              entry.category,
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                                color: categoryColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      _statusBadge(entry.status),
                    ],
                  ),
                  const SizedBox(height: 16),
                  // Title
                  Text(
                    entry.title,
                    style: Theme.of(context).textTheme.headlineLarge,
                  ),
                  const SizedBox(height: 12),
                  // Metadata row
                  Row(
                    children: [
                      const Icon(Icons.business,
                          size: 16, color: AppTheme.textHint),
                      const SizedBox(width: 6),
                      Text(
                        entry.department,
                        style: const TextStyle(
                            color: AppTheme.textSecondary, fontSize: 13),
                      ),
                      const SizedBox(width: 20),
                      const Icon(Icons.calendar_today,
                          size: 16, color: AppTheme.textHint),
                      const SizedBox(width: 6),
                      Text(
                        DateFormat('MMMM dd, yyyy').format(entry.date),
                        style: const TextStyle(
                            color: AppTheme.textSecondary, fontSize: 13),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  const Divider(color: AppTheme.dividerColor),
                  const SizedBox(height: 24),
                  // Description
                  Text(
                    'Description',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    entry.description,
                    style: const TextStyle(
                      color: AppTheme.textSecondary,
                      fontSize: 15,
                      height: 1.6,
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Contributors
                  Text(
                    'Contributors',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: entry.contributors.map((c) {
                      return Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 8),
                        decoration: BoxDecoration(
                          color: AppTheme.surfaceDark,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: Colors.white.withValues(alpha: 0.05),
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            CircleAvatar(
                              radius: 12,
                              backgroundColor:
                                  AppTheme.accentIndigo.withValues(alpha: 0.2),
                              child: Text(
                                c[0].toUpperCase(),
                                style: const TextStyle(
                                  fontSize: 10,
                                  color: AppTheme.accentIndigo,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              c,
                              style: const TextStyle(
                                color: AppTheme.textPrimary,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 24),

                  // Metrics
                  if (entry.metrics.isNotEmpty) ...[
                    Text(
                      'Metrics',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: AppTheme.cardDecoration,
                      child: Column(
                        children: entry.metrics.entries.map((m) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 6),
                            child: Row(
                              mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  _formatMetricKey(m.key),
                                  style: const TextStyle(
                                    color: AppTheme.textSecondary,
                                    fontSize: 13,
                                  ),
                                ),
                                Text(
                                  '${m.value}',
                                  style: const TextStyle(
                                    color: AppTheme.accentCyan,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ],
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatMetricKey(String key) {
    return key
        .replaceAll('_', ' ')
        .split(' ')
        .map((w) => w[0].toUpperCase() + w.substring(1))
        .join(' ');
  }

  Widget _statusBadge(String status) {
    Color color;
    switch (status) {
      case 'Published':
      case 'Approved':
        color = AppTheme.successGreen;
        break;
      case 'In Review':
        color = AppTheme.warningYellow;
        break;
      case 'Submitted':
        color = AppTheme.accentBlue;
        break;
      default:
        color = AppTheme.textHint;
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        status,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: color,
        ),
      ),
    );
  }

  IconData _categoryIcon(String category) {
    switch (category) {
      case 'Research':
        return Icons.science;
      case 'Patent':
        return Icons.verified;
      case 'Grant':
        return Icons.account_balance_wallet;
      case 'Award':
        return Icons.emoji_events;
      case 'Startup':
        return Icons.rocket_launch;
      default:
        return Icons.lightbulb;
    }
  }
}
