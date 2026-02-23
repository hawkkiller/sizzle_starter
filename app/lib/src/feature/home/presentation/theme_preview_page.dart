import 'package:common_ui/common_ui.dart';
import 'package:flutter/material.dart';

/// A page that showcases all semantic tokens from the active [UiTheme].
class ThemePreviewPage extends StatelessWidget {
  const ThemePreviewPage({super.key});

  @override
  Widget build(BuildContext context) {
    final ui = UiTheme.of(context);

    return Scaffold(
      backgroundColor: ui.color.background,
      appBar: AppBar(
        title: Text('Theme Preview', style: ui.typography.titleLarge),
        backgroundColor: ui.color.surface,
        foregroundColor: ui.color.onSurface,
      ),
      body: ListView(
        padding: EdgeInsets.all(ui.spacing.s16),
        children: [
          _SectionHeader(title: 'Colors — Surfaces', ui: ui),
          _ColorRow(label: 'background', color: ui.color.background, ui: ui),
          _ColorRow(label: 'surface', color: ui.color.surface, ui: ui),
          _ColorRow(label: 'surfaceRaised', color: ui.color.surfaceRaised, ui: ui),
          _ColorRow(label: 'outline', color: ui.color.outline, ui: ui),
          _ColorRow(label: 'scrim', color: ui.color.scrim, ui: ui),
          SizedBox(height: ui.spacing.s24),
          _SectionHeader(title: 'Colors — Foreground', ui: ui),
          _ColorRow(label: 'onSurface', color: ui.color.onSurface, ui: ui),
          _ColorRow(label: 'onSurfaceMuted', color: ui.color.onSurfaceMuted, ui: ui),
          SizedBox(height: ui.spacing.s24),
          _SectionHeader(title: 'Colors — Primary', ui: ui),
          _ColorPairRow(
            label: 'primary',
            bg: ui.color.primary,
            fg: ui.color.onPrimary,
            ui: ui,
          ),
          SizedBox(height: ui.spacing.s24),
          _SectionHeader(title: 'Colors — Semantic', ui: ui),
          _ColorPairRow(
            label: 'success',
            bg: ui.color.success,
            fg: ui.color.onSuccess,
            ui: ui,
          ),
          _ColorPairRow(
            label: 'successContainer',
            bg: ui.color.successContainer,
            fg: ui.color.onSuccessContainer,
            ui: ui,
          ),
          _ColorPairRow(
            label: 'warning',
            bg: ui.color.warning,
            fg: ui.color.onWarning,
            ui: ui,
          ),
          _ColorPairRow(
            label: 'warningContainer',
            bg: ui.color.warningContainer,
            fg: ui.color.onWarningContainer,
            ui: ui,
          ),
          _ColorPairRow(
            label: 'error',
            bg: ui.color.error,
            fg: ui.color.onError,
            ui: ui,
          ),
          _ColorPairRow(
            label: 'errorContainer',
            bg: ui.color.errorContainer,
            fg: ui.color.onErrorContainer,
            ui: ui,
          ),
          _ColorPairRow(
            label: 'info',
            bg: ui.color.info,
            fg: ui.color.onInfo,
            ui: ui,
          ),
          _ColorPairRow(
            label: 'infoContainer',
            bg: ui.color.infoContainer,
            fg: ui.color.onInfoContainer,
            ui: ui,
          ),
          SizedBox(height: ui.spacing.s24),
          _SectionHeader(title: 'Typography', ui: ui),
          _TypographyRow(label: 'displayLarge', style: ui.typography.displayLarge, ui: ui),
          _TypographyRow(label: 'displayMedium', style: ui.typography.displayMedium, ui: ui),
          _TypographyRow(label: 'displaySmall', style: ui.typography.displaySmall, ui: ui),
          _TypographyRow(label: 'headlineLarge', style: ui.typography.headlineLarge, ui: ui),
          _TypographyRow(label: 'headlineMedium', style: ui.typography.headlineMedium, ui: ui),
          _TypographyRow(label: 'headlineSmall', style: ui.typography.headlineSmall, ui: ui),
          _TypographyRow(label: 'titleLarge', style: ui.typography.titleLarge, ui: ui),
          _TypographyRow(label: 'titleMedium', style: ui.typography.titleMedium, ui: ui),
          _TypographyRow(label: 'titleSmall', style: ui.typography.titleSmall, ui: ui),
          _TypographyRow(label: 'bodyLarge', style: ui.typography.bodyLarge, ui: ui),
          _TypographyRow(label: 'bodyMedium', style: ui.typography.bodyMedium, ui: ui),
          _TypographyRow(label: 'bodySmall', style: ui.typography.bodySmall, ui: ui),
          _TypographyRow(label: 'labelLarge', style: ui.typography.labelLarge, ui: ui),
          _TypographyRow(label: 'labelMedium', style: ui.typography.labelMedium, ui: ui),
          _TypographyRow(label: 'labelSmall', style: ui.typography.labelSmall, ui: ui),
          SizedBox(height: ui.spacing.s24),
          _SectionHeader(title: 'Radius', ui: ui),
          _RadiusRow(ui: ui),
          SizedBox(height: ui.spacing.s24),
          _SectionHeader(title: 'Elevation', ui: ui),
          _ElevationRow(ui: ui),
          SizedBox(height: ui.spacing.s24),
          _SectionHeader(title: 'Spacing', ui: ui),
          _SpacingRow(ui: ui),
          SizedBox(height: ui.spacing.s24),
          _SectionHeader(title: 'Interactive Sample', ui: ui),
          SizedBox(height: ui.spacing.s12),
          _InteractiveSample(ui: ui),
          SizedBox(height: ui.spacing.s48),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.title, required this.ui});

  final String title;
  final UiTheme ui;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: ui.spacing.s8),
      child: Text(title, style: ui.typography.titleMedium.copyWith(color: ui.color.onSurface)),
    );
  }
}

