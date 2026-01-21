import 'package:app/core/theme/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// Theme Preview Page - Visual demonstration of the Aurora theme
class ThemePreviewPage extends ConsumerWidget {
  const ThemePreviewPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Aurora Theme Preview'),
        actions: [
          IconButton(
            icon: Icon(
              theme.brightness == Brightness.light
                  ? Icons.dark_mode
                  : Icons.light_mode,
            ),
            onPressed: () {
              ref.read(themeModeProvider.notifier).toggle(theme.brightness);
            },
            tooltip: 'Toggle theme',
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1200),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  Text('🎨 Aurora Theme', style: theme.textTheme.displaySmall),
                  const SizedBox(height: 8),
                  Text(
                    'Elegant yet fun - Deep, rich tones with vibrant accents',
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: cs.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Color Palette Section
                  _ColorPaletteSection(),
                  const SizedBox(height: 32),

                  // Components Section
                  Text('UI Components', style: theme.textTheme.headlineMedium),
                  const SizedBox(height: 16),

                  // Buttons
                  _buildSection(
                    context,
                    'Buttons',
                    Wrap(
                      spacing: 12,
                      runSpacing: 12,
                      children: [
                        ElevatedButton(
                          onPressed: () {},
                          child: const Text('Primary Button'),
                        ),
                        ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            backgroundColor: cs.secondary,
                          ),
                          child: const Text('Secondary Button'),
                        ),
                        ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            backgroundColor: cs.tertiary,
                          ),
                          child: const Text('Tertiary Button'),
                        ),
                        OutlinedButton(
                          onPressed: () {},
                          child: const Text('Outlined Button'),
                        ),
                        TextButton(
                          onPressed: () {},
                          child: const Text('Text Button'),
                        ),
                      ],
                    ),
                  ),

                  // Cards
                  _buildSection(
                    context,
                    'Cards',
                    Wrap(
                      spacing: 16,
                      runSpacing: 16,
                      children: [
                        _sampleProjectCard(
                          context,
                          'Active Project',
                          cs.primary,
                        ),
                        _sampleProjectCard(
                          context,
                          'In Progress',
                          cs.secondary,
                        ),
                        _sampleProjectCard(context, 'Completed', cs.tertiary),
                      ],
                    ),
                  ),

                  // Chips
                  _buildSection(
                    context,
                    'Chips & Tags',
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        const Chip(
                          label: Text('Default'),
                          avatar: Icon(Icons.label, size: 16),
                        ),
                        Chip(
                          label: const Text('Primary'),
                          backgroundColor: cs.primaryContainer,
                          labelStyle: TextStyle(color: cs.primary),
                        ),
                        Chip(
                          label: const Text('Secondary'),
                          backgroundColor: cs.secondaryContainer,
                          labelStyle: TextStyle(color: cs.secondary),
                        ),
                        Chip(
                          label: const Text('Tertiary'),
                          backgroundColor: cs.tertiaryContainer,
                          labelStyle: TextStyle(color: cs.tertiary),
                        ),
                        Chip(
                          label: const Text('Error'),
                          backgroundColor: cs.errorContainer,
                          labelStyle: TextStyle(color: cs.error),
                        ),
                      ],
                    ),
                  ),

                  // Input Fields
                  _buildSection(
                    context,
                    'Input Fields',
                    Column(
                      children: [
                        const TextField(
                          decoration: InputDecoration(
                            labelText: 'Project Name',
                            hintText: 'Enter project name',
                            prefixIcon: Icon(Icons.folder),
                          ),
                        ),
                        const SizedBox(height: 16),
                        TextField(
                          decoration: InputDecoration(
                            labelText: 'Description',
                            hintText: 'Enter description',
                            prefixIcon: const Icon(Icons.description),
                            suffixIcon: IconButton(
                              icon: const Icon(Icons.clear),
                              onPressed: () {},
                            ),
                          ),
                          maxLines: 3,
                        ),
                        const SizedBox(height: 16),
                        const TextField(
                          decoration: InputDecoration(
                            labelText: 'Budget',
                            hintText: '\$0.00',
                            prefixIcon: Icon(Icons.attach_money),
                            errorText: 'Please enter a valid amount',
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Lists & Tiles
                  _buildSection(
                    context,
                    'List Items',
                    Card(
                      child: Column(
                        children: [
                          ListTile(
                            leading: CircleAvatar(
                              backgroundColor: cs.primaryContainer,
                              child: Icon(Icons.task_alt, color: cs.primary),
                            ),
                            title: const Text('Task Management'),
                            subtitle: const Text('5 tasks remaining'),
                            trailing: Chip(
                              label: const Text('Active'),
                              backgroundColor: cs.primaryContainer,
                              labelStyle: TextStyle(
                                color: cs.primary,
                                fontSize: 12,
                              ),
                            ),
                          ),
                          Divider(
                            height: 1,
                            color: cs.outline.withValues(alpha: 0.2),
                          ),
                          ListTile(
                            leading: CircleAvatar(
                              backgroundColor: cs.secondaryContainer,
                              child: Icon(
                                Icons.design_services,
                                color: cs.secondary,
                              ),
                            ),
                            title: const Text('Design System'),
                            subtitle: const Text('In progress'),
                            trailing: Chip(
                              label: const Text('Review'),
                              backgroundColor: cs.secondaryContainer,
                              labelStyle: TextStyle(
                                color: cs.secondary,
                                fontSize: 12,
                              ),
                            ),
                          ),
                          Divider(
                            height: 1,
                            color: cs.outline.withValues(alpha: 0.2),
                          ),
                          ListTile(
                            leading: CircleAvatar(
                              backgroundColor: cs.tertiaryContainer,
                              child: Icon(Icons.code, color: cs.tertiary),
                            ),
                            title: const Text('API Integration'),
                            subtitle: const Text('Ready to deploy'),
                            trailing: Chip(
                              label: const Text('Done'),
                              backgroundColor: cs.tertiaryContainer,
                              labelStyle: TextStyle(
                                color: cs.tertiary,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Typography
                  _buildSection(
                    context,
                    'Typography',
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Display Large',
                          style: theme.textTheme.displayLarge,
                        ),
                        Text(
                          'Headline Medium',
                          style: theme.textTheme.headlineMedium,
                        ),
                        Text('Title Large', style: theme.textTheme.titleLarge),
                        Text(
                          'Body Large - Regular text for reading',
                          style: theme.textTheme.bodyLarge,
                        ),
                        Text(
                          'Body Medium - Secondary text',
                          style: theme.textTheme.bodyMedium,
                        ),
                        Text(
                          'Label Small - Caption text',
                          style: theme.textTheme.labelSmall,
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSection(BuildContext context, String title, Widget content) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 24),
        Text(title, style: theme.textTheme.titleLarge),
        const SizedBox(height: 12),
        content,
      ],
    );
  }

  Widget _sampleProjectCard(
    BuildContext context,
    String title,
    Color statusColor,
  ) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return SizedBox(
      width: 340,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 12,
                    height: 12,
                    decoration: BoxDecoration(
                      color: statusColor,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(title, style: theme.textTheme.titleMedium),
                  ),
                  Icon(Icons.more_vert, color: cs.onSurfaceVariant, size: 20),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                'A sample project card showcasing the Aurora theme colors and styling.',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: cs.onSurfaceVariant,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Icon(
                    Icons.calendar_today,
                    size: 14,
                    color: cs.onSurfaceVariant,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    'Jan 16, 2026',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: cs.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Icon(
                    Icons.attach_money,
                    size: 14,
                    color: cs.onSurfaceVariant,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '25,000',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: cs.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 6,
                runSpacing: 6,
                children: [
                  Chip(
                    label: const Text('Design'),
                    backgroundColor: cs.primaryContainer,
                    labelStyle: TextStyle(
                      color: cs.primary,
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 2,
                    ),
                  ),
                  Chip(
                    label: const Text('Frontend'),
                    backgroundColor: cs.secondaryContainer,
                    labelStyle: TextStyle(
                      color: cs.secondary,
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 2,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ColorPaletteSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Color Palette', style: theme.textTheme.headlineMedium),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _colorSwatch(context, 'Primary', cs.primary, cs.onPrimary),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _colorSwatch(
                context,
                'Secondary',
                cs.secondary,
                cs.onSecondary,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _colorSwatch(
                context,
                'Tertiary',
                cs.tertiary,
                cs.onTertiary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _colorSwatch(context, 'Surface', cs.surface, cs.onSurface),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _colorSwatch(
                context,
                'Background',
                cs.background,
                cs.onBackground,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _colorSwatch(context, 'Error', cs.error, cs.onError),
            ),
          ],
        ),
      ],
    );
  }

  Widget _colorSwatch(
    BuildContext context,
    String label,
    Color color,
    Color onColor,
  ) {
    final theme = Theme.of(context);
    return Container(
      height: 100,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: theme.colorScheme.outline.withValues(alpha: 0.2),
        ),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              label,
              style: theme.textTheme.titleSmall?.copyWith(color: onColor),
            ),
            const SizedBox(height: 4),
            Text(
              '#${color.value.toRadixString(16).substring(2).toUpperCase()}',
              style: theme.textTheme.bodySmall?.copyWith(
                color: onColor.withValues(alpha: 0.7),
                fontFamily: 'monospace',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
