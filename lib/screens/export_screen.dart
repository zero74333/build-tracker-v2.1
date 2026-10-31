import 'package:flutter/material.dart';

import '../data/export_service.dart';

class ExportScreen extends StatelessWidget {
  const ExportScreen({super.key});

  Future<void> _run(BuildContext context, Future<void> Function() action) async {
    try {
      await action();
    } catch (error) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Operation failed: $error')),
      );
    }
  }

  Future<void> _restore(BuildContext context) async {
    try {
      final count = await ExportService.restoreBackup();
      if (!context.mounted || count == 0) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Restored or merged $count day(s).')),
      );
    } catch (error) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Restore failed: $error')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.fromLTRB(18, 16, 18, 26),
        children: [
          Text('YOUR DATA', style: theme.textTheme.labelSmall?.copyWith(letterSpacing: 1.8, color: theme.colorScheme.tertiary)),
          Text('Export & backup', style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w700)),
          const SizedBox(height: 7),
          Text('Your records stay on this device unless you choose to share or back them up.', style: theme.textTheme.bodySmall),
          const SizedBox(height: 18),
          _ExportCard(
            icon: Icons.article_outlined,
            title: 'Markdown export',
            description: 'Create a readable .md journal with each date and section.',
            buttonLabel: 'Share Markdown file',
            onPressed: () => _run(context, ExportService.shareMarkdown),
          ),
          const SizedBox(height: 11),
          _ExportCard(
            icon: Icons.data_object_rounded,
            title: 'JSON backup',
            description: 'Create a complete backup that can be restored on this device or another device.',
            buttonLabel: 'Share JSON backup',
            onPressed: () => _run(context, ExportService.shareBackup),
          ),
          const SizedBox(height: 11),
          _ExportCard(
            icon: Icons.settings_backup_restore_rounded,
            title: 'Restore backup',
            description: 'Choose a previously exported .json file. Existing dates are merged; imported values replace matching fields.',
            buttonLabel: 'Choose backup file',
            onPressed: () => _restore(context),
          ),
          const SizedBox(height: 18),
          Card(
            color: theme.colorScheme.surfaceContainerHigh,
            child: const Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Privacy and storage', style: TextStyle(fontWeight: FontWeight.w700)),
                  SizedBox(height: 7),
                  Text('The app works offline and stores daily records in a local SQLite database. There is no automatic cloud sync. Keep a backup somewhere safe because uninstalling the app or losing the phone can remove local data.'),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ExportCard extends StatelessWidget {
  const _ExportCard({
    required this.icon,
    required this.title,
    required this.description,
    required this.buttonLabel,
    required this.onPressed,
  });

  final IconData icon;
  final String title;
  final String description;
  final String buttonLabel;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: theme.colorScheme.tertiary, size: 25),
                const SizedBox(width: 10),
                Expanded(child: Text(title, style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700))),
              ],
            ),
            const SizedBox(height: 7),
            Text(description, style: theme.textTheme.bodySmall),
            const SizedBox(height: 13),
            SizedBox(
              width: double.infinity,
              child: FilledButton.tonal(onPressed: onPressed, child: Text(buttonLabel)),
            ),
          ],
        ),
      ),
    );
  }
}
