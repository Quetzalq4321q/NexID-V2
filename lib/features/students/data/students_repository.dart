import '../../../../core/performance/bounded_lru_cache.dart';
import '../../../../core/performance/device_performance_tier.dart';
import '../domain/student_models.dart';

/// Repositorio local de alumnos segun agent/23_CACHE_USABLE.md y PRIORIDAD 0.
/// Separa la proyeccion ligera para listados de la hidratacion bajo demanda
/// de datos secundarios (cursos, documentos, historial) en una cache LRU acotada.
class StudentsRepository {
  StudentsRepository() {
    DeviceMemoryGuard.instance.registerTransientCacheCleanup(clearDetailCache);
  }

  final BoundedLruCache<String, Student> _detailCache =
      BoundedLruCache<String, Student>(
    maxEntries:
        DeviceMemoryGuard.instance.currentBudget.maxHydratedStudentDetails,
    ttl: const Duration(minutes: 5),
  );

  /// Lista ligera en memoria: conserva unicamente campos esenciales para la lista.
  final List<Student> _summaries = <Student>[
    Student(
      id: 'STU-1001',
      code: '2023-0149',
      fullName: 'Ana Maria Morales Quispe',
      career: 'Ingenieria de Sistemas',
      faculty: 'Facultad de Ingenieria y Arquitectura',
      documentNumber: '72418930',
      status: 'Matriculado Regular',
      updatedAt: DateTime.now().subtract(const Duration(hours: 4)),
      academicPeriod: '2026-I',
      academicCycle: 'VII Ciclo',
      section: 'IS-701 Turno Manana',
      weightedAverage: 17.2,
      attendanceRate: 96,
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
      academicPeriod: '2026-I',
      academicCycle: 'IX Ciclo',
      section: 'ADM-902 Turno Noche',
      weightedAverage: 15.6,
      attendanceRate: 91,
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
      academicPeriod: '2026-I',
      academicCycle: 'V Ciclo',
      section: 'DER-501 Turno Tarde',
      weightedAverage: 16.8,
      attendanceRate: 88,
    ),
  ];

  int get cachedExtendedDetailCount => _detailCache.length;

  /// Recupera unicamente los campos de resumen necesarios para renderizar la lista.
  Future<List<Student>> getStudents() async {
    _detailCache.updateMaxEntries(
      DeviceMemoryGuard.instance.currentBudget.maxHydratedStudentDetails,
    );
    return List<Student>.unmodifiable(_summaries);
  }

  Future<Student?> getStudentById(String id) async {
    final int index = _summaries.indexWhere((Student s) => s.id == id);
    if (index == -1) return null;
    return hydrateStudentDetail(_summaries[index]);
  }

  /// Hidrata bajo demanda los cursos, documentos, observaciones e historial
  /// unicamente cuando el usuario abre el expediente del alumno.
  Future<Student> hydrateStudentDetail(Student summary) {
    _detailCache.updateMaxEntries(
      DeviceMemoryGuard.instance.currentBudget.maxHydratedStudentDetails,
    );
    return _detailCache.putIfAbsentAsync(summary.id, () async {
      return summary.id == 'STU-1002'
          ? _hydrateSecondStudent(summary)
          : _hydrateDefaultStudent(summary);
    });
  }

  Future<Student> updateStudent(Student updated) async {
    final int index = _summaries.indexWhere((Student s) => s.id == updated.id);
    if (index != -1) {
      final Student merged = _summaries[index].copyWith(
        fullName: updated.fullName,
        career: updated.career,
        faculty: updated.faculty,
        documentNumber: updated.documentNumber,
        status: updated.status,
      );
      _summaries[index] = merged;
      _detailCache.remove(updated.id);
      return merged;
    }
    _summaries.add(updated);
    return updated;
  }

  /// Permite poblar un padron extenso en pruebas de estres de gama baja.
  void seedBulkSummariesForTesting(int count) {
    if (_summaries.length >= count) return;
    for (int i = _summaries.length + 1; i <= count; i++) {
      _summaries.add(
        Student(
          id: 'STU-${1000 + i}',
          code: '2025-${i.toString().padLeft(4, '0')}',
          fullName: 'Alumno Padron Local $i',
          career: i.isEven ? 'Ingenieria de Sistemas' : 'Administracion',
          faculty: 'Facultad General',
          documentNumber: '${70000000 + i}',
          status: i % 5 == 0 ? 'Reserva de Matricula' : 'Matriculado Regular',
          updatedAt: DateTime.now(),
          attendanceRate: 85 + (i % 15),
        ),
      );
    }
  }

