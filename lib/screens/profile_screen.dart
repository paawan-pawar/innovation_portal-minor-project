import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:percent_indicator/percent_indicator.dart';
import '../theme/app_theme.dart';
import '../services/auth_service.dart';
import '../services/innovation_service.dart';
import '../widgets/innovation_tile.dart';
import 'innovation_detail_screen.dart';
import 'login_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthService>(context);
    final service = Provider.of<InnovationService>(context);
    final user = auth.currentUser;

    // Get user's contributions (by matching contributor name)
    final userContributions = user != null
        ? service.entries
            .where((e) => e.contributors.contains(user.name))
            .toList()
        : <dynamic>[];

    return Scaffold(
      backgroundColor: AppTheme.primaryDark,
      appBar: AppBar(
        title: const Text('Profile'),
        backgroundColor: AppTheme.primaryDark,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, size: 20),
            onPressed: () {
              auth.logout();
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (_) => const LoginScreen()),
                (route) => false,
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // ── Profile Card ──
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF1A1A2E), Color(0xFF16213E)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(
                  color: AppTheme.accentIndigo.withValues(alpha: 0.2),
                ),
              ),
              child: Column(
                children: [
                  // Avatar
                  CircleAvatar(
                    radius: 45,
                    backgroundColor:
                        AppTheme.accentIndigo.withValues(alpha: 0.2),
                    child: Text(
                      user?.initials ?? 'U',
                      style: const TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.w700,
                        color: AppTheme.accentIndigo,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    user?.name ?? 'User',
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    user?.email ?? '',
                    style: const TextStyle(
                      fontSize: 13,
                      color: AppTheme.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _badge(user?.roleDisplayName ?? '', AppTheme.accentIndigo),
                      const SizedBox(width: 8),
                      _badge(user?.department ?? '', AppTheme.accentCyan),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // ── Stats Row ──
            Row(
              children: [
                _statItem('Contributions', '${userContributions.length}',
                    AppTheme.accentIndigo),
                const SizedBox(width: 12),
                _statItem(
                    'Categories',
                    '${userContributions.map((e) => e.category).toSet().length}',
                    AppTheme.accentCyan),
                const SizedBox(width: 12),
                _statItem(
                    'Approved',
                    '${userContributions.where((e) => e.status == 'Approved' || e.status == 'Published').length}',
                    AppTheme.successGreen),
              ],
            ),
            const SizedBox(height: 24),

            // ── Profile Completion ──
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: AppTheme.cardDecoration,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Profile Completion',
                      style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 16),
                  LinearPercentIndicator(
                    lineHeight: 10,
                    percent: 0.85,
                    backgroundColor: AppTheme.dividerColor,
                    linearGradient: AppTheme.primaryGradient,
                    barRadius: const Radius.circular(5),
                    padding: EdgeInsets.zero,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        '85% Complete',
                        style: TextStyle(
                          color: AppTheme.accentCyan,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        'Add more details to reach 100%',
                        style: TextStyle(
                          color: AppTheme.textHint.withValues(alpha: 0.6),
                          fontSize: 10,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // ── Quick Info ──
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: AppTheme.cardDecoration,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Account Details',
                      style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 16),
                  _infoRow(Icons.person, 'Name', user?.name ?? ''),
                  _infoRow(Icons.email, 'Email', user?.email ?? ''),
                  _infoRow(
                      Icons.badge, 'Role', user?.roleDisplayName ?? ''),
                  _infoRow(
                      Icons.business, 'Department', user?.department ?? ''),
                  _infoRow(Icons.verified_user, 'Status', 'Active'),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // ── My Contributions ──
            if (userContributions.isNotEmpty) ...[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('My Contributions',
                      style: Theme.of(context).textTheme.titleLarge),
                  Text(
                    '${userContributions.length} total',
                    style: const TextStyle(
                        color: AppTheme.textHint, fontSize: 12),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              ...userContributions.map((entry) => InnovationTile(
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
            ],
            const SizedBox(height: 80),
          ],
        ),
      ),
    );
  }

  Widget _badge(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: color,
          fontSize: 11,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _statItem(String label, String value, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: color.withValues(alpha: 0.15)),
        ),
        child: Column(
          children: [
            Text(
              value,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w800,
                color: color,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style:
                  const TextStyle(fontSize: 10, color: AppTheme.textHint),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _infoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Row(
        children: [
          Icon(icon, size: 18, color: AppTheme.textHint),
          const SizedBox(width: 12),
          SizedBox(
            width: 80,
            child: Text(
              label,
              style: const TextStyle(
                  color: AppTheme.textHint, fontSize: 12),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                color: AppTheme.textPrimary,
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
