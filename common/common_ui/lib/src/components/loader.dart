import 'package:common_ui/common_ui.dart';
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

class UiLoader extends StatelessWidget {
  const UiLoader({this.size = UiLoaderSize.medium, this.color, super.key});

  /// The size of the loader.
  final UiLoaderSize size;

  /// The color variant of the loader.
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return SizedBox.square(
      dimension: size.dimension,
      child: CircularProgressIndicator.adaptive(
        strokeWidth: 2,
        valueColor: AlwaysStoppedAnimation(color ?? UiTheme.of(context).color.onSurface),
      ),
    );
  }
}
