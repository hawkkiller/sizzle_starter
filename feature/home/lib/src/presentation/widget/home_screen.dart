import 'package:flutter/material.dart';
import 'package:settings_api/settings_api.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  void _onColorSelected(Color color) {
    final bloc = SettingsScope.blocOf(context);
    final settings = SettingsScope.settingsOf(context);

    bloc.add(
      SettingsEvent.updateSettings(
        settings: settings.copyWith(
          themeConfiguration: settings.themeConfiguration?.copyWith(seedColor: color),
        ),
      ),
    );
  }

  Widget _buildColorItem(BuildContext context, int index) {
    return _ColorItem(color: Colors.accents[index], onTap: _onColorSelected);
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
            child: ListView.separated(
              separatorBuilder: (context, index) => const SizedBox(width: 8),
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemBuilder: _buildColorItem,
              itemCount: Colors.accents.length,
              scrollDirection: Axis.horizontal,
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}

class _ColorItem extends StatelessWidget {
  const _ColorItem({required this.color, required this.onTap});

  final ValueChanged<Color> onTap;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final settings = SettingsScope.settingsOf(context);

    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: () => onTap(color),
      child: SizedBox.square(
        dimension: 48,
        child: DecoratedBox(
          decoration: BoxDecoration(
            border: Border.all(
              width: 2,
              color: settings.themeConfiguration?.seedColor == color
                  ? Colors.black
                  : Colors.transparent,
            ),
            borderRadius: BorderRadius.circular(16),
            color: color,
          ),
        ),
      ),
    );
  }
}
