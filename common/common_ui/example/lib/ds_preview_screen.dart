import 'package:common_ui/common_ui.dart';
import 'package:flutter/material.dart';

class DsPreviewScreen extends StatelessWidget {
  const DsPreviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = UiTheme.of(context);

    return Scaffold(
      backgroundColor: theme.color.background,
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const _ButtonsPreview(role: UiButtonRole.normal),
          SizedBox(height: theme.spacing.s4),
          const _ButtonsPreview(role: UiButtonRole.destructive),
          SizedBox(height: theme.spacing.s8),
          const _IconButtonsPreview(role: UiButtonRole.normal),
          SizedBox(height: theme.spacing.s8),
          const _IconButtonsPreview(role: UiButtonRole.destructive),
          SizedBox(height: theme.spacing.s8),
          const BadgesPreview(),
          SizedBox(height: theme.spacing.s8),
          const BadgesPreview(spacious: true),
          SizedBox(height: theme.spacing.s8),
          const InputPreview(),
        ],
      ),
    );
  }
}

class _ButtonsPreview extends StatelessWidget {
  const _ButtonsPreview({required this.role});

  final UiButtonRole role;

  @override
  Widget build(BuildContext context) {
    final theme = UiTheme.of(context);

    return Wrap(
      spacing: theme.spacing.s16,
      runSpacing: theme.spacing.s16,
      children: [
        UiButton(
          label: 'Primary',
          onPressed: () {},
          role: role,
        ),
        UiButton(
          label: 'Secondary',
          onPressed: () {},
          style: UiButtonStyle.secondary,
          role: role,
        ),
        UiButton(
          label: 'Outline',
          onPressed: () {},
          style: UiButtonStyle.outline,
          role: role,
        ),
        UiButton(
          label: 'Ghost',
          onPressed: () {},
          style: UiButtonStyle.ghost,
          role: role,
        ),
      ],
    );
  }
}

class _IconButtonsPreview extends StatelessWidget {
  const _IconButtonsPreview({required this.role});

  final UiButtonRole role;

  @override
  Widget build(BuildContext context) {
    final theme = UiTheme.of(context);

    return Wrap(
      spacing: theme.spacing.s16,
      runSpacing: theme.spacing.s16,
      children: [
        UiButton.iconOnly(
          label: 'Primary',
          icon: const Icon(Icons.add),
          onPressed: () {},
          role: role,
        ),
        UiButton.iconOnly(
          label: 'Secondary',
          icon: const Icon(Icons.add),
          style: UiButtonStyle.secondary,
          onPressed: () {},
          role: role,
        ),
        UiButton.iconOnly(
          label: 'Outline',
          icon: const Icon(Icons.add),
          style: UiButtonStyle.outline,
          onPressed: () {},
          role: role,
        ),
        UiButton.iconOnly(
          label: 'Ghost',
          icon: const Icon(Icons.add),
          style: UiButtonStyle.ghost,
          onPressed: () {},
          role: role,
        ),
      ],
    );
  }
}

class BadgesPreview extends StatelessWidget {
  const BadgesPreview({super.key, this.spacious = false});

  final bool spacious;

  @override
  Widget build(BuildContext context) {
    final theme = UiTheme.of(context);

    return Wrap(
      spacing: theme.spacing.s16,
      runSpacing: theme.spacing.s16,
      children: [
        UiBadge(label: 'Info', spacious: spacious),
        UiBadge(label: 'Warning', variant: UiBadgeVariant.warning, spacious: spacious),
        UiBadge(label: 'Error', variant: UiBadgeVariant.error, spacious: spacious),
        UiBadge(label: 'Success', variant: UiBadgeVariant.success, spacious: spacious),
        UiBadge(label: 'Neutral', variant: UiBadgeVariant.neutral, spacious: spacious),
      ],
    );
  }
}

class InputPreview extends StatelessWidget {
  const InputPreview({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = UiTheme.of(context);
    return Align(
      alignment: Alignment.centerLeft,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 300),
        child: Column(
          mainAxisSize: .min,
          children: [
            const UiInput(
              labelText: 'Label',
              hintText: 'Hint',
              prefixIcon: Icon(Icons.person),
              keyboardType: TextInputType.emailAddress,
            ),
            SizedBox(height: theme.spacing.s8),
            const UiInput(
              labelText: 'Disabled',
              hintText: 'Hint',
              prefixIcon: Icon(Icons.person),
              enabled: false,
              keyboardType: TextInputType.emailAddress,
            ),
          ],
        ),
      ),
    );
  }
}