class _ColorRow extends StatelessWidget {
  const _ColorRow({required this.label, required this.color, required this.ui});

  final String label;
  final Color color;
  final UiTheme ui;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: ui.spacing.s4),
      child: Row(
        children: [
          DecoratedBox(
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(ui.radius.interactive),
              border: Border.all(color: ui.color.outline, width: ui.borderWidth.hairline),
            ),
            child: const SizedBox(width: 48, height: 32),
          ),
          SizedBox(width: ui.spacing.s12),
          Text(label, style: ui.typography.bodyMedium.copyWith(color: ui.color.onSurface)),
        ],
      ),
    );
  }
}

class _ColorPairRow extends StatelessWidget {
  const _ColorPairRow({
    required this.label,
    required this.bg,
    required this.fg,
    required this.ui,
  });

  final String label;
  final Color bg;
  final Color fg;
  final UiTheme ui;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: ui.spacing.s4),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(ui.radius.interactive),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: ui.spacing.s12, vertical: ui.spacing.s8),
          child: Text(label, style: ui.typography.labelLarge.copyWith(color: fg)),
        ),
      ),
    );
  }
}

class _TypographyRow extends StatelessWidget {
  const _TypographyRow({required this.label, required this.style, required this.ui});

  final String label;
  final TextStyle style;
  final UiTheme ui;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: ui.spacing.s4),
      child: Text(label, style: style.copyWith(color: ui.color.onSurface)),
    );
  }
}

class _RadiusRow extends StatelessWidget {
  const _RadiusRow({required this.ui});

  final UiTheme ui;

  @override
  Widget build(BuildContext context) {
    final items = [
      ('none', ui.radius.none),
      ('interactive', ui.radius.interactive),
      ('container', ui.radius.container),
      ('dialog', ui.radius.dialog),
      ('full', ui.radius.full),
    ];

    return Wrap(
      spacing: ui.spacing.s8,
      runSpacing: ui.spacing.s8,
      children: [
        for (final (label, radius) in items)
          Column(
            children: [
              DecoratedBox(
                decoration: BoxDecoration(
                  color: ui.color.primary,
                  borderRadius: BorderRadius.circular(radius.clamp(0, 24)),
                ),
                child: const SizedBox(width: 48, height: 48),
              ),
              SizedBox(height: ui.spacing.s4),
              Text(label, style: ui.typography.labelSmall.copyWith(color: ui.color.onSurfaceMuted)),
            ],
          ),
      ],
    );
  }
}

class _ElevationRow extends StatelessWidget {
  const _ElevationRow({required this.ui});

  final UiTheme ui;

