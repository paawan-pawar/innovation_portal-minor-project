import 'package:flutter/material.dart';
import '../models/user_model.dart';

class AuthService extends ChangeNotifier {
  UserModel? _currentUser;
  bool _isLoading = false;

  UserModel? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  bool get isLoggedIn => _currentUser != null;

  // Demo users
  static const List<UserModel> _demoUsers = [
    UserModel(
      id: 'admin_001',
      name: 'Dr. Rajesh Kumar',
      email: 'admin@institute.edu',
      role: UserRole.admin,
      department: 'Administration',
    ),
    UserModel(
      id: 'faculty_001',
      name: 'Dr. Priya Sharma',
      email: 'priya.sharma@institute.edu',
      role: UserRole.faculty,
      department: 'Computer Science',
    ),
    UserModel(
      id: 'faculty_002',
      name: 'Dr. Amit Patel',
      email: 'amit.patel@institute.edu',
      role: UserRole.faculty,
      department: 'Electronics',
    ),
    UserModel(
      id: 'student_001',
      name: 'Ananya Gupta',
      email: 'ananya.g@institute.edu',
      role: UserRole.student,
      department: 'Computer Science',
    ),
    UserModel(
      id: 'student_002',
      name: 'Rohan Mehta',
      email: 'rohan.m@institute.edu',
      role: UserRole.student,
      department: 'Mechanical',
    ),
  ];

  List<UserModel> get demoUsers => _demoUsers;

  Future<bool> login(String email, String password, UserRole role) async {
    _isLoading = true;
    notifyListeners();

    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 1200));

    // Find a matching demo user by role
    try {
      _currentUser = _demoUsers.firstWhere((u) => u.role == role);
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  void logout() {
    _currentUser = null;
    notifyListeners();
  }
}
