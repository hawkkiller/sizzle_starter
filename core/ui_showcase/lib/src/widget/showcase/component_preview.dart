import 'package:flutter/material.dart';

class ComponentPreview extends StatelessWidget {
  ComponentPreview({
    required this.builder,
    List<Listenable> listenables = const [],
    this.inputs = const [],
    super.key,
  }) : listenable = Listenable.merge(listenables);

  final List<Widget> inputs;
  final Listenable listenable;
  final WidgetBuilder builder;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);

    final child = ListenableBuilder(
      listenable: listenable,
      builder: (context, child) => Center(child: builder(context)),
    );

    if (size.width < 800) {
      return _ComponentPreviewSmall(
        inputs: inputs,
        child: child,
      );
    }

    return _ComponentPreviewStandard(
      inputs: inputs,
      child: child,
    );
  }
}

class _ComponentPreviewSmall extends StatelessWidget {
  const _ComponentPreviewSmall({
    required this.child,
    required this.inputs,
  });

  final List<Widget> inputs;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child,
        if (inputs.isNotEmpty)
          Positioned(
            right: 16,
            bottom: MediaQuery.paddingOf(context).bottom + 16,
            child: FloatingActionButton(
              onPressed: () {},
              child: const Icon(Icons.edit_rounded),
            ),
          ),
      ],
    );
  }
}

class _ComponentPreviewStandard extends StatelessWidget {
  const _ComponentPreviewStandard({
    required this.child,
    required this.inputs,
  });

  final Widget child;
  final List<Widget> inputs;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      children: [
        Expanded(child: child),
        if (inputs.isNotEmpty)
          DecoratedBox(
            decoration: BoxDecoration(
              color: theme.colorScheme.surfaceContainer,
              border: Border(
                left: BorderSide(color: theme.colorScheme.outlineVariant),
              ),
            ),
            child: SizedBox(
              width: 200,
              child: ListView(
                padding: const EdgeInsets.all(8),
                children: inputs,
              ),
            ),
          ),
      ],
    );
  }
}
