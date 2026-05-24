import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../theme/app_theme.dart';
import '../services/innovation_service.dart';
import '../models/innovation_entry.dart';
import '../widgets/gradient_button.dart';

class AddInnovationScreen extends StatefulWidget {
  const AddInnovationScreen({super.key});

  @override
  State<AddInnovationScreen> createState() => _AddInnovationScreenState();
}

class _AddInnovationScreenState extends State<AddInnovationScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _contributorsController = TextEditingController();
  String _selectedCategory = 'Research';
  String _selectedDepartment = 'Computer Science';
  bool _isSubmitting = false;

  final _categories = ['Research', 'Patent', 'Grant', 'Award', 'Startup'];
  final _departments = [
    'Computer Science',
    'Electronics',
    'Electrical Engineering',
    'Mechanical',
    'Civil Engineering',
    'Biotechnology',
    'Administration',
  ];

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _contributorsController.dispose();
    super.dispose();
  }

  void _submit() async {
    if (!_formKey.currentState!.validate()) return;

    final service = Provider.of<InnovationService>(context, listen: false);
    final messenger = ScaffoldMessenger.of(context);
    final navigator = Navigator.of(context);

    setState(() => _isSubmitting = true);
    await Future.delayed(const Duration(milliseconds: 800));

    final entry = InnovationEntry(
      id: 'new_${DateTime.now().millisecondsSinceEpoch}',
      title: _titleController.text.trim(),
      category: _selectedCategory,
      description: _descriptionController.text.trim(),
      date: DateTime.now(),
      contributors: _contributorsController.text
          .split(',')
          .map((c) => c.trim())
          .where((c) => c.isNotEmpty)
          .toList(),
      department: _selectedDepartment,
      status: 'Submitted',
    );
    service.addEntry(entry);

    if (mounted) {
      setState(() => _isSubmitting = false);
      messenger.showSnackBar(
        SnackBar(
          content: const Text('Innovation submitted successfully!'),
          backgroundColor: AppTheme.successGreen,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
      navigator.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.primaryDark,
      appBar: AppBar(
        title: const Text('Add Innovation'),
        backgroundColor: AppTheme.primaryDark,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppTheme.accentIndigo.withValues(alpha: 0.15),
                      AppTheme.accentCyan.withValues(alpha: 0.05),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.add_circle, color: AppTheme.accentIndigo),
                    SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Submit New Innovation',
                            style: TextStyle(
                              color: AppTheme.textPrimary,
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                            ),
                          ),
                          Text(
                            'Fill in the details to add a new innovation entry',
                            style: TextStyle(
                              color: AppTheme.textHint,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Title
              _label('Title *'),
              const SizedBox(height: 8),
              TextFormField(
                controller: _titleController,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  hintText: 'Enter innovation title',
                ),
                validator: (v) =>
                    v == null || v.trim().isEmpty ? 'Title is required' : null,
              ),
              const SizedBox(height: 20),

              // Category
              _label('Category *'),
              const SizedBox(height: 8),
              _buildDropdown(
                value: _selectedCategory,
                items: _categories,
                onChanged: (v) =>
                    setState(() => _selectedCategory = v ?? 'Research'),
              ),
              const SizedBox(height: 20),

              // Department
              _label('Department *'),
              const SizedBox(height: 8),
              _buildDropdown(
                value: _selectedDepartment,
                items: _departments,
                onChanged: (v) => setState(
                    () => _selectedDepartment = v ?? 'Computer Science'),
              ),
              const SizedBox(height: 20),

              // Description
              _label('Description *'),
              const SizedBox(height: 8),
              TextFormField(
                controller: _descriptionController,
                style: const TextStyle(color: Colors.white),
                maxLines: 4,
                decoration: const InputDecoration(
                  hintText: 'Describe the innovation in detail...',
                  alignLabelWithHint: true,
                ),
                validator: (v) => v == null || v.trim().isEmpty
                    ? 'Description is required'
                    : null,
              ),
              const SizedBox(height: 20),

              // Contributors
              _label('Contributors'),
              const SizedBox(height: 4),
              const Text(
                'Separate names with commas',
                style: TextStyle(color: AppTheme.textHint, fontSize: 11),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _contributorsController,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  hintText: 'e.g. Dr. Sharma, Ananya Gupta',
                ),
              ),
              const SizedBox(height: 32),

              // Submit button
              GradientButton(
                text: 'Submit Innovation',
                isLoading: _isSubmitting,
                onPressed: _submit,
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _label(String text) {
    return Text(
      text,
      style: const TextStyle(
        color: AppTheme.textSecondary,
        fontSize: 13,
        fontWeight: FontWeight.w500,
      ),
    );
  }

  Widget _buildDropdown({
    required String value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          isExpanded: true,
          dropdownColor: AppTheme.surfaceDark,
          style: const TextStyle(color: Colors.white, fontSize: 14),
          icon: const Icon(Icons.keyboard_arrow_down,
              color: AppTheme.textHint),
          items: items.map((item) {
            return DropdownMenuItem(value: item, child: Text(item));
          }).toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }
}
