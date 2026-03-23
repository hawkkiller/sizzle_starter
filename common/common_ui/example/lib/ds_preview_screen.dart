import 'package:common_ui/common_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class DsPreviewScreen extends StatelessWidget {
  const DsPreviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = UiTheme.of(context);

    return UiScaffold(
      backgroundColor: theme.color.background,
      body: SafeArea(
        bottom: false,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            const _PreviewHero(),
            SizedBox(height: theme.spacing.s16),
            const _ButtonsSection(),
            SizedBox(height: theme.spacing.s12),
            const _OverlaysSection(),
            SizedBox(height: theme.spacing.s12),
            const _FeedbackSection(),
            SizedBox(height: theme.spacing.s12),
            const _BadgesSection(),
            SizedBox(height: theme.spacing.s12),
            const _FormsSection(),
            SizedBox(height: theme.spacing.s12),
            const _ListItemsSection(),
            SizedBox(height: theme.spacing.s12),
            const _SurfacesSection(),
            SizedBox(height: theme.spacing.s12),
            const _LoadingSection(),
          ],
        ),
      ),
    );
  }
}

class _PreviewHero extends StatelessWidget {
  const _PreviewHero();

  @override
  Widget build(BuildContext context) {
    final theme = UiTheme.of(context);

    return UiCard(
      color: theme.color.surfaceRaised,
      padding: EdgeInsets.all(theme.spacing.s16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          UiText.titleLarge('Common UI Preview', color: theme.color.onSurface),
          SizedBox(height: theme.spacing.s8),
          UiText.bodyMedium(
            'A quick overview of the shared UI components.',
            color: theme.color.onSurfaceMuted,
            overflow: TextOverflow.visible,
          ),
        ],
      ),
    );
  }
}

class _PreviewSection extends StatelessWidget {
  const _PreviewSection({required this.title, required this.child, this.description});

  final String title;
  final String? description;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final theme = UiTheme.of(context);

    return UiCard(
      color: theme.color.surfaceRaised,
      padding: EdgeInsets.all(theme.spacing.s16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          UiText.titleMedium(title, color: theme.color.onSurface),
          if (description != null) ...[
            SizedBox(height: theme.spacing.s4),
            UiText.bodyMedium(
              description!,
              color: theme.color.onSurfaceMuted,
              overflow: TextOverflow.visible,
            ),
          ],
          SizedBox(height: theme.spacing.s16),
          child,
        ],
      ),
    );
  }
}

class _SectionCaption extends StatelessWidget {
  const _SectionCaption(this.label);

  final String label;

  @override
  Widget build(BuildContext context) {
    return UiText.labelLarge(label, color: UiTheme.of(context).color.onSurfaceMuted);
  }
}

class _ButtonsSection extends StatefulWidget {
  const _ButtonsSection();

  @override
  State<_ButtonsSection> createState() => _ButtonsSectionState();
}

class _ButtonsSectionState extends State<_ButtonsSection> {
  UiButtonRole _role = UiButtonRole.normal;
  var _enabled = true;

  @override
  Widget build(BuildContext context) {
    final theme = UiTheme.of(context);

    return _PreviewSection(
      title: 'Buttons',
      description: 'Text and icon-only action buttons.',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _SectionCaption('Role'),
          SizedBox(height: theme.spacing.s8),
          Wrap(
            spacing: theme.spacing.s8,
            runSpacing: theme.spacing.s8,
            children: [
              _PreviewOptionButton(
                label: 'Normal',
                selected: _role == UiButtonRole.normal,
                onPressed: () => setState(() => _role = UiButtonRole.normal),
              ),
              _PreviewOptionButton(
                label: 'Destructive',
                selected: _role == UiButtonRole.destructive,
                role: UiButtonRole.destructive,
                onPressed: () => setState(() => _role = UiButtonRole.destructive),
              ),
            ],
          ),
          SizedBox(height: theme.spacing.s12),
          const _SectionCaption('State'),
          SizedBox(height: theme.spacing.s8),
          Wrap(
            spacing: theme.spacing.s8,
            runSpacing: theme.spacing.s8,
            children: [
              _PreviewOptionButton(
                label: 'Enabled',
                selected: _enabled,
                onPressed: () => setState(() => _enabled = true),
              ),
              _PreviewOptionButton(
                label: 'Disabled',
                selected: !_enabled,
                onPressed: () => setState(() => _enabled = false),
              ),
            ],
          ),
          SizedBox(height: theme.spacing.s16),
          const _SectionCaption('Text buttons'),
          SizedBox(height: theme.spacing.s8),
          _ButtonsRow(role: _role, enabled: _enabled),
          SizedBox(height: theme.spacing.s16),
          const _SectionCaption('Icon buttons'),
          SizedBox(height: theme.spacing.s8),
          _IconButtonsRow(role: _role, enabled: _enabled),
        ],
      ),
    );
  }
}

