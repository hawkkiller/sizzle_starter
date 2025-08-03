import 'package:flutter/material.dart';

final lightTheme = ThemeData.light();
final darkTheme = ThemeData.dark();

class ThemeOptionInput extends StatelessWidget {
  const ThemeOptionInput({super.key});

  static final _entries = <DropdownMenuEntry<ThemeData>>[
    DropdownMenuEntry<ThemeData>(value: lightTheme, label: 'Light'),
    DropdownMenuEntry<ThemeData>(value: darkTheme, label: 'Dark'),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = ThemeOptionInherited.of(context);

    return DropdownMenu<ThemeData>(
      dropdownMenuEntries: _entries,
      initialSelection: theme ?? _entries.first.value,
      onSelected: (value) {
        if (value == null) return;
        ThemeOptionInherited.setTheme(context, value);
      },
    );
  }
}

class ThemeOptionInherited extends StatefulWidget {
  const ThemeOptionInherited({this.child, this.builder, super.key});

  final Widget? child;
  final Widget Function(BuildContext context, ThemeData theme)? builder;

  static void setTheme(BuildContext context, ThemeData theme) {
    final inherited =
        context.getElementForInheritedWidgetOfExactType<_ThemeOptionInherited>()?.widget
            as _ThemeOptionInherited?;
    inherited?.state.setTheme(theme);
  }

  static ThemeData? of(BuildContext context, {bool listen = true}) {
    final inherited = listen
        ? context.dependOnInheritedWidgetOfExactType<_ThemeOptionInherited>()
        : context.getElementForInheritedWidgetOfExactType<_ThemeOptionInherited>()?.widget
              as _ThemeOptionInherited?;
    return inherited?.theme;
  }

  @override
  State<ThemeOptionInherited> createState() => ThemeOptionInheritedState();
}

class ThemeOptionInheritedState extends State<ThemeOptionInherited> {
  ThemeData _theme = lightTheme;

  void setTheme(ThemeData theme) {
    if (_theme != theme) {
      setState(() {
        _theme = theme;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return _ThemeOptionInherited(
      theme: _theme,
      state: this,
      child: widget.builder?.call(context, _theme) ?? widget.child!,
    );
  }
}

class _ThemeOptionInherited extends InheritedWidget {
  const _ThemeOptionInherited({required this.theme, required super.child, required this.state});

  final ThemeOptionInheritedState state;
  final ThemeData theme;

  @override
  bool updateShouldNotify(_ThemeOptionInherited oldWidget) {
    return theme != oldWidget.theme;
  }
}
