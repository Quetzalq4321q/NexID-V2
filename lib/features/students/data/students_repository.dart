import '../domain/student_models.dart';

/// Repositorio local de alumnos segun agent/23_CACHE_USABLE.md.
/// Los datos academicos extendidos estan claramente identificados como
/// informacion ficticia de demostracion local ([DEMO]).
class StudentsRepository {
  final List<Student> _students = <Student>[
    Student(
      id: 'STU-1001',
      code: '2023-0149',
      fullName: 'Ana Maria Morales Quispe',
      career: 'Ingenieria de Sistemas',
      faculty: 'Facultad de Ingenieria y Arquitectura',
      documentNumber: '72418930',
      status: 'Matriculado Regular',
      updatedAt: DateTime.now().subtract(const Duration(hours: 4)),
      institutionalEmail: 'a.morales.demo@universidad.edu.pe',
      phone: '+51 984 110 245 (Dato Demo)',
      address: 'Av. Arequipa 2450, Lince, Lima (Dato Demo)',
      emergencyContact: 'Carmen Quispe (Madre) - +51 981 300 412 (Demo)',
      academicPeriod: '2026-I',
      academicCycle: 'VII Ciclo',
      section: 'IS-701 Turno Manana',
      weightedAverage: 17.2,
      attendanceRate: 96,
      courses: const <StudentCourseItem>[
        StudentCourseItem(
          code: 'SIS-701',
          name: 'Arquitectura de Software Empresarial (Demo)',
          section: 'A-1',
          credits: 4,
          grade: 18.0,
          attendancePercentage: 98,
        ),
        StudentCourseItem(
          code: 'SIS-702',
          name: 'Seguridad Criptografica y Sistemas NFC (Demo)',
          section: 'A-1',
          credits: 4,
          grade: 17.5,
          attendancePercentage: 95,
        ),
        StudentCourseItem(
          code: 'SIS-703',
          name: 'Bases de Datos Distribuidas (Demo)',
          section: 'B-2',
          credits: 3,
          grade: 16.0,
          attendancePercentage: 94,
        ),
      ],
      enrollmentHistory: const <EnrollmentHistoryItem>[
        EnrollmentHistoryItem(
          period: '2026-I',
          cycleLabel: 'VII Ciclo',
          condition: 'Matricula Regular Invicta (Demo)',
          enrolledCredits: 21,
        ),
        EnrollmentHistoryItem(
          period: '2025-II',
          cycleLabel: 'VI Ciclo',
          condition: 'Promovido Tercio Superior (Demo)',
          enrolledCredits: 22,
        ),
      ],
      observations: const <StudentRecordNote>[
        StudentRecordNote(
          title: 'Beca de Excelencia Academica (Demo)',
          category: 'Bienestar Universitario',
          dateLabel: '10/03/2026',
          detail: 'Beneficiaria activa con acceso prioritario a laboratorios.',
        ),
      ],
      documents: const <StudentRecordNote>[
        StudentRecordNote(
          title: 'Ficha de Matricula 2026-I Firmada (Demo)',
          category: 'Documento PDF',
          dateLabel: '04/03/2026',
          detail: 'Verificado digitalmente en Secretaria Academica.',
        ),
        StudentRecordNote(
          title: 'Consentimiento de Uso de Credencial NFC (Demo)',
          category: 'Autorizacion',
          dateLabel: '05/03/2026',
          detail: 'Tarjeta UID 04:A1:20:01 vinculada.',
        ),
      ],
      importantDates: const <StudentRecordNote>[
        StudentRecordNote(
          title: 'Renovacion de Credencial Universitaria',
          category: 'Vencimiento',
          dateLabel: '31/12/2026',
          detail: 'Vigencia anual del carnet universitario.',
        ),
      ],
      modificationHistory: const <StudentRecordNote>[
        StudentRecordNote(
          title: 'Sincronizacion desde padron institucional',
          category: 'Sistema',
          dateLabel: 'Hace 4 horas',
          detail: 'Cache SQLite actualizada sin conflictos.',
        ),
      ],
    ),
    Student(
      id: 'STU-1002',
      code: '2022-0812',
      fullName: 'Mateo Alejandro Torres Castro',
      career: 'Administracion de Empresas',
      faculty: 'Facultad de Ciencias Economicas',
      documentNumber: '71923014',
      status: 'Matriculado Regular',
      updatedAt: DateTime.now().subtract(const Duration(hours: 12)),
      institutionalEmail: 'm.torres.demo@universidad.edu.pe',
      phone: '+51 992 458 109 (Dato Demo)',
      address: 'Jr. Huallaga 410, Cercado, Lima (Dato Demo)',
      emergencyContact: 'Jorge Torres (Padre) - +51 990 112 874 (Demo)',
      academicPeriod: '2026-I',
      academicCycle: 'IX Ciclo',
      section: 'ADM-902 Turno Noche',
      weightedAverage: 15.6,
      attendanceRate: 91,
      courses: const <StudentCourseItem>[
        StudentCourseItem(
          code: 'ADM-901',
          name: 'Direccion Estrategica Corporativa (Demo)',
          section: 'N-1',
          credits: 4,
          grade: 16.0,
          attendancePercentage: 92,
        ),
        StudentCourseItem(
          code: 'ADM-904',
          name: 'Finanzas Internacionales (Demo)',
          section: 'N-2',
          credits: 4,
          grade: 15.2,
          attendancePercentage: 90,
        ),
      ],
      enrollmentHistory: const <EnrollmentHistoryItem>[
        EnrollmentHistoryItem(
          period: '2026-I',
          cycleLabel: 'IX Ciclo',
          condition: 'Matricula Regular (Demo)',
          enrolledCredits: 20,
        ),
      ],
      observations: const <StudentRecordNote>[
        StudentRecordNote(
          title: 'Practicas Preprofesionales Autorizadas (Demo)',
          category: 'Seguimiento',
          dateLabel: '18/03/2026',
          detail: 'Horario flexible para ingreso nocturno.',
        ),
      ],
      documents: const <StudentRecordNote>[
        StudentRecordNote(
          title: 'Constancia de Matricula 2026-I (Demo)',
          category: 'Documento PDF',
          dateLabel: '06/03/2026',
          detail: 'Expediente validado.',
        ),
      ],
    ),
    Student(
      id: 'STU-1003',
      code: '2024-0055',
      fullName: 'Lucia Jimena Mendoza Flores',
      career: 'Derecho y Ciencias Politicas',
      faculty: 'Facultad de Derecho',
      documentNumber: '74102938',
      status: 'Reserva de Matricula',
      updatedAt: DateTime.now().subtract(const Duration(days: 1)),
      institutionalEmail: 'l.mendoza.demo@universidad.edu.pe',
      phone: '+51 975 309 881 (Dato Demo)',
      address: 'Calle Las Begonias 320, San Isidro (Dato Demo)',
      emergencyContact: 'Elena Flores (Madre) - +51 974 001 992 (Demo)',
      academicPeriod: '2026-I',
      academicCycle: 'V Ciclo',
      section: 'DER-501 Turno Tarde',
      weightedAverage: 16.8,
      attendanceRate: 88,
      courses: const <StudentCourseItem>[
        StudentCourseItem(
          code: 'DER-501',
          name: 'Derecho Constitucional Procesal (Demo)',
          section: 'T-1',
          credits: 4,
          grade: 16.8,
          attendancePercentage: 88,
        ),
      ],
      enrollmentHistory: const <EnrollmentHistoryItem>[
        EnrollmentHistoryItem(
          period: '2026-I',
          cycleLabel: 'V Ciclo',
          condition: 'Reserva Temporal Solicitada (Demo)',
          enrolledCredits: 12,
        ),
      ],
      observations: const <StudentRecordNote>[
        StudentRecordNote(
          title: 'Tramite de Reserva en Revision (Demo)',
          category: 'Secretaria Academica',
          dateLabel: '01/04/2026',
          detail: 'Acceso habilitado a Biblioteca y Tramites.',
        ),
      ],
    ),
  ];

  Future<List<Student>> getStudents() async {
    return List<Student>.unmodifiable(_students);
  }

  Future<Student?> getStudentById(String id) async {
    final int index = _students.indexWhere((Student s) => s.id == id);
    return index != -1 ? _students[index] : null;
  }

  Future<Student> updateStudent(Student updated) async {
    final int index = _students.indexWhere((Student s) => s.id == updated.id);
    if (index != -1) {
      final Student merged = _students[index].copyWith(
        fullName: updated.fullName,
        career: updated.career,
        faculty: updated.faculty,
        documentNumber: updated.documentNumber,
        status: updated.status,
      );
      _students[index] = merged;
      return merged;
    }
    _students.add(updated);
    return updated;
  }
}