class _PreviewOptionButton extends StatelessWidget {
  const _PreviewOptionButton({
    required this.label,
    required this.selected,
    required this.onPressed,
    this.role = UiButtonRole.normal,
  });

  final String label;
  final bool selected;
  final VoidCallback onPressed;
  final UiButtonRole role;

  @override
  Widget build(BuildContext context) {
    return UiButton(
      label: label,
      role: role,
      style: selected ? UiButtonStyle.primary : UiButtonStyle.secondary,
      onPressed: onPressed,
    );
  }
}

class _ButtonsRow extends StatelessWidget {
  const _ButtonsRow({required this.role, required this.enabled});

  final UiButtonRole role;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final theme = UiTheme.of(context);

    return Wrap(
      spacing: theme.spacing.s12,
      runSpacing: theme.spacing.s12,
      children: [
        UiButton(label: 'Primary', onPressed: () {}, enabled: enabled, role: role),
        UiButton(
          label: 'Secondary',
          onPressed: () {},
          style: UiButtonStyle.secondary,
          enabled: enabled,
          role: role,
        ),
        UiButton(
          label: 'Outline',
          onPressed: () {},
          style: UiButtonStyle.outline,
          enabled: enabled,
          role: role,
        ),
        UiButton(
          label: 'Ghost',
          onPressed: () {},
          style: UiButtonStyle.ghost,
          enabled: enabled,
          role: role,
        ),
      ],
    );
  }
}

class _IconButtonsRow extends StatelessWidget {
  const _IconButtonsRow({required this.role, required this.enabled});

  final UiButtonRole role;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final theme = UiTheme.of(context);

    return Wrap(
      spacing: theme.spacing.s12,
      runSpacing: theme.spacing.s12,
      children: [
        UiButton.iconOnly(
          label: 'Primary',
          icon: const Icon(Icons.add),
          onPressed: () {},
          enabled: enabled,
          role: role,
        ),
        UiButton.iconOnly(
          label: 'Secondary',
          icon: const Icon(Icons.add),
          style: UiButtonStyle.secondary,
          onPressed: () {},
          enabled: enabled,
          role: role,
        ),
        UiButton.iconOnly(
          label: 'Outline',
          icon: const Icon(Icons.add),
          style: UiButtonStyle.outline,
          onPressed: () {},
          enabled: enabled,
          role: role,
        ),
        UiButton.iconOnly(
          label: 'Ghost',
          icon: const Icon(Icons.add),
          style: UiButtonStyle.ghost,
          onPressed: () {},
          enabled: enabled,
          role: role,
        ),
      ],
    );
  }
}

class _OverlaysSection extends StatelessWidget {
  const _OverlaysSection();

  @override
  Widget build(BuildContext context) {
    final theme = UiTheme.of(context);

    return _PreviewSection(
      title: 'Overlays',
      description: 'Menus and dialogs for secondary actions.',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _SectionCaption('Pulldown'),
          SizedBox(height: theme.spacing.s8),
          const PulldownPreview(),
          SizedBox(height: theme.spacing.s16),
          const _SectionCaption('Dialog'),
          SizedBox(height: theme.spacing.s8),
          const DialogPreview(),
        ],
      ),
    );
  }
}

class _FeedbackSection extends StatelessWidget {
  const _FeedbackSection();

  @override
  Widget build(BuildContext context) {
    return const _PreviewSection(
      title: 'Feedback',
      description: 'Snackbars for neutral and semantic states.',
      child: SnackbarPreview(),
    );
  }
}

class _BadgesSection extends StatelessWidget {
  const _BadgesSection();

  @override
  Widget build(BuildContext context) {
    final theme = UiTheme.of(context);

    return _PreviewSection(
      title: 'Badges',
      description: 'Status labels in semantic variants.',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _SectionCaption('Compact'),
          SizedBox(height: theme.spacing.s8),
          const BadgesPreview(),
          SizedBox(height: theme.spacing.s16),
          const _SectionCaption('Spacious'),
          SizedBox(height: theme.spacing.s8),
          const BadgesPreview(spacious: true),
        ],
      ),
    );
  }
}

