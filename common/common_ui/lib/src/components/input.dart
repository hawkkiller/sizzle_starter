import 'package:common_ui/common_ui.dart';
import 'package:flutter/material.dart';

class UiInput extends StatelessWidget {
  const UiInput({
    this.controller,
    this.focusNode,
    this.labelText,
    this.hintText,
    this.descriptionText,
    this.prefixIcon,
    this.suffixIcon,
    this.textInputAction,
    this.keyboardType,
    this.obscureText = false,
    this.autocorrect = true,
    this.enabled = true,
    this.minLines,
    this.maxLines = 1,
    super.key,
  });

  final String? labelText;
  final String? hintText;
  final String? descriptionText;
  final TextInputAction? textInputAction;
  final TextInputType? keyboardType;
  final bool obscureText;
  final bool autocorrect;
  final bool enabled;
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final int? minLines;
  final int? maxLines;

  @override
  Widget build(BuildContext context) {
    final theme = UiTheme.of(context);
    final borderRadius = BorderRadius.circular(theme.radius.component);

    return Semantics(
      label: labelText ?? hintText ?? '',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        spacing: theme.spacing.s2,
        children: [
          if (labelText != null)
            ExcludeSemantics(
              child: Text(labelText!, style: theme.typography.labelLarge),
            ),
          TextField(
            controller: controller,
            focusNode: focusNode,
            textInputAction: textInputAction,
            keyboardType: keyboardType,
            obscureText: obscureText,
            autocorrect: autocorrect,
            enabled: enabled,
            minLines: minLines,
            maxLines: maxLines,
            style: theme.typography.bodyLarge.copyWith(
              color: theme.color.onSurface,
              height: 1,
            ),
            decoration: InputDecoration(
              hoverColor: theme.color.surface,
              prefixIcon: prefixIcon,
              suffixIcon: suffixIcon,
              hintText: hintText,
              constraints: const BoxConstraints(maxHeight: 44),
              errorStyle: theme.typography.bodyLarge.copyWith(
                color: theme.color.error,
                height: 1,
              ),
              hintStyle: theme.typography.bodyLarge.copyWith(
                color: theme.color.onSurfaceMuted,
                height: 1,
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: theme.color.outline, width: theme.borderWidth.subtle),
                borderRadius: borderRadius,
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: theme.color.focus, width: theme.borderWidth.focus),
                borderRadius: borderRadius,
              ),
              border: OutlineInputBorder(
                borderSide: BorderSide(color: theme.color.outline, width: theme.borderWidth.subtle),
                borderRadius: borderRadius,
              ),
              errorBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: theme.color.error,
                  width: theme.borderWidth.subtle,
                ),
                borderRadius: borderRadius,
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: theme.color.error,
                  width: theme.borderWidth.focus,
                ),
                borderRadius: borderRadius,
              ),
              disabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: theme.color.outline),
                borderRadius: borderRadius,
              ),
            ),
          ),
          if (descriptionText != null)
            Semantics(
              container: true,
              child: Text(
                descriptionText!,
                style: theme.typography.bodySmall.copyWith(
                  color: theme.color.onSurface,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
