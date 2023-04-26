import 'package:flutter/widgets.dart';

extension LocalizationX on BuildContext {
  T stringOf<T>() => Localizations.of<T>(this, T)!;
}