  @override
  Widget build(BuildContext context) {
    final items = [
      ('none', ui.elevation.none),
      ('raised', ui.elevation.raised),
      ('floating', ui.elevation.floating),
      ('overlay', ui.elevation.overlay),
      ('modal', ui.elevation.modal),
    ];

    return Wrap(
      spacing: ui.spacing.s16,
      runSpacing: ui.spacing.s8,
      children: [
        for (final (label, elevation) in items)
          Column(
            children: [
              Material(
                elevation: elevation,
                borderRadius: BorderRadius.circular(ui.radius.container),
                color: ui.color.surfaceRaised,
                child: const SizedBox(width: 64, height: 48),
              ),
              SizedBox(height: ui.spacing.s4),
              Text(label, style: ui.typography.labelSmall.copyWith(color: ui.color.onSurfaceMuted)),
            ],
          ),
      ],
    );
  }
}

class _SpacingRow extends StatelessWidget {
  const _SpacingRow({required this.ui});

  final UiTheme ui;

  @override
  Widget build(BuildContext context) {
    final items = [
      ('s4', ui.spacing.s4),
      ('s8', ui.spacing.s8),
      ('s12', ui.spacing.s12),
      ('s16', ui.spacing.s16),
      ('s24', ui.spacing.s24),
      ('s32', ui.spacing.s32),
      ('s48', ui.spacing.s48),
    ];

    return Wrap(
      spacing: ui.spacing.s8,
      runSpacing: ui.spacing.s8,
      crossAxisAlignment: WrapCrossAlignment.end,
      children: [
        for (final (label, size) in items)
          Column(
            children: [
              DecoratedBox(
                decoration: BoxDecoration(
                  color: ui.color.primary.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(ui.radius.none),
                ),
                child: SizedBox(width: size, height: size),
              ),
              SizedBox(height: ui.spacing.s4),
              Text(label, style: ui.typography.labelSmall.copyWith(color: ui.color.onSurfaceMuted)),
            ],
          ),
      ],
    );
  }
}

class _InteractiveSample extends StatelessWidget {
  const _InteractiveSample({required this.ui});

  final UiTheme ui;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: ui.color.surface,
        borderRadius: BorderRadius.circular(ui.radius.container),
        border: Border.all(color: ui.color.outline, width: ui.borderWidth.subtle),
      ),
      child: Padding(
        padding: EdgeInsets.all(ui.spacing.s16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Card Title', style: ui.typography.titleMedium.copyWith(color: ui.color.onSurface)),
            SizedBox(height: ui.spacing.s4),
            Text(
              'A sample card using surface, outline, spacing, and radius tokens together.',
              style: ui.typography.bodyMedium.copyWith(color: ui.color.onSurfaceMuted),
            ),
            SizedBox(height: ui.spacing.s16),
            Row(
              children: [
                _SampleButton(
                  label: 'Primary',
                  bg: ui.color.primary,
                  fg: ui.color.onPrimary,
                  ui: ui,
                ),
                SizedBox(width: ui.spacing.s8),
                _SampleButton(
                  label: 'Success',
                  bg: ui.color.success,
                  fg: ui.color.onSuccess,
                  ui: ui,
                ),
                SizedBox(width: ui.spacing.s8),
                _SampleButton(
                  label: 'Error',
                  bg: ui.color.error,
                  fg: ui.color.onError,
                  ui: ui,
                ),
              ],
            ),
            SizedBox(height: ui.spacing.s12),
            DecoratedBox(
              decoration: BoxDecoration(
                color: ui.color.infoContainer,
                borderRadius: BorderRadius.circular(ui.radius.container),
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: ui.spacing.s12,
                  vertical: ui.spacing.s8,
                ),
                child: Row(
                  children: [
                    Icon(Icons.info_outline, size: 16, color: ui.color.onInfoContainer),
                    SizedBox(width: ui.spacing.s8),
                    Expanded(
                      child: Text(
                        'This is an info banner using container tokens.',
                        style: ui.typography.bodySmall.copyWith(color: ui.color.onInfoContainer),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SampleButton extends StatelessWidget {
  const _SampleButton({
    required this.label,
    required this.bg,
    required this.fg,
    required this.ui,
  });

  final String label;
  final Color bg;
  final Color fg;
  final UiTheme ui;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(ui.radius.interactive),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: ui.spacing.s12, vertical: ui.spacing.s8),
        child: Text(label, style: ui.typography.labelLarge.copyWith(color: fg)),
      ),
    );
  }
}
