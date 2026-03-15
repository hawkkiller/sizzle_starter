# Common UI

`common_ui` is the shared design system package for reusable Flutter UI building blocks.

## Current Inventory

Core components exported by `common_ui`:

- `UiBadge`
- `UiButton`
- `UiCard`
- `UiColorScalePreview`
- `UiDialog`
- `UiFlyout`
- `UiInput`
- `UiLoader`
- `UiMenu`
- `UiPulldownButton`
- `UiScaffold`
- `UiSnackbar`
- `UiSnackbarHost`
- `UiText`

The package also provides theme primitives and design tokens through `UiTheme` and the token exports in `lib/common_ui.dart`.

## Recommended Next Components

These are the next additions recommended for the shared inventory:

- `UiCheckbox`
- `UiRadio`
- `UiSwitch`
- `UiSelect`
- `UiListItem`
- `UiBottomSheet`
- `UiToast`
- `UiSnackbar`

These fill the biggest gaps in the current component set: form controls, selection patterns, reusable row layouts, and a mobile-friendly transient surface.

## Snackbar

The simplest setup is to use `UiScaffold`, which hosts snackbars for the current screen.

```dart
UiScaffold(
  body: MyScreenBody(),
);
```

If you need more control, you can also wrap a subtree with `UiSnackbarHost` directly.

```dart
UiSnackbarHost(
  child: child,
);
```

Then show a snackbar from any descendant context.

```dart
showUiSnackbar(
  context,
  message: 'Saved successfully',
  variant: UiSnackbarVariant.success,
);
```

```dart
showUiSnackbar(
  context,
  message: 'Project archived',
  action: UiSnackbarAction(
    label: 'Undo',
    onPressed: restoreFile,
  ),
);
```
