import 'package:flutter/material.dart';

/// The size of the loader indicator.
enum UiLoaderSize {
  small(16),
  medium(24),
  large(32);

  const UiLoaderSize(this.dimension);

  /// The width and height of the loader.
  final double dimension;
}

/// The color variant of the loader indicator.
enum UiLoaderColor {
  /// Uses the current icon color from the widget tree.
  inherit,

  /// Uses a secondary/muted color.
  secondary,
}

/// A circular loading indicator.
///
// TODO(mykhailo): Replace with a custom animated loader.
class UiLoader extends StatelessWidget {
  const UiLoader({this.size = UiLoaderSize.medium, this.color = UiLoaderColor.inherit, super.key});

  /// The size of the loader.
  final UiLoaderSize size;

  /// The color variant of the loader.
  final UiLoaderColor color;

  @override
  Widget build(BuildContext context) {
    return SizedBox.square(
      dimension: size.dimension,
      child: CircularProgressIndicator(
        strokeWidth: 2,
        color: switch (color) {
          UiLoaderColor.inherit => IconTheme.of(context).color,
          UiLoaderColor.secondary => Theme.of(context).colorScheme.onSurface.withValues(alpha: .5),
        },
      ),
    );
  }
}
