import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import '../theme/app_theme.dart';
import '../services/auth_service.dart';
import '../services/innovation_service.dart';
import '../widgets/stat_card.dart';
import '../widgets/chart_card.dart';
import '../widgets/innovation_tile.dart';
import '../widgets/app_drawer.dart';
import 'innovation_detail_screen.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthService>(context);
    final innovationService = Provider.of<InnovationService>(context);
    final categoryCounts = innovationService.categoryCounts;
    final recentEntries = innovationService.getRecent(limit: 5);
    final monthlyTrend = innovationService.monthlyTrend;

    return Scaffold(
      backgroundColor: AppTheme.primaryDark,
      drawer: const AppDrawer(),
      body: CustomScrollView(
        slivers: [
          // App Bar
          SliverAppBar(
            expandedHeight: 120,
            floating: true,
            pinned: true,
            backgroundColor: AppTheme.primaryDark,
            flexibleSpace: FlexibleSpaceBar(
              titlePadding:
                  const EdgeInsets.only(left: 56, bottom: 16, right: 16),
              title: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Hello, ${auth.currentUser?.name.split(' ').first ?? 'User'} 👋',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                  const Text(
                    'Innovation Dashboard',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w400,
                      color: AppTheme.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              Container(
                margin: const EdgeInsets.only(right: 16),
                child: CircleAvatar(
                  radius: 18,
                  backgroundColor: AppTheme.accentIndigo.withValues(alpha: 0.2),
                  child: Text(
                    auth.currentUser?.initials ?? 'U',
                    style: const TextStyle(
                      color: AppTheme.accentIndigo,
                      fontWeight: FontWeight.w700,
                      fontSize: 13,
                    ),
                  ),
                ),
              ),
            ],
          ),
          // Content
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── Stat Cards Grid ──
                  GridView.count(
                    crossAxisCount: 2,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 1.3,
                    children: [
                      StatCard(
                        icon: Icons.science,
                        value: '${categoryCounts['Research'] ?? 0}',
                        label: 'Research Papers',
                        color: AppTheme.accentIndigo,
                        trend: '+12%',
                      ),
                      StatCard(
                        icon: Icons.verified,
                        value: '${categoryCounts['Patent'] ?? 0}',
                        label: 'Patents Filed',
                        color: AppTheme.accentPink,
                        trend: '+8%',
                      ),
                      StatCard(
                        icon: Icons.account_balance_wallet,
                        value: '${categoryCounts['Grant'] ?? 0}',
                        label: 'Grants Received',
                        color: AppTheme.successGreen,
                        trend: '+25%',
                      ),
                      StatCard(
                        icon: Icons.emoji_events,
                        value: '${categoryCounts['Award'] ?? 0}',
                        label: 'Awards Won',
                        color: AppTheme.warningYellow,
                        trend: '+15%',
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  // Startup stat
                  StatCard(
                    icon: Icons.rocket_launch,
                    value: '${categoryCounts['Startup'] ?? 0}',
                    label: 'Startups Incubated',
                    color: AppTheme.accentCyan,
                    trend: '+20%',
                  ),
                  const SizedBox(height: 24),

                  // ── Bar Chart: Innovations by Category ──
                  ChartCard(
                    title: 'Innovations by Category',
                    chart: BarChart(
                      BarChartData(
                        alignment: BarChartAlignment.spaceAround,
                        maxY: (categoryCounts.values.isEmpty
                                ? 10
                                : categoryCounts.values
                                        .reduce((a, b) => a > b ? a : b) +
                                    2)
                            .toDouble(),
                        barTouchData: BarTouchData(
                          touchTooltipData: BarTouchTooltipData(
                            getTooltipColor: (_) => AppTheme.surfaceDark,
                          ),
                        ),
                        titlesData: FlTitlesData(
                          show: true,
                          bottomTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              getTitlesWidget: (value, meta) {
                                const titles = [
                                  'Research',
                                  'Patent',
                                  'Grant',
                                  'Award',
                                  'Startup'
                                ];
                                if (value.toInt() < titles.length) {
                                  return Padding(
                                    padding: const EdgeInsets.only(top: 8),
                                    child: Text(
                                      titles[value.toInt()],
                                      style: const TextStyle(
                                        color: AppTheme.textHint,
                                        fontSize: 10,
                                      ),
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
                              reservedSize: 28,
                              getTitlesWidget: (value, meta) {
                                return Text(
                                  '${value.toInt()}',
                                  style: const TextStyle(
                                    color: AppTheme.textHint,
                                    fontSize: 10,
                                  ),
                                );
                              },
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
                        barGroups: [
                          _barGroup(0, (categoryCounts['Research'] ?? 0).toDouble(),
                              AppTheme.accentIndigo),
                          _barGroup(1, (categoryCounts['Patent'] ?? 0).toDouble(),
                              AppTheme.accentPink),
                          _barGroup(2, (categoryCounts['Grant'] ?? 0).toDouble(),
                              AppTheme.successGreen),
                          _barGroup(3, (categoryCounts['Award'] ?? 0).toDouble(),
                              AppTheme.warningYellow),
                          _barGroup(4, (categoryCounts['Startup'] ?? 0).toDouble(),
                              AppTheme.accentCyan),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // ── Line Chart: Monthly Trend ──
                  ChartCard(
                    title: 'Monthly Innovation Trend',
                    chart: LineChart(
                      LineChartData(
                        gridData: FlGridData(
                          show: true,
                          drawVerticalLine: false,
                          getDrawingHorizontalLine: (value) => FlLine(
                            color: AppTheme.dividerColor,
                            strokeWidth: 0.5,
                          ),
                        ),
                        titlesData: FlTitlesData(
                          bottomTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              interval: 1,
                              getTitlesWidget: (value, meta) {
                                const months = [
                                  '',
                                  'Jan',
                                  'Feb',
                                  'Mar',
                                  'Apr',
                                  'May',
                                  'Jun',
                                  'Jul',
                                  'Aug',
                                  'Sep',
                                  'Oct',
                                  'Nov',
                                  'Dec'
                                ];
                                final idx = value.toInt();
                                if (idx > 0 && idx <= 12) {
                                  return Padding(
                                    padding: const EdgeInsets.only(top: 8),
                                    child: Text(
                                      months[idx],
                                      style: const TextStyle(
                                        color: AppTheme.textHint,
                                        fontSize: 9,
                                      ),
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
                              reservedSize: 28,
                              getTitlesWidget: (value, meta) {
                                return Text(
                                  '${value.toInt()}',
                                  style: const TextStyle(
                                    color: AppTheme.textHint,
                                    fontSize: 10,
                                  ),
                                );
                              },
                            ),
                          ),
                          topTitles: const AxisTitles(
                              sideTitles: SideTitles(showTitles: false)),
                          rightTitles: const AxisTitles(
                              sideTitles: SideTitles(showTitles: false)),
                        ),
                        borderData: FlBorderData(show: false),
                        minX: 1,
                        maxX: 12,
                        minY: 0,
                        lineBarsData: [
                          LineChartBarData(
                            spots: monthlyTrend.entries
                                .map((e) => FlSpot(
                                    e.key.toDouble(), e.value.toDouble()))
                                .toList(),
                            isCurved: true,
                            color: AppTheme.accentIndigo,
                            barWidth: 3,
                            isStrokeCapRound: true,
                            dotData: const FlDotData(show: true),
                            belowBarData: BarAreaData(
                              show: true,
                              color:
                                  AppTheme.accentIndigo.withValues(alpha: 0.1),
                            ),
                          ),
                        ],
                        lineTouchData: LineTouchData(
                          touchTooltipData: LineTouchTooltipData(
                            getTooltipColor: (_) => AppTheme.surfaceDark,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // ── Pie Chart: Department Distribution ──
                  ChartCard(
                    title: 'Department Distribution',
                    height: 200,
                    chart: PieChart(
                      PieChartData(
                        sectionsSpace: 2,
                        centerSpaceRadius: 40,
                        sections: _buildPieSections(innovationService),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  // Pie legend
                  _buildPieLegend(innovationService),
                  const SizedBox(height: 24),

                  // ── Recent Innovations ──
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Recent Innovations',
                          style: Theme.of(context).textTheme.titleLarge),
                      TextButton(
                        onPressed: () {},
                        child: const Text(
                          'View All',
                          style: TextStyle(
                            color: AppTheme.accentIndigo,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  ...recentEntries.map((entry) => InnovationTile(
                        entry: entry,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  InnovationDetailScreen(entry: entry),
                            ),
                          );
                        },
                      )),
                  const SizedBox(height: 80),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  BarChartGroupData _barGroup(int x, double y, Color color) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          toY: y,
          color: color,
          width: 22,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(6)),
          backDrawRodData: BackgroundBarChartRodData(
            show: true,
            toY: 15,
            color: color.withValues(alpha: 0.05),
          ),
        ),
      ],
    );
  }

  List<PieChartSectionData> _buildPieSections(InnovationService service) {
    final deptCounts = service.departmentCounts;
    final total = deptCounts.values.fold(0, (a, b) => a + b);
    final colors = [
      AppTheme.accentIndigo,
      AppTheme.accentPink,
      AppTheme.accentCyan,
      AppTheme.successGreen,
      AppTheme.warningYellow,
      AppTheme.accentOrange,
      AppTheme.accentBlue,
    ];
    int i = 0;
    return deptCounts.entries.map((e) {
      final pct = total > 0 ? (e.value / total * 100) : 0;
      final section = PieChartSectionData(
        value: e.value.toDouble(),
        color: colors[i % colors.length],
        radius: 30,
        title: '${pct.toStringAsFixed(0)}%',
        titleStyle: const TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w700,
          color: Colors.white,
        ),
      );
      i++;
      return section;
    }).toList();
  }

  Widget _buildPieLegend(InnovationService service) {
    final deptCounts = service.departmentCounts;
    final colors = [
      AppTheme.accentIndigo,
      AppTheme.accentPink,
      AppTheme.accentCyan,
      AppTheme.successGreen,
      AppTheme.warningYellow,
      AppTheme.accentOrange,
      AppTheme.accentBlue,
    ];
    int i = 0;
    return Wrap(
      spacing: 16,
      runSpacing: 8,
      children: deptCounts.entries.map((e) {
        final color = colors[i % colors.length];
        i++;
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 10,
              height: 10,
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(3),
              ),
            ),
            const SizedBox(width: 6),
            Text(
              '${e.key} (${e.value})',
              style: const TextStyle(
                fontSize: 11,
                color: AppTheme.textSecondary,
              ),
            ),
          ],
        );
      }).toList(),
    );
  }
}
