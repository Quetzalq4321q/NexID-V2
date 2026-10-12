import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/constants/app_typography.dart';
import '../../../../shared/widgets/primary_button.dart';
import '../../domain/session_models.dart';
import '../controllers/session_controller.dart';

/// Pantalla 1: Acceso al sistema cuando no hay sesion activa.
class LoginPage extends StatefulWidget {
  const LoginPage({
    super.key,
    required this.controller,
  });

  final SessionController controller;

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  OperatorUser? _selectedQuickOperator;

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _onLoginPressed() {
    final String user = _usernameController.text.trim();
    final String pass = _passwordController.text.trim();
    if (user.isEmpty) return;
    widget.controller.login(user, pass);
  }

  void _onQuickOperatorSelected(OperatorUser? operator) {
    if (operator == null) return;
    setState(() {
      _selectedQuickOperator = operator;
      _usernameController.text = operator.username;
      _passwordController.text = 'demopassword';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(
              horizontal: AppDimensions.spaceLarge,
              vertical: AppDimensions.spaceExtraLarge,
            ),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 440),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Marcador de marca NexID
                  Container(
                    width: 64,
                    height: 64,
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(AppDimensions.radius),
                    ),
                    child: const Icon(
                      Icons.nfc_outlined,
                      size: 36,
                      color: AppColors.background,
                    ),
                  ),
                  const SizedBox(height: AppDimensions.spaceLarge),

                  const Text(
                    'NexID',
                    style: AppTypography.titleLarge,
                  ),
                  const SizedBox(height: AppDimensions.spaceSmall),
                  const Text(
                    'Control local de credenciales NFC y QR. Seleccione un perfil de operador o ingrese credenciales.',
                    style: AppTypography.bodySmall,
                  ),
                  const SizedBox(height: AppDimensions.spaceExtraLarge),

                  // Selector rapido para pruebas locales
                  Container(
                    padding: const EdgeInsets.all(AppDimensions.spaceMedium),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(AppDimensions.radius),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Perfil local de prueba',
                          style: AppTypography.caption,
                        ),
                        const SizedBox(height: AppDimensions.spaceSmall),
                        DropdownButtonFormField<OperatorUser>(
                          initialValue: _selectedQuickOperator,
                          hint: const Text(
                            'Seleccionar operador local',
                            style: AppTypography.bodySmall,
                          ),
                          isExpanded: true,
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.zero,
                          ),
                          items: widget.controller.availableOperators
                              .map((OperatorUser op) {
                            return DropdownMenuItem<OperatorUser>(
                              value: op,
                              child: Text(
                                '${op.displayName} (${op.role.label})',
                                style: AppTypography.bodyMedium,
                              ),
                            );
                          }).toList(),
                          onChanged: _onQuickOperatorSelected,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppDimensions.spaceLarge),

                  // Campos de formulario
                  TextField(
                    controller: _usernameController,
                    decoration: InputDecoration(
                      labelText: 'Usuario operador',
                      labelStyle: AppTypography.bodySmall,
                      border: OutlineInputBorder(
                        borderRadius:
                            BorderRadius.circular(AppDimensions.radius),
                        borderSide: const BorderSide(color: AppColors.border),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius:
                            BorderRadius.circular(AppDimensions.radius),
                        borderSide: const BorderSide(color: AppColors.border),
                      ),
                    ),
                  ),
                  const SizedBox(height: AppDimensions.spaceMedium),

                  TextField(
                    controller: _passwordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: 'Contrasena',
                      labelStyle: AppTypography.bodySmall,
                      border: OutlineInputBorder(
                        borderRadius:
                            BorderRadius.circular(AppDimensions.radius),
                        borderSide: const BorderSide(color: AppColors.border),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius:
                            BorderRadius.circular(AppDimensions.radius),
                        borderSide: const BorderSide(color: AppColors.border),
                      ),
                    ),
                  ),
                  const SizedBox(height: AppDimensions.spaceLarge),

                  PrimaryButton(
                    label: 'Iniciar Sesion',
                    icon: Icons.login_outlined,
                    isLoading: widget.controller.isLoading,
                    onPressed: _onLoginPressed,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
