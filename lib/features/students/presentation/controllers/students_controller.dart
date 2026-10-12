import 'package:flutter/foundation.dart';
import '../../data/students_repository.dart';
import '../../domain/student_models.dart';

/// Controlador para la gestion de alumnos en la interfaz.
class StudentsController extends ChangeNotifier {
  StudentsController({required this._repository}) {
    loadStudents();
  }

  final StudentsRepository _repository;
  List<Student> _students = [];
  bool _isLoading = false;
  String _searchQuery = '';

  List<Student> get students {
    if (_searchQuery.isEmpty) return _students;
    final String q = _searchQuery.toLowerCase();
    return _students.where((s) {
      return s.fullName.toLowerCase().contains(q) ||
          s.code.toLowerCase().contains(q) ||
          s.career.toLowerCase().contains(q);
    }).toList();
  }

  bool get isLoading => _isLoading;

  Future<void> loadStudents() async {
    _isLoading = true;
    notifyListeners();

    _students = await _repository.getStudents();

    _isLoading = false;
    notifyListeners();
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  Future<void> updateStudent(Student student) async {
    _isLoading = true;
    notifyListeners();

    await _repository.updateStudent(student);
    await loadStudents();
  }
}
