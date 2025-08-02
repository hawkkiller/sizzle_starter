import 'package:flutter/material.dart';
import 'package:ui_showcase/ui_showcase.dart';

class ActiveNodeMetadata extends StatelessWidget {
  const ActiveNodeMetadata({required this.node});

  final ShowcaseNode node;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Breadcrumbs(node: node),
          if (node.description case final description?) Text(description),
        ],
      ),
    );
  }
}

class Breadcrumbs extends StatelessWidget {
  const Breadcrumbs({
    required this.node,
  });

  final ShowcaseNode node;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    final textStyle = textTheme.bodyMedium?.copyWith(color: colorScheme.secondary);

    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        for (final parent in node.getBreadcrumbs()) ...[
          Text(parent.path, style: textStyle),
          if (parent != node) Text('/', style: textStyle),
        ],
      ],
    );
  }
}
