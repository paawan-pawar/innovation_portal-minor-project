class DepartmentStats {
  final String department;
  final int researchCount;
  final int patentCount;
  final int grantCount;
  final int awardCount;
  final int startupCount;

  const DepartmentStats({
    required this.department,
    this.researchCount = 0,
    this.patentCount = 0,
    this.grantCount = 0,
    this.awardCount = 0,
    this.startupCount = 0,
  });

  int get totalInnovations =>
      researchCount + patentCount + grantCount + awardCount + startupCount;
}
