import 'dart:async';
import 'package:flutter/material.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/constants/app_typography.dart';
import '../../../../core/theme/nexid_palette.dart';
import '../../../../shared/widgets/app_logo.dart';

/// Pantalla de bienvenida y carga inicial (Splash con vida visual).
/// Proporciona retroalimentacion inmediata al abrir la aplicacion sin demoras bloqueantes.
class StartupSplashScreen extends StatefulWidget {
  const StartupSplashScreen({
    super.key,
    required this.onInitializationComplete,
    this.minimumDuration = const Duration(milliseconds: 650),
  });

  final VoidCallback onInitializationComplete;
  final Duration minimumDuration;

  @override
  State<StartupSplashScreen> createState() => _StartupSplashScreenState();
}

class _StartupSplashScreenState extends State<StartupSplashScreen> {
  Timer? _timer;
  String _statusMessage = 'Iniciando NexID...';

  @override
  void initState() {
    super.initState();
    _startStartupSequence();
  }

  void _startStartupSequence() {
    _timer = Timer(widget.minimumDuration, () {
      if (mounted) {
        setState(() => _statusMessage = 'Listo');
        widget.onInitializationComplete();
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final NexIdPalette palette = NexIdPalette.of(context);

    return Scaffold(
      backgroundColor: palette.background,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const NexIdAppLogo(size: 80, isLively: true),
              const SizedBox(height: AppDimensions.spaceLarge),
              Text(
                'NexID',
                style: AppTypography.titleLarge.copyWith(
                  color: palette.textPrimary,
                  letterSpacing: 0.5,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: AppDimensions.spaceXSmall),
              Text(
                'Identidad, Acceso y Registros',
                style: AppTypography.caption.copyWith(
                  color: palette.textSecondary,
                  letterSpacing: 0.3,
                ),
              ),
              const SizedBox(height: AppDimensions.spaceXLarge),
              SizedBox(
                width: 140,
                child: LinearProgressIndicator(
                  minHeight: 3,
                  color: palette.primary,
                  backgroundColor: palette.surfaceAccent,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: AppDimensions.spaceMedium),
              Text(
                _statusMessage,
                style: AppTypography.caption.copyWith(
                  color: palette.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
