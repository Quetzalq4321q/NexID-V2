/// Modelo de estudiante en la base local segun agent/23_CACHE_USABLE.md.
class Student {
  const Student({
    required this.id,
    required this.code,
    required this.fullName,
    required this.career,
    this.faculty,
    this.documentNumber,
    required this.status,
    this.photoUrl,
    required this.updatedAt,
  });

  final String id;
  final String code;
  final String fullName;
  final String career;
  final String? faculty;
  final String? documentNumber;
  final String status;
  final String? photoUrl;
  final DateTime updatedAt;

  Student copyWith({
    String? fullName,
    String? career,
    String? faculty,
    String? documentNumber,
    String? status,
    String? photoUrl,
  }) {
    return Student(
      id: id,
      code: code,
      fullName: fullName ?? this.fullName,
      career: career ?? this.career,
      faculty: faculty ?? this.faculty,
      documentNumber: documentNumber ?? this.documentNumber,
      status: status ?? this.status,
      photoUrl: photoUrl ?? this.photoUrl,
      updatedAt: DateTime.now(),
    );
  }
}
