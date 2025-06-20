import 'package:flutter/widgets.dart';

class MediaQueryRootOverride extends StatelessWidget {
  const MediaQueryRootOverride({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return MediaQuery.withClampedTextScaling(
      maxScaleFactor: 2,
      child: child,
    );
  }
}
