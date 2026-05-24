class InnovationEntry {
  final String id;
  final String title;
  final String category; // Research, Patent, Grant, Award, Startup
  final String description;
  final DateTime date;
  final List<String> contributors;
  final String department;
  final String status; // Submitted, In Review, Approved, Published
  final Map<String, dynamic> metrics;
  final String submittedBy;

  const InnovationEntry({
    required this.id,
    required this.title,
    required this.category,
    required this.description,
    required this.date,
    required this.contributors,
    required this.department,
    required this.status,
    this.metrics = const {},
    this.submittedBy = '',
  });

  InnovationEntry copyWith({
    String? id,
    String? title,
    String? category,
    String? description,
    DateTime? date,
    List<String>? contributors,
    String? department,
    String? status,
    Map<String, dynamic>? metrics,
    String? submittedBy,
  }) {
    return InnovationEntry(
      id: id ?? this.id,
      title: title ?? this.title,
      category: category ?? this.category,
      description: description ?? this.description,
      date: date ?? this.date,
      contributors: contributors ?? this.contributors,
      department: department ?? this.department,
      status: status ?? this.status,
      metrics: metrics ?? this.metrics,
      submittedBy: submittedBy ?? this.submittedBy,
    );
  }
}
