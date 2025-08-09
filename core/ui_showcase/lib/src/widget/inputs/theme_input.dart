import 'package:flutter/material.dart';

class ThemeOptionInput extends StatelessWidget {
  const ThemeOptionInput({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = ThemeOptionProvider.of(context);

    return DropdownMenu<ThemeData>(
      dropdownMenuEntries: theme.options
          .map((e) => DropdownMenuEntry(value: e.theme, label: e.name))
          .toList(),
      initialSelection: theme.theme,
      onSelected: (value) {
        if (value == null) return;
        ThemeOptionProvider.setTheme(context, value);
      },
    );
  }
}

class ThemeOptionProvider extends StatefulWidget {
  const ThemeOptionProvider({required this.options, this.child, this.builder, super.key});

  final Widget? child;
  final Widget Function(BuildContext context, ThemeData theme)? builder;
  final List<ThemeOption> options;

  static void setTheme(BuildContext context, ThemeData theme) {
    final inherited =
        context.getElementForInheritedWidgetOfExactType<_ThemeOptionInherited>()?.widget
            as _ThemeOptionInherited?;
    inherited?.state.setTheme(theme);
  }

  static ThemeOptionProviderState of(BuildContext context, {bool listen = true}) {
    final inherited = listen
        ? context.dependOnInheritedWidgetOfExactType<_ThemeOptionInherited>()
        : context.getElementForInheritedWidgetOfExactType<_ThemeOptionInherited>()?.widget
              as _ThemeOptionInherited?;

    if (inherited == null) {
      throw FlutterError.fromParts([
        ErrorSummary('ThemeOptionProvider not found in context'),
        ErrorDescription('ThemeOptionProvider is required to be a parent of the widget that uses it'),
        ErrorHint('Make sure to wrap your widget in ThemeOptionProvider'),
      ]);
    }

    return inherited.state;
  }

  @override
  State<ThemeOptionProvider> createState() => ThemeOptionProviderState();
}

class ThemeOptionProviderState extends State<ThemeOptionProvider> {
  late ThemeData theme = widget.options.first.theme;
  List<ThemeOption> get options => widget.options;

  void setTheme(ThemeData theme) {
    if (this.theme != theme) {
      setState(() {
        this.theme = theme;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return _ThemeOptionInherited(
      theme: theme,
      state: this,
      child: widget.builder?.call(context, theme) ?? widget.child!,
    );
  }
}

class _ThemeOptionInherited extends InheritedWidget {
  const _ThemeOptionInherited({required this.theme, required super.child, required this.state});

  final ThemeOptionProviderState state;
  final ThemeData theme;

  @override
  bool updateShouldNotify(_ThemeOptionInherited oldWidget) {
    return theme != oldWidget.theme;
  }
}

class ThemeOption {
  const ThemeOption({required this.name, required this.theme});

  final String name;
  final ThemeData theme;

  @override
  bool operator ==(Object other) {
    if (other is ThemeOption) {
      return name == other.name && theme == other.theme;
    }
    return false;
  }

  @override
  int get hashCode => name.hashCode ^ theme.hashCode;
}
