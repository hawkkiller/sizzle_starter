import 'package:flutter/material.dart';

class ShowcaseNodePreview extends StatelessWidget {
  ShowcaseNodePreview({
    required this.builder,
    List<Listenable> listenables = const [],
    this.sidebar,
    this.wrapWith,
    super.key,
  }) : listenable = Listenable.merge(listenables);

  final Widget? sidebar;
  final Listenable listenable;
  final WidgetBuilder builder;
  final Widget Function(Widget child)? wrapWith;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);

    Widget child = ListenableBuilder(
      listenable: listenable,
      builder: (context, child) => builder(context),
    );

    if (wrapWith != null) {
      child = wrapWith!(child);
    }

    if (size.width < 800) {
      return _ComponentPreviewSmall(sidebar: sidebar, child: child);
    }

    return _ComponentPreviewStandard(sidebar: sidebar, child: child);
  }
}

class _ComponentPreviewStandard extends StatelessWidget {
  const _ComponentPreviewStandard({
    required this.child,
    required this.sidebar,
  });

  final Widget child;
  final Widget? sidebar;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      children: [
        Expanded(child: child),
        if (sidebar != null)
          DecoratedBox(
            decoration: BoxDecoration(
              color: theme.colorScheme.surfaceContainer,
              border: Border(
                left: BorderSide(color: theme.colorScheme.outlineVariant),
              ),
            ),
            child: SizedBox(
              width: 200,
              height: double.infinity,
              child: sidebar,
            ),
          ),
      ],
    );
  }
}

class _ComponentPreviewSmall extends StatelessWidget {
  const _ComponentPreviewSmall({
    required this.child,
    required this.sidebar,
  });

  final Widget? sidebar;
  final Widget child;

  void _openSidebar(BuildContext context) {
    showDialog<void>(
      context: context,
      useRootNavigator: false,
      builder: (context) {
        return _SidebarFullscreenDialog(sidebar: sidebar!);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child,
        if (sidebar != null)
          Positioned(
            right: 16,
            bottom: MediaQuery.paddingOf(context).bottom + 16,
            child: FloatingActionButton(
              onPressed: () => _openSidebar(context),
              child: const Icon(Icons.edit_rounded),
            ),
          ),
      ],
    );
  }
}

class _SidebarFullscreenDialog extends StatelessWidget {
  const _SidebarFullscreenDialog({
    required this.sidebar,
  });

  final Widget sidebar;

  @override
  Widget build(BuildContext context) {
    return Dialog.fullscreen(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: const Icon(Icons.close_rounded),
          ),
          Expanded(child: sidebar),
        ],
      ),
    );
  }
}
