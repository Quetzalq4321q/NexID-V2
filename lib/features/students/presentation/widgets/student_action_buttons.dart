import 'package:flutter/material.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../shared/widgets/primary_button.dart';
import '../../../../shared/widgets/secondary_button.dart';
import '../../../records/domain/record_models.dart';

/// Barra de botones de accion adaptable para registro de ingreso y salida.
class StudentActionButtons extends StatelessWidget {
  const StudentActionButtons({
    super.key,
    required this.isRegistering,
    required this.onRegister,
  });

  final bool isRegistering;
  final void Function(EventType type) onRegister;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        if (constraints.maxWidth < 420) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              PrimaryButton(
                label: 'Registrar Ingreso',
                icon: Icons.login,
                isLoading: isRegistering,
                onPressed: () => onRegister(EventType.entrada),
              ),
              const SizedBox(height: AppDimensions.spaceSmall),
              SecondaryButton(
                label: 'Registrar Salida',
                icon: Icons.logout,
                onPressed: () => onRegister(EventType.salida),
              ),
            ],
          );
        }
        return Row(
          children: [
            Expanded(
              child: PrimaryButton(
                label: 'Registrar Ingreso',
                icon: Icons.login,
                isLoading: isRegistering,
                onPressed: () => onRegister(EventType.entrada),
              ),
            ),
            const SizedBox(width: AppDimensions.spaceMedium),
            Expanded(
              child: SecondaryButton(
                label: 'Registrar Salida',
                icon: Icons.logout,
                onPressed: () => onRegister(EventType.salida),
              ),
            ),
          ],
        );
      },
    );
  }
}
