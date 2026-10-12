/// Curso matriculado en el periodo academico (datos de demostracion local).
class StudentCourseItem {
  const StudentCourseItem({
    required this.code,
    required this.name,
    required this.section,
    required this.credits,
    required this.grade,
    required this.attendancePercentage,
  });

  final String code;
  final String name;
  final String section;
  final int credits;
  final double grade;
  final int attendancePercentage;
}

/// Historial de matricula por periodo academico.
class EnrollmentHistoryItem {
  const EnrollmentHistoryItem({
    required this.period,
    required this.cycleLabel,
    required this.condition,
    required this.enrolledCredits,
  });

  final String period;
  final String cycleLabel;
  final String condition;
  final int enrolledCredits;
}

/// Documento o seguimiento asociado al expediente del alumno.
class StudentRecordNote {
  const StudentRecordNote({
    required this.title,
    required this.category,
    required this.dateLabel,
    required this.detail,
  });

  final String title;
  final String category;
  final String dateLabel;
  final String detail;
}

/// Modelo de estudiante en la base local segun agent/23_CACHE_USABLE.md.
/// Conserva compatibilidad total con la tabla SQLite local e incorpora
/// secciones academicas extendidas identificadas como datos de demostracion.
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
    this.institutionalEmail = 'alumno.demo@universidad.edu.pe',
    this.phone = '+51 987 654 321 (Demo)',
    this.address = 'Av. Universitaria 1800, Lima (Demo)',
    this.emergencyContact = ' Tutor registrado - +51 999 111 222 (Demo)',
    this.academicPeriod = '2026-I',
    this.academicCycle = 'VII Ciclo',
    this.section = 'Seccion A - Turno Manana',
    this.weightedAverage = 16.4,
    this.attendanceRate = 94,
    this.courses = const <StudentCourseItem>[],
    this.enrollmentHistory = const <EnrollmentHistoryItem>[],
    this.observations = const <StudentRecordNote>[],
    this.documents = const <StudentRecordNote>[],
    this.importantDates = const <StudentRecordNote>[],
    this.modificationHistory = const <StudentRecordNote>[],
    this.isDemoExtendedData = true,
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

  // Campos extendidos de ficha integral (claramente identificados como demo local)
  final String institutionalEmail;
  final String phone;
  final String address;
  final String emergencyContact;
  final String academicPeriod;
  final String academicCycle;
  final String section;
  final double weightedAverage;
  final int attendanceRate;
  final List<StudentCourseItem> courses;
  final List<EnrollmentHistoryItem> enrollmentHistory;
  final List<StudentRecordNote> observations;
  final List<StudentRecordNote> documents;
  final List<StudentRecordNote> importantDates;
  final List<StudentRecordNote> modificationHistory;
  final bool isDemoExtendedData;

  Student copyWith({
    String? fullName,
    String? career,
    String? faculty,
    String? documentNumber,
    String? status,
    String? photoUrl,
    String? institutionalEmail,
    String? phone,
    String? address,
    String? academicPeriod,
    String? academicCycle,
    String? section,
    double? weightedAverage,
    int? attendanceRate,
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
      institutionalEmail: institutionalEmail ?? this.institutionalEmail,
      phone: phone ?? this.phone,
      address: address ?? this.address,
      emergencyContact: emergencyContact,
      academicPeriod: academicPeriod ?? this.academicPeriod,
      academicCycle: academicCycle ?? this.academicCycle,
      section: section ?? this.section,
      weightedAverage: weightedAverage ?? this.weightedAverage,
      attendanceRate: attendanceRate ?? this.attendanceRate,
      courses: courses,
      enrollmentHistory: enrollmentHistory,
      observations: observations,
      documents: documents,
      importantDates: importantDates,
      modificationHistory: <StudentRecordNote>[
        StudentRecordNote(
          title: 'Actualizacion autorizada en terminal local',
          category: 'Auditoria Local',
          dateLabel: 'Reciente',
          detail: 'Modificacion de ficha por operador autenticado',
        ),
        ...modificationHistory,
      ],
      isDemoExtendedData: isDemoExtendedData,
    );
  }
}