  void clearDetailCache() => _detailCache.clear();

  Student _hydrateSecondStudent(Student base) {
    return Student(
      id: base.id,
      code: base.code,
      fullName: base.fullName,
      career: base.career,
      faculty: base.faculty,
      documentNumber: base.documentNumber,
      status: base.status,
      updatedAt: base.updatedAt,
      institutionalEmail: 'm.torres.demo@universidad.edu.pe',
      phone: '+51 992 458 109 (Dato Demo)',
      address: 'Jr. Huallaga 410, Cercado, Lima (Dato Demo)',
      emergencyContact: 'Jorge Torres (Padre) - +51 990 112 874 (Demo)',
      academicPeriod: base.academicPeriod,
      academicCycle: base.academicCycle,
      section: base.section,
      weightedAverage: base.weightedAverage,
      attendanceRate: base.attendanceRate,
      courses: const <StudentCourseItem>[
        StudentCourseItem(code: 'ADM-901', name: 'Direccion Estrategica Corporativa (Demo)', section: 'N-1', credits: 4, grade: 16.0, attendancePercentage: 92),
        StudentCourseItem(code: 'ADM-904', name: 'Finanzas Internacionales (Demo)', section: 'N-2', credits: 4, grade: 15.2, attendancePercentage: 90),
      ],
      enrollmentHistory: const <EnrollmentHistoryItem>[
        EnrollmentHistoryItem(period: '2026-I', cycleLabel: 'IX Ciclo', condition: 'Matricula Regular (Demo)', enrolledCredits: 20),
      ],
      observations: const <StudentRecordNote>[
        StudentRecordNote(title: 'Practicas Preprofesionales Autorizadas (Demo)', category: 'Seguimiento', dateLabel: '18/03/2026', detail: 'Horario flexible para ingreso nocturno.'),
      ],
    );
  }

  Student _hydrateDefaultStudent(Student base) {
    return Student(
      id: base.id,
      code: base.code,
      fullName: base.fullName,
      career: base.career,
      faculty: base.faculty,
      documentNumber: base.documentNumber,
      status: base.status,
      updatedAt: base.updatedAt,
      institutionalEmail: 'a.morales.demo@universidad.edu.pe',
      phone: '+51 984 110 245 (Dato Demo)',
      address: 'Av. Arequipa 2450, Lince, Lima (Dato Demo)',
      emergencyContact: 'Carmen Quispe (Madre) - +51 981 300 412 (Demo)',
      academicPeriod: base.academicPeriod,
      academicCycle: base.academicCycle,
      section: base.section,
      weightedAverage: base.weightedAverage,
      attendanceRate: base.attendanceRate,
      courses: const <StudentCourseItem>[
        StudentCourseItem(code: 'SIS-701', name: 'Arquitectura de Software Empresarial (Demo)', section: 'A-1', credits: 4, grade: 18.0, attendancePercentage: 98),
        StudentCourseItem(code: 'SIS-702', name: 'Seguridad Criptografica y Sistemas NFC (Demo)', section: 'A-1', credits: 4, grade: 17.5, attendancePercentage: 95),
      ],
      enrollmentHistory: <EnrollmentHistoryItem>[
        EnrollmentHistoryItem(period: '2026-I', cycleLabel: base.academicCycle, condition: 'Matricula Regular Invicta (Demo)', enrolledCredits: 21),
      ],
      observations: const <StudentRecordNote>[
        StudentRecordNote(title: 'Beca de Excelencia Academica (Demo)', category: 'Bienestar Universitario', dateLabel: '10/03/2026', detail: 'Beneficiaria activa con acceso prioritario a laboratorios.'),
      ],
      documents: const <StudentRecordNote>[
        StudentRecordNote(title: 'Ficha de Matricula 2026-I Firmada (Demo)', category: 'Documento PDF', dateLabel: '04/03/2026', detail: 'Verificado digitalmente en Secretaria Academica.'),
      ],
    );
  }
}
