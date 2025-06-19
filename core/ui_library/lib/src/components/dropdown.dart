import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:ui_library/src/widget/popup/popup.dart';

class UiDropdownItem<T> {
  const UiDropdownItem({
    required this.title,
    required this.value,
    this.leading,
    this.trailing,
  });

  final Widget title;
  final T value;
  final Widget? leading;
  final Widget? trailing;
}

class UiDropdown<T> extends StatefulWidget {
  const UiDropdown({
    required this.items,
    required this.onChanged,
    required this.selectedValue,
    this.enforceTargetWidth = false,
    super.key,
  });

  final List<UiDropdownItem<T>> items;
  final ValueChanged<T> onChanged;
  final bool enforceTargetWidth;
  final T? selectedValue;

  @override
  State<UiDropdown<T>> createState() => _UiDropdownState<T>();
}

class _UiDropdownState<T> extends State<UiDropdown<T>> {
  final controller = OverlayPortalController();

  void _onTargetPressed() {
    setState(() {
      if (controller.isShowing) {
        controller.hide();
      } else {
        controller.show();
      }
    });
  }

  void _onItemSelected(T value) {
    widget.onChanged(value);
    controller.hide();
  }

  @override
  Widget build(BuildContext context) {
    final selectedItem = widget.items.firstWhereOrNull(
      (item) => item.value == widget.selectedValue,
    );

    return PopupBuilder(
      enforceLeaderWidth: widget.enforceTargetWidth,
      controller: controller,
      followerAnchor: Alignment.topLeft,
      targetAnchor: Alignment.bottomLeft,
      targetBuilder: (context) {
        return _UiDropdownTarget(
          selectedItem: selectedItem,
          onTap: _onTargetPressed,
          isOpen: controller.isShowing,
        );
      },
      followerBuilder: (context) {
        return _UiDropdownFollower(
          items: widget.items,
          onSelected: _onItemSelected,
        );
      },
    );
  }
}

class _UiDropdownTarget<T> extends StatelessWidget {
  const _UiDropdownTarget({
    required this.selectedItem,
    required this.onTap,
    required this.isOpen,
    super.key,
  });

  final UiDropdownItem<T>? selectedItem;
  final VoidCallback onTap;
  final bool isOpen;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          selectedItem?.title ?? const Text('Select'),
          if (isOpen) const Icon(Icons.arrow_drop_up) else const Icon(Icons.arrow_drop_down),
        ],
      ),
    );
  }
}

class _UiDropdownFollower<T> extends StatelessWidget {
  const _UiDropdownFollower({
    required this.items,
    required this.onSelected,
    super.key,
  });

  final List<UiDropdownItem<T>> items;
  final ValueChanged<T> onSelected;

  List<Widget> _buildItems() {
    return items.map(_buildItem).toList();
  }

  Widget _buildItem(UiDropdownItem<T> item) {
    return _UiDropdownItem(item: item, onTap: () => onSelected(item.value));
  }

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(8)),
      child: Column(children: _buildItems()),
    );
  }
}

class _UiDropdownItem<T> extends StatelessWidget {
  const _UiDropdownItem({
    required this.item,
    required this.onTap,
    super.key,
  });

  final UiDropdownItem<T> item;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: item.title,
      leading: item.leading,
      trailing: item.trailing,
      onTap: onTap,
    );
  }
}
