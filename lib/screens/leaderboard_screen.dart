import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import '../theme/app_theme.dart';
import '../services/innovation_service.dart';

class LeaderboardScreen extends StatelessWidget {
  const LeaderboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final service = Provider.of<InnovationService>(context);
    final deptStats = service.departmentStats;
    final topContributors = service.topContributors;

    return Scaffold(
      backgroundColor: AppTheme.primaryDark,
      appBar: AppBar(
        title: const Text('Leaderboard'),
        backgroundColor: AppTheme.primaryDark,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Department Rankings ──
            Text('Department Rankings',
                style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 4),
            Text('Ranked by total innovation contributions',
                style: Theme.of(context).textTheme.bodySmall),
            const SizedBox(height: 16),

            // Top 3 podium
            if (deptStats.length >= 3) _buildPodium(deptStats),
            const SizedBox(height: 16),

            // Full ranking list
            ...List.generate(deptStats.length, (i) {
              final dept = deptStats[i];
              final isTop3 = i < 3;
              return Container(
                margin: const EdgeInsets.only(bottom: 8),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: isTop3
                      ? _rankColor(i).withValues(alpha: 0.08)
                      : AppTheme.surfaceDark,
                  borderRadius: BorderRadius.circular(14),
                  border: isTop3
                      ? Border.all(
                          color: _rankColor(i).withValues(alpha: 0.3))
                      : null,
                ),
                child: Row(
                  children: [
                    SizedBox(
                      width: 32,
                      child: isTop3
                          ? Icon(_rankIcon(i),
                              color: _rankColor(i), size: 24)
                          : Text(
                              '${i + 1}',
                              style: const TextStyle(
                                color: AppTheme.textHint,
                                fontWeight: FontWeight.w700,
                                fontSize: 16,
                              ),
                              textAlign: TextAlign.center,
                            ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            dept.department,
                            style: const TextStyle(
                              color: AppTheme.textPrimary,
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              _miniStat(
                                  'R', dept.researchCount, AppTheme.accentIndigo),
                              _miniStat(
                                  'P', dept.patentCount, AppTheme.accentPink),
                              _miniStat(
                                  'G', dept.grantCount, AppTheme.successGreen),
                              _miniStat(
                                  'A', dept.awardCount, AppTheme.warningYellow),
                              _miniStat(
                                  'S', dept.startupCount, AppTheme.accentCyan),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Text(
                      '${dept.totalInnovations}',
                      style: TextStyle(
                        color: isTop3 ? _rankColor(i) : AppTheme.textPrimary,
                        fontWeight: FontWeight.w800,
                        fontSize: 20,
                      ),
                    ),
                  ],
                ),
              );
            }),
            const SizedBox(height: 24),

            // ── Department bar chart ──
            Container(
              padding: const EdgeInsets.all(20),
              decoration: AppTheme.cardDecoration,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Department Comparison',
                      style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 20),
                  SizedBox(
                    height: 200,
                    child: BarChart(
                      BarChartData(
                        alignment: BarChartAlignment.spaceAround,
                        maxY: (deptStats.isEmpty
                                ? 10
                                : deptStats.first.totalInnovations + 3)
                            .toDouble(),
                        barTouchData: BarTouchData(
                          touchTooltipData: BarTouchTooltipData(
                            getTooltipColor: (_) => AppTheme.surfaceDark,
                          ),
                        ),
                        titlesData: FlTitlesData(
                          bottomTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              getTitlesWidget: (value, _) {
                                final idx = value.toInt();
                                if (idx < deptStats.length) {
                                  return Padding(
                                    padding: const EdgeInsets.only(top: 8),
                                    child: Text(
                                      deptStats[idx]
                                          .department
                                          .split(' ')
                                          .first,
                                      style: const TextStyle(
                                          color: AppTheme.textHint,
                                          fontSize: 8),
                                    ),
                                  );
                                }
                                return const Text('');
                              },
                            ),
                          ),
                          leftTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              reservedSize: 24,
                              getTitlesWidget: (v, _) => Text(
                                  '${v.toInt()}',
                                  style: const TextStyle(
                                      color: AppTheme.textHint, fontSize: 9)),
                            ),
                          ),
                          topTitles: const AxisTitles(
                              sideTitles: SideTitles(showTitles: false)),
                          rightTitles: const AxisTitles(
                              sideTitles: SideTitles(showTitles: false)),
                        ),
                        gridData: FlGridData(
                          show: true,
                          drawVerticalLine: false,
                          getDrawingHorizontalLine: (value) => FlLine(
                            color: AppTheme.dividerColor,
                            strokeWidth: 0.5,
                          ),
                        ),
                        borderData: FlBorderData(show: false),
                        barGroups: List.generate(deptStats.length, (i) {
                          return BarChartGroupData(
                            x: i,
                            barRods: [
                              BarChartRodData(
                                toY: deptStats[i].totalInnovations.toDouble(),
                                gradient: AppTheme.primaryGradient,
                                width: 18,
                                borderRadius: const BorderRadius.vertical(
                                    top: Radius.circular(6)),
                              ),
                            ],
                          );
                        }),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // ── Top Contributors ──
            Text('Top Contributors',
                style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 4),
            Text('Most active innovation contributors',
                style: Theme.of(context).textTheme.bodySmall),
            const SizedBox(height: 16),
            ...List.generate(topContributors.length, (i) {
              final entry = topContributors[i];
              return Container(
                margin: const EdgeInsets.only(bottom: 8),
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: AppTheme.surfaceDark,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Text(
                      '${i + 1}',
                      style: TextStyle(
                        color: i < 3
                            ? _rankColor(i)
                            : AppTheme.textHint,
                        fontWeight: FontWeight.w700,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(width: 14),
                    CircleAvatar(
                      radius: 16,
                      backgroundColor:
                          AppTheme.accentIndigo.withValues(alpha: 0.2),
                      child: Text(
                        entry.key[0].toUpperCase(),
                        style: const TextStyle(
                          color: AppTheme.accentIndigo,
                          fontWeight: FontWeight.w700,
                          fontSize: 12,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        entry.key,
                        style: const TextStyle(
                          color: AppTheme.textPrimary,
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppTheme.accentCyan.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        '${entry.value} contributions',
                        style: const TextStyle(
                          color: AppTheme.accentCyan,
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }),
            const SizedBox(height: 80),
          ],
        ),
      ),
    );
  }

  Widget _buildPodium(List deptStats) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        // 2nd place
        Expanded(
          child: _podiumBlock(deptStats[1], 1, 100),
        ),
        const SizedBox(width: 8),
        // 1st place
        Expanded(
          child: _podiumBlock(deptStats[0], 0, 130),
        ),
        const SizedBox(width: 8),
        // 3rd place
        Expanded(
          child: _podiumBlock(deptStats[2], 2, 80),
        ),
      ],
    );
  }

  Widget _podiumBlock(dynamic dept, int rank, double height) {
    return Container(
      height: height,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            _rankColor(rank).withValues(alpha: 0.2),
            _rankColor(rank).withValues(alpha: 0.05),
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
        border: Border.all(
            color: _rankColor(rank).withValues(alpha: 0.3)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(_rankIcon(rank), color: _rankColor(rank), size: 28),
          const SizedBox(height: 6),
          Text(
            dept.department.split(' ').first,
            style: const TextStyle(
              color: AppTheme.textPrimary,
              fontWeight: FontWeight.w600,
              fontSize: 11,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 2),
          Text(
            '${dept.totalInnovations}',
            style: TextStyle(
              color: _rankColor(rank),
              fontWeight: FontWeight.w800,
              fontSize: 18,
            ),
          ),
        ],
      ),
    );
  }

  Widget _miniStat(String letter, int count, Color color) {
    return Padding(
      padding: const EdgeInsets.only(right: 6),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 14,
            height: 14,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(3),
            ),
            child: Center(
              child: Text(
                letter,
                style: TextStyle(
                    fontSize: 8, fontWeight: FontWeight.w700, color: color),
              ),
            ),
          ),
          const SizedBox(width: 2),
          Text(
            '$count',
            style: const TextStyle(fontSize: 10, color: AppTheme.textHint),
          ),
        ],
      ),
    );
  }

  Color _rankColor(int index) {
    switch (index) {
      case 0:
        return const Color(0xFFFFD700); // Gold
      case 1:
        return const Color(0xFFC0C0C0); // Silver
      case 2:
        return const Color(0xFFCD7F32); // Bronze
      default:
        return AppTheme.textHint;
    }
  }

  IconData _rankIcon(int index) {
    switch (index) {
      case 0:
        return Icons.emoji_events;
      case 1:
        return Icons.military_tech;
      case 2:
        return Icons.workspace_premium;
      default:
        return Icons.circle;
    }
  }
}
