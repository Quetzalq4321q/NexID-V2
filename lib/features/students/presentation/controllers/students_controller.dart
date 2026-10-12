import 'package:flutter/foundation.dart';
import '../../data/students_repository.dart';
import '../../domain/student_models.dart';

/// Controlador para la gestion de alumnos con filtros avanzados, KPIs y estados de carga.
class StudentsController extends ChangeNotifier {
  StudentsController({required this.repository}) {
    loadStudents();
  }

  final StudentsRepository repository;
  List<Student> _students = <Student>[];
  bool _isLoading = false;
  String? _errorMessage;
  String _searchQuery = '';
  String? _statusFilter;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  String get searchQuery => _searchQuery;
  String? get statusFilter => _statusFilter;
  bool get hasCachedData => _students.isNotEmpty;

  int get totalCount => _students.length;
  int get regularCount => _students
      .where((Student s) => s.status.toLowerCase().contains('regular'))
      .length;

  int get averageAttendanceRate {
    if (_students.isEmpty) return 0;
    final int sum = _students.fold<int>(
      0,
      (int acc, Student s) => acc + s.attendanceRate,
    );
    return (sum / _students.length).round();
  }

  List<Student> get students {
    return _students.where((Student s) {
      if (_statusFilter != null && s.status != _statusFilter) {
        return false;
      }
      if (_searchQuery.isEmpty) return true;
      final String q = _searchQuery.toLowerCase();
      return s.fullName.toLowerCase().contains(q) ||
          s.code.toLowerCase().contains(q) ||
          s.career.toLowerCase().contains(q) ||
          (s.documentNumber?.toLowerCase().contains(q) ?? false) ||
          (s.faculty?.toLowerCase().contains(q) ?? false);
    }).toList();
  }

  Future<void> loadStudents({bool forceSkeleton = false}) async {
    _isLoading = true;
    _errorMessage = null;
    if (forceSkeleton) {
      _students = <Student>[];
    }
    notifyListeners();

    try {
      if (forceSkeleton) {
        await Future<void>.delayed(const Duration(milliseconds: 450));
      }
      _students = await repository.getStudents();
    } catch (e) {
      _errorMessage = 'No se pudo consultar el padron local: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void setSearchQuery(String query) {
    if (_searchQuery == query) return;
    _searchQuery = query;
    notifyListeners();
  }

  void setStatusFilter(String? status) {
    if (_statusFilter == status) return;
    _statusFilter = status;
    notifyListeners();
  }

  void clearFilters() {
    _searchQuery = '';
    _statusFilter = null;
    notifyListeners();
  }

  Future<void> updateStudent(Student student) async {
    _isLoading = true;
    notifyListeners();

    await repository.updateStudent(student);
    await loadStudents();
  }
}
