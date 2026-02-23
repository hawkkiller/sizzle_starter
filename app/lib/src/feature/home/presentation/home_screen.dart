import 'package:flutter/material.dart';
import 'package:sizzle_starter/src/feature/settings/presentation/settings_scope.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  void _onSeedColorChanged(BuildContext context, Color color) {
    SettingsScope.update(
      context,
      (settings) => settings.copyWith(
        general: settings.general.copyWith(seedColor: color),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final settings = SettingsScope.of(context);

    return Scaffold(
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              'Seed color',
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
          const SizedBox(height: 8),
          SizedBox(
            height: 48,
            child: ListView.separated(
              separatorBuilder: (context, index) => const SizedBox(width: 8),
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: Colors.accents.length,
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                final color = Colors.accents[index];
                final isSelected = settings.general.seedColor.toARGB32() == color.toARGB32();

                return _ColorItem(
                  color: color,
                  isSelected: isSelected,
                  onTap: (color) => _onSeedColorChanged(context, color),
                );
              },
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}

class _ColorItem extends StatelessWidget {
  const _ColorItem({required this.color, required this.isSelected, required this.onTap});

  final ValueChanged<Color> onTap;
  final bool isSelected;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: () => onTap(color),
      child: SizedBox.square(
        dimension: 48,
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(16),
          ),
          child: isSelected ? Icon(Icons.check, color: colorScheme.onPrimaryFixed) : null,
        ),
      ),
    );
  }
}
