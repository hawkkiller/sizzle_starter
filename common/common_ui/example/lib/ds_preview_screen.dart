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
          Wrap(
            spacing: theme.spacing.s16,
            runSpacing: theme.spacing.s16,
            children: [
              UiButton(
                label: 'Primary',
                onPressed: () {
                  print('Primary button pressed');
                },
              ),
              UiButton(
                label: 'Secondary',
                onPressed: () {},
                style: UiButtonStyle.secondary,
              ),
              UiButton(
                label: 'Outline',
                onPressed: () {},
                style: UiButtonStyle.outline,
              ),
              UiButton(
                label: 'Ghost',
                onPressed: () {},
                style: UiButtonStyle.ghost,
              ),
            ],
          ),
          SizedBox(height: theme.spacing.s8),
          Wrap(
            spacing: theme.spacing.s16,
            runSpacing: theme.spacing.s16,
            children: [
              UiButton(
                label: 'Primary',
                onPressed: () {},
                role: UiButtonRole.destructive,
              ),
              UiButton(
                label: 'Secondary',
                onPressed: () {},
                style: UiButtonStyle.secondary,
                role: UiButtonRole.destructive,
              ),
              UiButton(
                label: 'Outline',
                onPressed: () {},
                style: UiButtonStyle.outline,
                role: UiButtonRole.destructive,
              ),
              UiButton(
                label: 'Ghost',
                onPressed: () {},
                style: UiButtonStyle.ghost,
                role: UiButtonRole.destructive,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
