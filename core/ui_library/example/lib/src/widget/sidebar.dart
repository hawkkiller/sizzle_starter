import 'package:flutter/material.dart';
import 'package:ui_showcase/ui_showcase.dart';

class Sidebar extends StatelessWidget {
  const Sidebar({
    required this.children,
    this.includeThemeSwitcher = true,
    super.key,
  });

  final bool includeThemeSwitcher;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 24,
        children: [
          if (includeThemeSwitcher) const ThemeOptionInput(),
          ...children,
        ],
      ),
    );
  }
}
