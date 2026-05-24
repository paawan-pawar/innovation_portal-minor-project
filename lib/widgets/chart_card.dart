import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class ChartCard extends StatelessWidget {
  final String title;
  final Widget chart;
  final Widget? trailing;
  final double height;

  const ChartCard({
    super.key,
    required this.title,
    required this.chart,
    this.trailing,
    this.height = 250,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: AppTheme.cardDecoration,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              ?trailing,
            ],
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: height,
            child: chart,
          ),
        ],
      ),
    );
  }
}