class _FormsSection extends StatelessWidget {
  const _FormsSection();

  @override
  Widget build(BuildContext context) {
    return const _PreviewSection(
      title: 'Inputs',
      description: 'Text fields with default and disabled states.',
      child: InputPreview(),
    );
  }
}

class _SurfacesSection extends StatelessWidget {
  const _SurfacesSection();

  @override
  Widget build(BuildContext context) {
    return const _PreviewSection(
      title: 'Surfaces',
      description: 'Cards for grouped content and values.',
      child: CardPreview(),
    );
  }
}

class _ListItemsSection extends StatelessWidget {
  const _ListItemsSection();

  @override
  Widget build(BuildContext context) {
    return const _PreviewSection(
      title: 'List items',
      description: 'Reusable rows for settings, metadata, and lightweight actions.',
      child: ListItemsPreview(),
    );
  }
}

class _LoadingSection extends StatelessWidget {
  const _LoadingSection();

  @override
  Widget build(BuildContext context) {
    return const _PreviewSection(
      title: 'Loading',
      description: 'Inline loading indicator.',
      child: LoaderPreview(),
    );
  }
}

class BadgesPreview extends StatelessWidget {
  const BadgesPreview({super.key, this.spacious = false});

  final bool spacious;

  @override
  Widget build(BuildContext context) {
    final theme = UiTheme.of(context);

    return Wrap(
      spacing: theme.spacing.s12,
      runSpacing: theme.spacing.s12,
      children: [
        UiBadge(label: 'Info', spacious: spacious),
        UiBadge(label: 'Warning', variant: UiBadgeVariant.warning, spacious: spacious),
        UiBadge(label: 'Error', variant: UiBadgeVariant.error, spacious: spacious),
        UiBadge(label: 'Success', variant: UiBadgeVariant.success, spacious: spacious),
      ],
    );
  }
}

class PulldownPreview extends StatelessWidget {
  const PulldownPreview({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = UiTheme.of(context);

    return Wrap(
      spacing: theme.spacing.s12,
      runSpacing: theme.spacing.s12,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: const [
        UiPulldownButton(content: _PulldownMenuContent()),
        UiPulldownButton(
          label: 'Actions',
          iconOnly: false,
          icon: Icon(Icons.more_vert),
          content: _PulldownMenuContent(),
        ),
      ],
    );
  }
}

class _PulldownMenuContent extends StatelessWidget {
  const _PulldownMenuContent();

  @override
  Widget build(BuildContext context) {
    void hideFlyout() {
      FlyoutScope.of(context, listen: false).controller.hide();
    }

    return UiMenu(
      width: 220,
      children: [
        const UiMenuSectionTitle('Quick actions'),
        UiMenuItem(label: 'Edit', icon: const Icon(Icons.edit_outlined), onPressed: hideFlyout),
        UiMenuItem(
          label: 'Duplicate',
          icon: const Icon(Icons.copy_outlined),
          onPressed: hideFlyout,
        ),
        UiMenuItem(
          label: 'Share',
          icon: const Icon(Icons.ios_share_outlined),
          onPressed: hideFlyout,
        ),
        const UiMenuDivider(),
        UiMenuItem(
          label: 'Delete',
          icon: const Icon(Icons.delete_outline),
          role: UiButtonRole.destructive,
          onPressed: hideFlyout,
        ),
      ],
    );
  }
}

class InputPreview extends StatelessWidget {
  const InputPreview({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = UiTheme.of(context);

    return Align(
      alignment: Alignment.centerLeft,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 320),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const UiInput(
              labelText: 'Label',
              hintText: 'Hint',
              prefixIcon: Icon(Icons.person),
              keyboardType: TextInputType.emailAddress,
            ),
            SizedBox(height: theme.spacing.s12),
            const UiInput(
              labelText: 'Disabled',
              hintText: 'Hint',
              prefixIcon: Icon(Icons.person),
              enabled: false,
              keyboardType: TextInputType.emailAddress,
            ),
          ],
        ),
      ),
    );
  }
}

class DialogPreview extends StatelessWidget {
  const DialogPreview({super.key});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: UiButton(
        label: 'Show dialog',
        onPressed: () {
          showUiDialog<void>(
            context: context,
            builder: (context) => const UiConfirmDialog(
              title: 'Archive project?',
              description:
                  'Archived projects stay available in history, but collaborators lose edit access until you restore them.',
              confirmLabel: 'Archive',
              confirmRole: UiButtonRole.destructive,
            ),
          );
        },
      ),
    );
  }
}

