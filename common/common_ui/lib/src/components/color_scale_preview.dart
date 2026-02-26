import 'package:common_ui/src/primitives/color_scale.dart';
import 'package:flutter/material.dart';

class ColorScalePreview extends StatelessWidget {
  const ColorScalePreview({required this.title, required this.colorScale, super.key});

  final String title;
  final UiColorScale colorScale;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(width: 100, child: Text(title)),
        Expanded(
          child: _ColorPreview(
            label: '50',
            labelColor: colorScale.shade900,
            color: colorScale.shade50,
          ),
        ),
        Expanded(
          child: _ColorPreview(
            label: '100',
            labelColor: colorScale.shade900,
            color: colorScale.shade100,
          ),
        ),
        Expanded(
          child: _ColorPreview(
            label: '200',
            labelColor: colorScale.shade900,
            color: colorScale.shade200,
          ),
        ),
        Expanded(
          child: _ColorPreview(
            label: '300',
            labelColor: colorScale.shade900,
            color: colorScale.shade300,
          ),
        ),
        Expanded(
          child: _ColorPreview(
            label: '400',
            labelColor: colorScale.shade50,
            color: colorScale.shade400,
          ),
        ),
        Expanded(
          child: _ColorPreview(
            label: '500',
            labelColor: colorScale.shade50,
            color: colorScale.shade500,
          ),
        ),
        Expanded(
          child: _ColorPreview(
            label: '600',
            labelColor: colorScale.shade50,
            color: colorScale.shade600,
          ),
        ),
        Expanded(
          child: _ColorPreview(
            label: '700',
            labelColor: colorScale.shade50,
            color: colorScale.shade700,
          ),
        ),
        Expanded(
          child: _ColorPreview(
            label: '800',
            labelColor: colorScale.shade50,
            color: colorScale.shade800,
          ),
        ),
        Expanded(
          child: _ColorPreview(
            label: '900',
            labelColor: colorScale.shade50,
            color: colorScale.shade900,
          ),
        ),
        Expanded(
          child: _ColorPreview(
            label: '950',
            labelColor: colorScale.shade50,
            color: colorScale.shade950,
          ),
        ),
      ],
    );
  }
}

class _ColorPreview extends StatelessWidget {
  const _ColorPreview({
    required this.label,
    required this.labelColor,
    required this.color,
  });

  final String label;
  final Color labelColor;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: color,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            label,
            maxLines: 1,
            style: TextStyle(
              color: labelColor,
              overflow: TextOverflow.clip,
            ),
          ),
        ),
      ),
    );
  }
}
