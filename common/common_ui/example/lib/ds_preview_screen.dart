import 'package:common_ui/common_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

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
          SizedBox(height: theme.spacing.s8),
          const CardPreview(),
          SizedBox(height: theme.spacing.s8),
          const LoaderPreview(),
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

class CardPreview extends StatelessWidget {
  const CardPreview({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = UiTheme.of(context);

    return Align(
      alignment: Alignment.centerLeft,
      child: UiCard(
        width: 150,
        height: 150,
        child: Column(
          crossAxisAlignment: .start,
          children: [
            Row(
              mainAxisSize: .min,
              spacing: theme.spacing.s8,
              children: [
                SizedBox(
                  width: 32,
                  height: 32,
                  child: ClipOval(
                    child: SvgPicture.asset(
                      'assets/euflag.svg',
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                UiText.titleMedium('EUR', color: theme.color.onSurfaceMuted),
              ],
            ),
            const Spacer(),
            Row(
              mainAxisSize: .min,
              spacing: theme.spacing.s4,
              children: [
                Icon(Icons.account_balance_wallet, size: 16, color: theme.color.onSurfaceMuted),
                UiText.bodyMedium('**61305', color: theme.color.onSurfaceMuted),
              ],
            ),
            SizedBox(height: theme.spacing.s4),
            UiText.titleLarge('1,000.00', color: theme.color.onSurface),
          ],
        ),
      ),
    );
  }
}

class LoaderPreview extends StatelessWidget {
  const LoaderPreview({super.key});

  @override
  Widget build(BuildContext context) {
    return const Align(
      alignment: Alignment.centerLeft,
      child: UiLoader(),
    );
  }
}
