import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import '../theme/app_theme.dart';
import '../services/innovation_service.dart';
import '../widgets/chart_card.dart';

class AnalyticsScreen extends StatefulWidget {
  const AnalyticsScreen({super.key});

  @override
  State<AnalyticsScreen> createState() => _AnalyticsScreenState();
}

class _AnalyticsScreenState extends State<AnalyticsScreen> {
  String _selectedPeriod = 'All Time';

  @override
  Widget build(BuildContext context) {
    final service = Provider.of<InnovationService>(context);
    final categoryCounts = service.categoryCounts;
    final deptCounts = service.departmentCounts;
    final monthlyTrend = service.monthlyTrend;

    return Scaffold(
      backgroundColor: AppTheme.primaryDark,
      appBar: AppBar(
        title: const Text('Analytics'),
        backgroundColor: AppTheme.primaryDark,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Period selector
            Row(
              children: ['All Time', 'This Year', 'This Quarter'].map((p) {
                final selected = p == _selectedPeriod;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: GestureDetector(
                    onTap: () => setState(() => _selectedPeriod = p),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 8),
                      decoration: BoxDecoration(
                        color: selected
                            ? AppTheme.accentIndigo
                            : AppTheme.surfaceDark,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        p,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: selected
                              ? Colors.white
                              : AppTheme.textSecondary,
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 20),

            // Summary cards
            _buildSummaryRow(service),
            const SizedBox(height: 20),

            // Category breakdown — horizontal bar chart
            ChartCard(
              title: 'Category Breakdown',
              height: 220,
              chart: BarChart(
                BarChartData(
                  alignment: BarChartAlignment.spaceAround,
                  maxY: (categoryCounts.values.isEmpty
                          ? 10
                          : categoryCounts.values
                                  .reduce((a, b) => a > b ? a : b) +
                              3)
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
                        getTitlesWidget: (value, meta) {
                          const cats = [
                            'Research',
                            'Patent',
                            'Grant',
                            'Award',
                            'Startup'
                          ];
                          if (value.toInt() < cats.length) {
                            return Padding(
                              padding: const EdgeInsets.only(top: 8),
                              child: Text(
                                cats[value.toInt()],
                                style: const TextStyle(
                                    color: AppTheme.textHint, fontSize: 9),
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
                        getTitlesWidget: (value, meta) => Text(
                          '${value.toInt()}',
                          style: const TextStyle(
                              color: AppTheme.textHint, fontSize: 9),
                        ),
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
                    _bar(0, (categoryCounts['Research'] ?? 0).toDouble(),
                        AppTheme.accentIndigo),
                    _bar(1, (categoryCounts['Patent'] ?? 0).toDouble(),
                        AppTheme.accentPink),
                    _bar(2, (categoryCounts['Grant'] ?? 0).toDouble(),
                        AppTheme.successGreen),
                    _bar(3, (categoryCounts['Award'] ?? 0).toDouble(),
                        AppTheme.warningYellow),
                    _bar(4, (categoryCounts['Startup'] ?? 0).toDouble(),
                        AppTheme.accentCyan),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Monthly line chart
            ChartCard(
              title: 'Monthly Submissions',
              height: 220,
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
                          const m = [
                            '',
                            'J',
                            'F',
                            'M',
                            'A',
                            'M',
                            'J',
                            'J',
                            'A',
                            'S',
                            'O',
                            'N',
                            'D'
                          ];
                          final i = value.toInt();
                          return i > 0 && i <= 12
                              ? Text(m[i],
                                  style: const TextStyle(
                                      color: AppTheme.textHint, fontSize: 10))
                              : const Text('');
                        },
                      ),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 24,
                        getTitlesWidget: (value, meta) => Text(
                          '${value.toInt()}',
                          style: const TextStyle(
                              color: AppTheme.textHint, fontSize: 9),
                        ),
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
                          .map((e) =>
                              FlSpot(e.key.toDouble(), e.value.toDouble()))
                          .toList(),
                      isCurved: true,
                      gradient: AppTheme.primaryGradient,
                      barWidth: 3,
                      isStrokeCapRound: true,
                      belowBarData: BarAreaData(
                        show: true,
                        gradient: LinearGradient(
                          colors: [
                            AppTheme.accentIndigo.withValues(alpha: 0.2),
                            AppTheme.accentCyan.withValues(alpha: 0.02),
                          ],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                      ),
                      dotData: const FlDotData(show: true),
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

            // Department pie
            ChartCard(
              title: 'Department Distribution',
              height: 200,
              chart: PieChart(
                PieChartData(
                  sectionsSpace: 3,
                  centerSpaceRadius: 40,
                  sections: _pieFromDept(deptCounts),
                ),
              ),
            ),
            const SizedBox(height: 8),
            _pieLegend(deptCounts),
            const SizedBox(height: 16),

            // Status breakdown
            _buildStatusBreakdown(service),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryRow(InnovationService service) {
    return Row(
      children: [
        _summaryCard('Total', '${service.totalCount}', AppTheme.accentIndigo),
        const SizedBox(width: 10),
        _summaryCard('Approved',
            '${service.entries.where((e) => e.status == 'Approved' || e.status == 'Published').length}',
            AppTheme.successGreen),
        const SizedBox(width: 10),
        _summaryCard('Pending',
            '${service.entries.where((e) => e.status == 'In Review' || e.status == 'Submitted').length}',
            AppTheme.warningYellow),
      ],
    );
  }

  Widget _summaryCard(String label, String value, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: color.withValues(alpha: 0.2)),
        ),
        child: Column(
          children: [
            Text(value,
                style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w800,
                    color: color)),
            const SizedBox(height: 4),
            Text(label,
                style:
                    const TextStyle(fontSize: 11, color: AppTheme.textHint)),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusBreakdown(InnovationService service) {
    final statuses = <String, int>{};
    for (final e in service.entries) {
      statuses[e.status] = (statuses[e.status] ?? 0) + 1;
    }
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: AppTheme.cardDecoration,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Status Breakdown',
              style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 16),
          ...statuses.entries.map((e) {
            final pct = service.totalCount > 0
                ? e.value / service.totalCount
                : 0.0;
            Color color;
            switch (e.key) {
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
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(e.key,
                          style: const TextStyle(
                              color: AppTheme.textSecondary, fontSize: 13)),
                      Text('${e.value} (${(pct * 100).toStringAsFixed(0)}%)',
                          style: TextStyle(
                              color: color,
                              fontSize: 13,
                              fontWeight: FontWeight.w600)),
                    ],
                  ),
                  const SizedBox(height: 6),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: pct,
                      backgroundColor: color.withValues(alpha: 0.1),
                      valueColor: AlwaysStoppedAnimation(color),
                      minHeight: 6,
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  BarChartGroupData _bar(int x, double y, Color color) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          toY: y,
          color: color,
          width: 20,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(6)),
        ),
      ],
    );
  }

  List<PieChartSectionData> _pieFromDept(Map<String, int> deptCounts) {
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
        radius: 28,
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

  Widget _pieLegend(Map<String, int> deptCounts) {
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
      spacing: 14,
      runSpacing: 6,
      children: deptCounts.entries.map((e) {
        final c = colors[i % colors.length];
        i++;
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
                width: 10,
                height: 10,
                decoration: BoxDecoration(
                    color: c, borderRadius: BorderRadius.circular(3))),
            const SizedBox(width: 4),
            Text('${e.key} (${e.value})',
                style: const TextStyle(
                    fontSize: 11, color: AppTheme.textSecondary)),
          ],
        );
      }).toList(),
    );
  }
}
