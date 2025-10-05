import 'package:flutter/material.dart';
import 'package:settings/settings.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Widget _buildColorItem(int index, Color? seedColor) {
    final itemColor = Colors.accents[index];

    return _ColorItem(
      color: itemColor,
      seedColor: seedColor,
      onTap: _onSeedColorChanged,
    );
  }

  void _onSeedColorChanged(Color color) {
    SettingsScope.of(context).settingsBloc.add(
      SettingsEventUpdate(
        onUpdate: (settings) => settings.copyWith(
          theme: settings.theme.copyWith(seedColor: color),
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
                    return _buildColorItem(index, data.theme.seedColor);
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
  const _ColorItem({required this.color, required this.seedColor, required this.onTap});

  final ValueChanged<Color> onTap;
  final Color? seedColor;
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
              color: seedColor?.toARGB32() == color.toARGB32() ? Colors.black : Colors.transparent,
            ),
            borderRadius: BorderRadius.circular(16),
            color: color,
          ),
        ),
      ),
    );
  }
}
