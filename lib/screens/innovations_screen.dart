import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../theme/app_theme.dart';
import '../services/innovation_service.dart';
import '../models/innovation_entry.dart';
import '../widgets/innovation_tile.dart';
import 'innovation_detail_screen.dart';

class InnovationsScreen extends StatefulWidget {
  const InnovationsScreen({super.key});

  @override
  State<InnovationsScreen> createState() => _InnovationsScreenState();
}

class _InnovationsScreenState extends State<InnovationsScreen> {
  String _searchQuery = '';
  String _selectedCategory = 'All';
  final _searchController = TextEditingController();

  final List<String> _categories = [
    'All',
    'Research',
    'Patent',
    'Grant',
    'Award',
    'Startup',
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final service = Provider.of<InnovationService>(context);
    List<InnovationEntry> filtered = _searchQuery.isEmpty
        ? service.entries
        : service.search(_searchQuery);

    if (_selectedCategory != 'All') {
      filtered =
          filtered.where((e) => e.category == _selectedCategory).toList();
    }

    filtered.sort((a, b) => b.date.compareTo(a.date));

    return Scaffold(
      backgroundColor: AppTheme.primaryDark,
      appBar: AppBar(
        title: const Text('Innovations'),
        backgroundColor: AppTheme.primaryDark,
      ),
      body: Column(
        children: [
          // Search bar
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
            child: TextField(
              controller: _searchController,
              style: const TextStyle(color: Colors.white),
              onChanged: (val) => setState(() => _searchQuery = val),
              decoration: InputDecoration(
                hintText: 'Search innovations...',
                prefixIcon:
                    const Icon(Icons.search, color: AppTheme.textHint),
                suffixIcon: _searchQuery.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.close,
                            color: AppTheme.textHint, size: 18),
                        onPressed: () {
                          _searchController.clear();
                          setState(() => _searchQuery = '');
                        },
                      )
                    : null,
              ),
            ),
          ),
          // Category chips
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.all(16),
            child: Row(
              children: _categories.map((cat) {
                final isSelected = cat == _selectedCategory;
                final color = cat == 'All'
                    ? AppTheme.accentIndigo
                    : AppTheme.getCategoryColor(cat);
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: GestureDetector(
                    onTap: () => setState(() => _selectedCategory = cat),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? color
                            : color.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: isSelected
                              ? color
                              : color.withValues(alpha: 0.3),
                          width: 1,
                        ),
                      ),
                      child: Text(
                        cat,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: isSelected ? Colors.white : color,
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          // Results count
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Text(
                  '${filtered.length} results',
                  style: const TextStyle(
                    color: AppTheme.textHint,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          // List
          Expanded(
            child: filtered.isEmpty
                ? Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.search_off,
                            size: 64,
                            color: AppTheme.textHint.withValues(alpha: 0.3)),
                        const SizedBox(height: 16),
                        const Text(
                          'No innovations found',
                          style: TextStyle(
                            color: AppTheme.textHint,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: filtered.length,
                    itemBuilder: (context, index) {
                      return InnovationTile(
                        entry: filtered[index],
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => InnovationDetailScreen(
                                  entry: filtered[index]),
                            ),
                          );
                        },
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
