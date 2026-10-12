import 'dart:async';
import 'package:flutter/foundation.dart';
import '../../../../core/performance/device_performance_tier.dart';
import '../../../../core/performance/priority_task_scheduler.dart';
import '../../data/students_repository.dart';
import '../../domain/student_models.dart';

/// Controlador para la gestion de alumnos con paginacion progresiva,
/// busqueda con debounce e hidratacion diferida segun PRIORIDAD 0.
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
  int _visibleLimit = DeviceMemoryGuard.instance.currentBudget.listPageSize;
  Timer? _searchDebounceTimer;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  String get searchQuery => _searchQuery;
  String? get statusFilter => _statusFilter;
  bool get hasCachedData => _students.isNotEmpty;

  int get pageSize => DeviceMemoryGuard.instance.currentBudget.listPageSize;
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

  List<Student> get paginatedStudents {
    final List<Student> filtered = students;
    if (filtered.length <= _visibleLimit) return filtered;
    return filtered.take(_visibleLimit).toList();
  }

  bool get hasMorePages => students.length > _visibleLimit;

  void loadMore() {
    _visibleLimit += pageSize;
    notifyListeners();
  }

  Future<void> loadStudents({bool forceSkeleton = false}) async {
    _isLoading = true;
    _errorMessage = null;
    if (forceSkeleton) {
      _students = <Student>[];
    }
    notifyListeners();

    try {
      _students = await PriorityTaskScheduler.instance.schedule<List<Student>>(
        priority: TaskPriority.medium,
        action: () async {
          if (forceSkeleton) {
            await Future<void>.delayed(const Duration(milliseconds: 180));
          }
          return repository.getStudents();
        },
      );
      _visibleLimit = pageSize;
    } catch (e) {
      _errorMessage = 'No se pudo consultar el padron local: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Hidrata el expediente completo de un alumno solo cuando se abre su ficha.
  Future<Student> hydrateStudentForProfile(Student summary) {
    return PriorityTaskScheduler.instance.schedule<Student>(
      priority: TaskPriority.medium,
      action: () => repository.hydrateStudentDetail(summary),
    );
  }

  void setSearchQuery(String query) {
    _searchDebounceTimer?.cancel();
    if (_searchQuery == query) return;
    _searchQuery = query;
    _visibleLimit = pageSize;
    notifyListeners();
  }

  /// Evita consultas y reconstrucciones excesivas mientras el usuario escribe.
  void setSearchQueryDebounced(String query) {
    _searchDebounceTimer?.cancel();
    final int debounceMs =
        DeviceMemoryGuard.instance.currentBudget.searchDebounceMs;
    _searchDebounceTimer = Timer(Duration(milliseconds: debounceMs), () {
      if (_searchQuery == query) return;
      _searchQuery = query;
      _visibleLimit = pageSize;
      notifyListeners();
    });
  }

  void setStatusFilter(String? status) {
    if (_statusFilter == status) return;
    _statusFilter = status;
    _visibleLimit = pageSize;
    notifyListeners();
  }

  void clearFilters() {
    _searchDebounceTimer?.cancel();
    _searchQuery = '';
    _statusFilter = null;
    _visibleLimit = pageSize;
    notifyListeners();
  }

  Future<void> updateStudent(Student student) async {
    _isLoading = true;
    notifyListeners();

    await repository.updateStudent(student);
    await loadStudents();
  }

  @override
  void dispose() {
    _searchDebounceTimer?.cancel();
    super.dispose();
  }
}
