import 'package:flutter/material.dart';
import '../models/innovation_entry.dart';
import '../models/department_stats.dart';

class InnovationService extends ChangeNotifier {
  final List<InnovationEntry> _entries = [];

  InnovationService() {
    _seedData();
  }

  List<InnovationEntry> get entries => List.unmodifiable(_entries);

  // ── Queries ──

  List<InnovationEntry> getByCategory(String category) {
    return _entries.where((e) => e.category == category).toList();
  }

  List<InnovationEntry> getByDepartment(String department) {
    return _entries.where((e) => e.department == department).toList();
  }

  List<InnovationEntry> getRecent({int limit = 5}) {
    final sorted = List<InnovationEntry>.from(_entries)
      ..sort((a, b) => b.date.compareTo(a.date));
    return sorted.take(limit).toList();
  }

  List<InnovationEntry> search(String query) {
    final q = query.toLowerCase();
    return _entries.where((e) {
      return e.title.toLowerCase().contains(q) ||
          e.description.toLowerCase().contains(q) ||
          e.department.toLowerCase().contains(q) ||
          e.contributors.any((c) => c.toLowerCase().contains(q));
    }).toList();
  }

  // ── Stats ──

  int get totalCount => _entries.length;

  Map<String, int> get categoryCounts {
    final map = <String, int>{};
    for (final e in _entries) {
      map[e.category] = (map[e.category] ?? 0) + 1;
    }
    return map;
  }

  Map<String, int> get departmentCounts {
    final map = <String, int>{};
    for (final e in _entries) {
      map[e.department] = (map[e.department] ?? 0) + 1;
    }
    return map;
  }

  List<DepartmentStats> get departmentStats {
    final depts = <String, Map<String, int>>{};
    for (final e in _entries) {
      depts.putIfAbsent(e.department, () => {});
      depts[e.department]![e.category] =
          (depts[e.department]![e.category] ?? 0) + 1;
    }
    return depts.entries.map((e) {
      return DepartmentStats(
        department: e.key,
        researchCount: e.value['Research'] ?? 0,
        patentCount: e.value['Patent'] ?? 0,
        grantCount: e.value['Grant'] ?? 0,
        awardCount: e.value['Award'] ?? 0,
        startupCount: e.value['Startup'] ?? 0,
      );
    }).toList()
      ..sort((a, b) => b.totalInnovations.compareTo(a.totalInnovations));
  }

  Map<int, int> get monthlyTrend {
    final map = <int, int>{};
    for (int i = 1; i <= 12; i++) {
      map[i] = 0;
    }
    for (final e in _entries) {
      if (e.date.year == 2025 || e.date.year == 2026) {
        map[e.date.month] = (map[e.date.month] ?? 0) + 1;
      }
    }
    return map;
  }

  List<MapEntry<String, int>> get topContributors {
    final map = <String, int>{};
    for (final e in _entries) {
      for (final c in e.contributors) {
        map[c] = (map[c] ?? 0) + 1;
      }
    }
    final sorted = map.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    return sorted.take(10).toList();
  }

  // ── CRUD ──

  void addEntry(InnovationEntry entry) {
    _entries.add(entry);
    notifyListeners();
  }

  void updateEntry(InnovationEntry entry) {
    final idx = _entries.indexWhere((e) => e.id == entry.id);
    if (idx != -1) {
      _entries[idx] = entry;
      notifyListeners();
    }
  }

  void deleteEntry(String id) {
    _entries.removeWhere((e) => e.id == id);
    notifyListeners();
  }

  // ── Seed Data ──

