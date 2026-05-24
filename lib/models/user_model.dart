enum UserRole { admin, faculty, student }

class UserModel {
  final String id;
  final String name;
  final String email;
  final UserRole role;
  final String department;
  final String avatarUrl;

  const UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    required this.department,
    this.avatarUrl = '',
  });

  String get roleDisplayName {
    switch (role) {
      case UserRole.admin:
        return 'Administrator';
      case UserRole.faculty:
        return 'Faculty';
      case UserRole.student:
        return 'Student';
    }
  }

  String get initials {
    final parts = name.split(' ');
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return name[0].toUpperCase();
  }
}
