import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../models/innovation_entry.dart';
import 'package:intl/intl.dart';

class InnovationTile extends StatelessWidget {
  final InnovationEntry entry;
  final VoidCallback? onTap;

  const InnovationTile({
    super.key,
    required this.entry,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final categoryColor = AppTheme.getCategoryColor(entry.category);
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppTheme.surfaceDark,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: categoryColor.withValues(alpha: 0.15),
            width: 1,
          ),
        ),
        child: Row(
          children: [
            // Category indicator
            Container(
              width: 4,
              height: 50,
              decoration: BoxDecoration(
                color: categoryColor,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(width: 14),
            // Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: categoryColor.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          entry.category,
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                            color: categoryColor,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      _buildStatusBadge(entry.status),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    entry.title,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.textPrimary,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Icon(Icons.business,
                          size: 12, color: AppTheme.textHint),
                      const SizedBox(width: 4),
                      Text(
                        entry.department,
                        style: const TextStyle(
                          fontSize: 11,
                          color: AppTheme.textHint,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Icon(Icons.calendar_today,
                          size: 12, color: AppTheme.textHint),
                      const SizedBox(width: 4),
                      Text(
                        DateFormat('MMM dd, yyyy').format(entry.date),
                        style: const TextStyle(
                          fontSize: 11,
                          color: AppTheme.textHint,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Icon(Icons.chevron_right,
                color: AppTheme.textHint, size: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusBadge(String status) {
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
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        status,
        style: TextStyle(
          fontSize: 9,
          fontWeight: FontWeight.w600,
          color: color,
        ),
      ),
    );
  }
}