  void _seedData() {
    _entries.addAll([
      // ─── Research ───
      InnovationEntry(
        id: 'r001',
        title: 'Deep Learning for Medical Image Analysis',
        category: 'Research',
        description:
            'A comprehensive study on applying deep learning techniques for automated diagnosis of medical conditions through imaging. Published in IEEE Transactions on Medical Imaging.',
        date: DateTime(2025, 11, 15),
        contributors: ['Dr. Priya Sharma', 'Ananya Gupta', 'Vikram Singh'],
        department: 'Computer Science',
        status: 'Published',
        metrics: {'citations': 45, 'impact_factor': 8.9},
      ),
      InnovationEntry(
        id: 'r002',
        title: 'Quantum Computing Algorithms for Optimization',
        category: 'Research',
        description:
            'Novel quantum algorithms designed for solving complex optimization problems with exponential speedup over classical methods.',
        date: DateTime(2025, 10, 3),
        contributors: ['Dr. Amit Patel', 'Rohan Mehta'],
        department: 'Electronics',
        status: 'Published',
        metrics: {'citations': 32, 'impact_factor': 7.2},
      ),
      InnovationEntry(
        id: 'r003',
        title: 'Sustainable Materials for Construction',
        category: 'Research',
        description:
            'Research into eco-friendly building materials using recycled waste products, demonstrating 40% cost reduction.',
        date: DateTime(2025, 9, 20),
        contributors: ['Dr. Neha Verma', 'Karan Joshi'],
        department: 'Civil Engineering',
        status: 'Published',
        metrics: {'citations': 18, 'impact_factor': 5.1},
      ),
      InnovationEntry(
        id: 'r004',
        title: 'AI-Powered Natural Language Processing',
        category: 'Research',
        description:
            'Development of transformer-based models for multilingual text understanding, achieving state-of-the-art results on Indian language benchmarks.',
        date: DateTime(2025, 8, 12),
        contributors: ['Dr. Priya Sharma', 'Sneha Reddy'],
        department: 'Computer Science',
        status: 'Published',
        metrics: {'citations': 67, 'impact_factor': 9.3},
      ),
      InnovationEntry(
        id: 'r005',
        title: 'Renewable Energy Storage Solutions',
        category: 'Research',
        description:
            'Innovative battery technology using graphene-based supercapacitors for efficient solar energy storage.',
        date: DateTime(2026, 1, 8),
        contributors: ['Dr. Sanjay Mishra', 'Aditya Kumar'],
        department: 'Electrical Engineering',
        status: 'In Review',
        metrics: {'citations': 5, 'impact_factor': 6.8},
      ),
      InnovationEntry(
        id: 'r006',
        title: 'Robotic Process Automation in Healthcare',
        category: 'Research',
        description:
            'Implementation of RPA bots for automating hospital administrative tasks, reducing manual effort by 60%.',
        date: DateTime(2025, 12, 1),
        contributors: ['Dr. Amit Patel', 'Priyanka Das'],
        department: 'Electronics',
        status: 'Published',
        metrics: {'citations': 22, 'impact_factor': 4.5},
      ),
      InnovationEntry(
        id: 'r007',
        title: 'Blockchain-Based Supply Chain Management',
        category: 'Research',
        description:
            'A decentralized framework for transparent and tamper-proof supply chain tracking using smart contracts.',
        date: DateTime(2026, 2, 14),
        contributors: ['Dr. Priya Sharma', 'Arjun Nair'],
        department: 'Computer Science',
        status: 'Submitted',
        metrics: {'citations': 0, 'impact_factor': 0},
      ),
      // ─── Patents ───
      InnovationEntry(
        id: 'p001',
        title: 'Smart IoT-Based Water Quality Monitor',
        category: 'Patent',
        description:
            'A cost-effective IoT device for real-time water quality monitoring using spectroscopy and machine learning classification.',
        date: DateTime(2025, 7, 22),
        contributors: ['Dr. Amit Patel', 'Rohan Mehta', 'Kavitha Rao'],
        department: 'Electronics',
        status: 'Approved',
        metrics: {'patent_number': 'IN202521001234'},
      ),
      InnovationEntry(
        id: 'p002',
        title: 'Biodegradable Packaging Material',
        category: 'Patent',
        description:
            'Novel biodegradable packaging material derived from agricultural waste with comparable strength to plastics.',
        date: DateTime(2025, 6, 15),
        contributors: ['Dr. Neha Verma', 'Anjali Deshmukh'],
        department: 'Civil Engineering',
        status: 'Approved',
        metrics: {'patent_number': 'IN202521002345'},
      ),
      InnovationEntry(
        id: 'p003',
        title: 'Adaptive Learning Algorithm Engine',
        category: 'Patent',
        description:
            'Machine learning engine that personalizes educational content delivery based on student learning patterns and performance.',
        date: DateTime(2026, 1, 20),
        contributors: ['Dr. Priya Sharma', 'Ananya Gupta'],
        department: 'Computer Science',
        status: 'In Review',
        metrics: {'patent_number': 'PENDING'},
      ),
      InnovationEntry(
        id: 'p004',
        title: 'Wearable Health Monitoring Band',
        category: 'Patent',
        description:
            'Low-power wearable device for continuous health parameter monitoring with cloud-based analytics dashboard.',
        date: DateTime(2025, 11, 5),
        contributors: ['Dr. Sanjay Mishra', 'Aditya Kumar', 'Meera Iyer'],
        department: 'Electrical Engineering',
        status: 'Approved',
        metrics: {'patent_number': 'IN202521003456'},
      ),
      // ─── Grants ───
      InnovationEntry(
        id: 'g001',
        title: 'DST-SERB Core Research Grant',
        category: 'Grant',
        description:
            'Government-funded research grant for advancing AI techniques in precision agriculture. Duration: 3 years.',
        date: DateTime(2025, 4, 1),
        contributors: ['Dr. Priya Sharma'],
        department: 'Computer Science',
        status: 'Approved',
        metrics: {'amount': 2500000, 'currency': 'INR'},
      ),
      InnovationEntry(
        id: 'g002',
        title: 'AICTE Research Promotion Scheme',
        category: 'Grant',
        description:
            'AICTE-funded project for developing low-cost assistive technology for differently-abled students.',
        date: DateTime(2025, 8, 15),
        contributors: ['Dr. Amit Patel', 'Dr. Sanjay Mishra'],
        department: 'Electronics',
        status: 'Approved',
        metrics: {'amount': 1800000, 'currency': 'INR'},
      ),
      InnovationEntry(
        id: 'g003',
        title: 'Industry-Sponsored Smart City Project',
        category: 'Grant',
        description:
            'Collaboration with Tata Group for smart urban planning solutions using IoT sensors and data analytics.',
        date: DateTime(2025, 5, 10),
        contributors: ['Dr. Neha Verma', 'Dr. Amit Patel'],
        department: 'Civil Engineering',
        status: 'Approved',
        metrics: {'amount': 5000000, 'currency': 'INR'},
      ),
      InnovationEntry(
        id: 'g004',
        title: 'DBT Biotechnology Innovation Grant',
        category: 'Grant',
        description:
            'Research funding for developing cost-effective biosensors for early disease detection.',
        date: DateTime(2026, 2, 1),
        contributors: ['Dr. Kavitha Rao'],
        department: 'Biotechnology',
        status: 'In Review',
        metrics: {'amount': 3200000, 'currency': 'INR'},
      ),
      // ─── Awards ───
      InnovationEntry(
        id: 'a001',
        title: 'Best Research Paper Award — IEEE Conference',
        category: 'Award',
        description:
            'Awarded for the paper on deep learning in medical imaging at the IEEE International Conference on Biomedical Engineering.',
        date: DateTime(2025, 12, 10),
        contributors: ['Dr. Priya Sharma', 'Ananya Gupta'],
        department: 'Computer Science',
        status: 'Approved',
        metrics: {'prize': '₹50,000', 'conference': 'IEEE ICBE 2025'},
      ),
      InnovationEntry(
        id: 'a002',
        title: 'National Innovation Award',
        category: 'Award',
        description:
            'Recognized by the Ministry of Education for outstanding contributions to innovation in higher education.',
        date: DateTime(2025, 10, 26),
        contributors: ['Dr. Rajesh Kumar'],
        department: 'Administration',
        status: 'Approved',
        metrics: {'prize': '₹1,00,000'},
      ),
      InnovationEntry(
        id: 'a003',
        title: 'Smart India Hackathon — Winner',
        category: 'Award',
        description:
            'First place in SIH 2025 for developing an AI-based crop disease detection system for farmers.',
        date: DateTime(2025, 9, 5),
        contributors: [
          'Ananya Gupta',
          'Rohan Mehta',
          'Sneha Reddy',
          'Arjun Nair'
        ],
        department: 'Computer Science',
        status: 'Approved',
        metrics: {'prize': '₹1,00,000', 'event': 'SIH 2025'},
      ),
      InnovationEntry(
        id: 'a004',
        title: 'Young Scientist Award — CSIR',
        category: 'Award',
        description:
            'CSIR Young Scientist Award for pioneering work in renewable energy storage technology.',
        date: DateTime(2026, 1, 26),
        contributors: ['Dr. Sanjay Mishra'],
        department: 'Electrical Engineering',
        status: 'Approved',
        metrics: {'prize': '₹2,00,000'},
      ),
      InnovationEntry(
        id: 'a005',
        title: 'Best Innovation Project — TechFest IIT',
        category: 'Award',
        description:
            'Won the innovation challenge at IIT Bombay TechFest for the smart water quality monitoring system.',
        date: DateTime(2025, 12, 20),
        contributors: ['Rohan Mehta', 'Kavitha Rao'],
        department: 'Electronics',
        status: 'Approved',
        metrics: {'prize': '₹75,000', 'event': 'TechFest 2025'},
      ),
      // ─── Startups ───
      InnovationEntry(
        id: 's001',
        title: 'AgriSense — Precision Agriculture Platform',
        category: 'Startup',
        description:
            'AI-powered platform providing real-time crop monitoring, disease prediction, and yield optimization for farmers. Incubated at the institute\'s innovation center.',
        date: DateTime(2025, 3, 15),
        contributors: ['Ananya Gupta', 'Vikram Singh'],
        department: 'Computer Science',
        status: 'Approved',
        metrics: {'funding': '₹15L seed', 'stage': 'Early Traction'},
      ),
      InnovationEntry(
        id: 's002',
        title: 'MediTrack — Healthcare Logistics',
        category: 'Startup',
        description:
            'Blockchain-based supply chain solution for pharmaceutical logistics, ensuring drug authenticity and cold-chain compliance.',
        date: DateTime(2025, 6, 1),
        contributors: ['Arjun Nair', 'Priyanka Das'],
        department: 'Computer Science',
        status: 'Approved',
        metrics: {'funding': '₹25L angel', 'stage': 'Growth'},
      ),
      InnovationEntry(
        id: 's003',
        title: 'EcoBlock — Green Construction',
        category: 'Startup',
        description:
            'Manufacturing sustainable building blocks from industrial waste. Already deployed in 3 construction projects.',
        date: DateTime(2025, 9, 10),
        contributors: ['Karan Joshi', 'Anjali Deshmukh'],
        department: 'Civil Engineering',
        status: 'Approved',
        metrics: {'funding': '₹10L grant', 'stage': 'Pilot'},
      ),
      InnovationEntry(
        id: 's004',
        title: 'NeuroLearn — Adaptive EdTech',
        category: 'Startup',
        description:
            'Personalized learning platform using neuroscience-backed techniques and AI to optimize student outcomes.',
        date: DateTime(2026, 1, 5),
        contributors: ['Sneha Reddy', 'Aditya Kumar'],
        department: 'Computer Science',
        status: 'In Review',
        metrics: {'funding': 'Pre-seed', 'stage': 'Ideation'},
      ),
      // ─── More Research ───
      InnovationEntry(
        id: 'r008',
        title: 'Machine Learning for Earthquake Prediction',
        category: 'Research',
        description:
            'Using seismic data and ML models to predict earthquake intensity and provide early warnings.',
        date: DateTime(2025, 7, 18),
        contributors: ['Dr. Neha Verma', 'Karan Joshi'],
        department: 'Civil Engineering',
        status: 'Published',
        metrics: {'citations': 28, 'impact_factor': 6.1},
      ),
      InnovationEntry(
        id: 'r009',
        title: '5G Network Optimization Using AI',
        category: 'Research',
        description:
            'AI-driven algorithms for optimizing 5G network resource allocation and reducing latency by 35%.',
        date: DateTime(2025, 5, 25),
        contributors: ['Dr. Sanjay Mishra', 'Meera Iyer'],
        department: 'Electrical Engineering',
        status: 'Published',
        metrics: {'citations': 41, 'impact_factor': 7.8},
      ),
      InnovationEntry(
        id: 'r010',
        title: 'Computer Vision for Traffic Management',
        category: 'Research',
        description:
            'Real-time traffic flow analysis and signal optimization using computer vision and edge computing.',
        date: DateTime(2026, 3, 1),
        contributors: ['Dr. Priya Sharma', 'Vikram Singh'],
        department: 'Computer Science',
        status: 'Submitted',
        metrics: {'citations': 0, 'impact_factor': 0},
      ),
    ]);
  }
}