class CardPreview extends StatelessWidget {
  const CardPreview({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = UiTheme.of(context);

    return Align(
      alignment: Alignment.centerLeft,
      child: UiCard(
        width: 180,
        height: 180,
        color: theme.color.surface,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              spacing: theme.spacing.s8,
              children: [
                SizedBox(
                  width: 32,
                  height: 32,
                  child: ClipOval(child: SvgPicture.asset('assets/euflag.svg', fit: BoxFit.cover)),
                ),
                UiText.titleMedium('EUR', color: theme.color.onSurfaceMuted),
              ],
            ),
            const Spacer(),
            Row(
              mainAxisSize: MainAxisSize.min,
              spacing: theme.spacing.s4,
              children: [
                Icon(Icons.account_balance_wallet, size: 16, color: theme.color.onSurfaceMuted),
                UiText.bodyMedium('**61305', color: theme.color.onSurfaceMuted),
              ],
            ),
            SizedBox(height: theme.spacing.s4),
            UiText.titleLarge('1,000.00', color: theme.color.onSurface),
          ],
        ),
      ),
    );
  }
}

class ListItemsPreview extends StatelessWidget {
  const ListItemsPreview({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = UiTheme.of(context);

    return Align(
      alignment: Alignment.centerLeft,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 360),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            UiListItem(
              title: 'Personal account',
              subtitle: 'Signed in with mykhailo@example.com',
              leading: const Icon(Icons.person_outline),
              trailing: const Icon(Icons.chevron_right),
              onPressed: () {},
            ),
            SizedBox(height: theme.spacing.s8),
            UiListItem(
              title: 'Notifications',
              subtitle: 'Push, email, and product updates',
              leading: const Icon(Icons.notifications_outlined),
              trailing: Text('Enabled', style: theme.typography.labelLarge),
              selected: true,
              onPressed: () {},
            ),
            SizedBox(height: theme.spacing.s8),
            const UiListItem(
              title: 'Workspace storage',
              subtitle: '128 GB used of 256 GB',
              leading: Icon(Icons.storage_outlined),
              trailing: Icon(Icons.chevron_right),
            ),
            SizedBox(height: theme.spacing.s8),
            const UiListItem(
              title: 'Two-factor authentication',
              subtitle: 'Required for all team members',
              leading: Icon(Icons.lock_outline),
              trailing: Icon(Icons.chevron_right),
              enabled: false,
            ),
          ],
        ),
      ),
    );
  }
}

class LoaderPreview extends StatelessWidget {
  const LoaderPreview({super.key});

  @override
  Widget build(BuildContext context) {
    return const Align(alignment: Alignment.centerLeft, child: UiLoader());
  }
}

class SnackbarPreview extends StatelessWidget {
  const SnackbarPreview({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = UiTheme.of(context);

    return Wrap(
      spacing: theme.spacing.s12,
      runSpacing: theme.spacing.s12,
      children: [
        UiButton(
          label: 'Neutral',
          style: UiButtonStyle.secondary,
          onPressed: () {
            showUiSnackbar(
              context,
              message: 'Changes are ready to review',
              action: UiSnackbarAction(label: 'Open', onPressed: () {}),
            );
          },
        ),
        UiButton(
          label: 'Success',
          style: UiButtonStyle.secondary,
          onPressed: () {
            showUiSnackbar(
              context,
              message: 'Saved successfully',
              variant: UiSnackbarVariant.success,
              action: UiSnackbarAction(label: 'View', onPressed: () {}),
            );
          },
        ),
        UiButton(
          label: 'Warning',
          style: UiButtonStyle.secondary,
          onPressed: () {
            showUiSnackbar(
              context,
              message: 'Storage is almost full',
              variant: UiSnackbarVariant.warning,
              action: UiSnackbarAction(label: 'Manage', onPressed: () {}),
            );
          },
        ),
        UiButton(
          label: 'Error',
          style: UiButtonStyle.secondary,
          role: UiButtonRole.destructive,
          onPressed: () {
            showUiSnackbar(
              context,
              message: 'Could not save changes',
              variant: UiSnackbarVariant.error,
              action: UiSnackbarAction(label: 'Retry', onPressed: () {}),
            );
          },
        ),
      ],
    );
  }
}
