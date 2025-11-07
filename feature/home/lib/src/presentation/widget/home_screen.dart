import 'package:flutter/material.dart';
import 'package:settings/settings.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Widget _buildColorItem(Color color, bool isSelected) {
    return _ColorItem(
      color: color,
      isSelected: isSelected,
      onTap: _onSeedColorChanged,
    );
  }

  void _onSeedColorChanged(Color color) {
    SettingsScope.of(context).settingsBloc.add(
      SettingsEventUpdate(
        onUpdate: (settings) => settings.copyWith(
          general: settings.general.copyWith(seedColor: color),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Welcome to Sizzle Starter!')),
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
            child: SettingsBuilder(
              builder: (context, data) {
                return ListView.separated(
                  separatorBuilder: (context, index) => const SizedBox(width: 8),
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: Colors.accents.length,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) {
                    final color = Colors.accents[index];

                    return _buildColorItem(
                      color,
                      data.general.seedColor.toARGB32() == color.toARGB32(),
                    );
                  },
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
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: () => onTap(color),
      child: SizedBox.square(
        dimension: 48,
        child: DecoratedBox(
          decoration: BoxDecoration(
            border: Border.all(
              width: 2,
              color: isSelected ? Colors.black : Colors.transparent,
            ),
            borderRadius: BorderRadius.circular(16),
            color: color,
          ),
        ),
      ),
    );
  }
}
