import 'package:flutter/material.dart';
import 'app/app.dart';

/// Punto de entrada minimo de la aplicacion segun agent/02_ARQUITECTURA.md.
/// No contiene logica de negocio ni configuracion directa de servicios.
void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const NexIdApp());
}
