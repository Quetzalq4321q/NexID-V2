import '../domain/student_models.dart';

/// Repositorio local de alumnos segun agent/23_CACHE_USABLE.md.
/// Mantiene un subconjunto autorizado suficiente para visualizacion y uso local.
class StudentsRepository {
  final List<Student> _students = [
    Student(
      id: 'STU-1001',
      code: '2023-0149',
      fullName: 'Ana Maria Morales Quispe',
      career: 'Ingenieria de Sistemas',
      faculty: 'Facultad de Ingenieria y Arquitectura',
      documentNumber: '72418930',
      status: 'Matriculado Regular',
      updatedAt: DateTime.now().subtract(const Duration(hours: 4)),
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
    ),
    Student(
      id: 'STU-1003',
      code: '2024-0055',
      fullName: 'Lucia Jimena Mendoza Flores',
      career: 'Derecho y Ciencias Politicas',
      faculty: 'Facultad de Derecho',
      documentNumber: '74102938',
      status: 'Matriculado Regular',
      updatedAt: DateTime.now().subtract(const Duration(days: 1)),
    ),
  ];

  Future<List<Student>> getStudents() async {
    return List<Student>.unmodifiable(_students);
  }

  Future<Student?> getStudentById(String id) async {
    final int index = _students.indexWhere((s) => s.id == id);
    if (index != -1) return _students[index];
    return null;
  }

  Future<Student> updateStudent(Student updated) async {
    final int index = _students.indexWhere((s) => s.id == updated.id);
    if (index != -1) {
      _students[index] = updated;
      return updated;
    }
    _students.add(updated);
    return updated;
  }
}
