import 'dart:async';

import 'package:flutter/material.dart';

import '../data/database.dart';
import '../data/fields.dart';
import 'field_input.dart';

class SectionScreen extends StatefulWidget {
  const SectionScreen({
    super.key,
    required this.module,
    required this.date,
  });

  final ModuleDef module;
  final String date;

  @override
  State<SectionScreen> createState() => _SectionScreenState();
}

class _SectionScreenState extends State<SectionScreen> {
  Map<String, dynamic> _data = {};
  bool _loading = true;
  String? _loadError;
  bool _saving = false;
  bool _dirty = false;
  int _revision = 0;
  int _savedRevision = 0;
  Timer? _saveTimer;
  Completer<void>? _saveCompleter;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _loadError = null;
    });
    try {
      final data = await TrackerDb.load(widget.date);
      if (!mounted) return;
      setState(() {
        _data = data;
        _loading = false;
      });
    } catch (error) {
      if (!mounted) return;
      setState(() {
        _loading = false;
        _loadError = error.toString();
      });
    }
  }

  @override
  void dispose() {
    _saveTimer?.cancel();
    if (_dirty) {
      unawaited(_persistPendingChanges());
    }
    super.dispose();
  }

  Future<void> _persistPendingChanges() async {
    try {
      await _saveCompleter?.future;
      await TrackerDb.save(widget.date, Map<String, dynamic>.from(_data));
    } catch (_) {
      // The screen is already disposed; there is no UI left to report this error.
    }
  }

  void _changed() {
    _revision++;
    setState(() => _dirty = true);
    _saveTimer?.cancel();
    _saveTimer = Timer(const Duration(milliseconds: 850), _saveNow);
  }

  Future<void> _saveNow() async {
    _saveTimer?.cancel();
    if (_saving) {
      await _saveCompleter?.future;
      if (_dirty) await _saveNow();
      return;
    }
    if (!_dirty) return;

    final revisionAtStart = _revision;
    final snapshot = Map<String, dynamic>.from(_data);
    final completion = Completer<void>();
    _saveCompleter = completion;
    setState(() => _saving = true);
    var succeeded = false;
    try {
      await TrackerDb.save(widget.date, snapshot);
      succeeded = true;
      if (!mounted) return;
      _savedRevision = revisionAtStart;
      setState(() {
        _saving = false;
        _dirty = _revision != _savedRevision;
      });
    } catch (error) {
      if (mounted) {
        setState(() => _saving = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Could not save: $error')),
        );
      }
    } finally {
      if (!completion.isCompleted) completion.complete();
      if (identical(_saveCompleter, completion)) _saveCompleter = null;
    }
    if (succeeded && mounted && _dirty) {
      await _saveNow();
    }
  }

  Future<void> _editEntry(GroupDef group, {int? index}) async {
    final key = repeatStorageKey(group);
    final raw = _data[key];
    final entries = _entryMaps(raw);
    final initial = index == null
        ? <String, dynamic>{}
        : Map<String, dynamic>.from(entries[index]);

    final result = await showDialog<Map<String, dynamic>>(
      context: context,
      builder: (_) => EntryEditorDialog(
        title: index == null ? 'Add entry to ${group.title}' : 'Edit entry in ${group.title}',
        group: group,
        initial: initial,
      ),
    );
    if (result == null || !mounted) return;

    if (index == null) {
      entries.add(result);
    } else {
      entries[index] = result;
    }
    _data[key] = entries;
    _changed();
  }

  Future<void> _deleteEntry(GroupDef group, int index) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete entry?'),
        content: const Text('This entry will be removed from this day.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancel')),
          FilledButton(onPressed: () => Navigator.pop(context, true), child: const Text('Delete')),
        ],
      ),
    );
    if (confirmed != true || !mounted) return;
    final key = repeatStorageKey(group);
    final raw = _data[key];
    final entries = _entryMaps(raw);
    if (index < 0 || index >= entries.length) return;
    entries.removeAt(index);
    _data[key] = entries;
    _changed();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (_loading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (_loadError != null) {
      return Scaffold(
        appBar: AppBar(title: Text(widget.module.title)),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(28),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.storage_rounded,
                  size: 42,
                  color: theme.colorScheme.error,
                ),
                const SizedBox(height: 12),
                Text('Could not load this section', style: theme.textTheme.titleMedium),
                const SizedBox(height: 6),
                Text(
                  _loadError!,
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodySmall,
                ),
                const SizedBox(height: 16),
                FilledButton.icon(
                  onPressed: _load,
                  icon: const Icon(Icons.refresh_rounded),
                  label: const Text('Try again'),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return PopScope<void>(
      canPop: !_dirty,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;
        await _saveNow();
        if (mounted && !_dirty) Navigator.of(context).pop();
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.module.title),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 16),
              child: Center(
                child: _SaveStateLabel(
                  saving: _saving,
                  dirty: _dirty,
                ),
              ),
            ),
          ],
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 4, 16, 12),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(13),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surfaceContainerLow,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: theme.colorScheme.outlineVariant),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      width: 42,
                      height: 42,
                      decoration: BoxDecoration(
                        color: widget.module.tint.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(13),
                      ),
                      child: Icon(widget.module.icon, color: widget.module.tint),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.date,
                            style: theme.textTheme.labelLarge?.copyWith(
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            widget.module.subtitle,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            if (widget.module.id == 'health')
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 10),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.tertiaryContainer.withValues(alpha: 0.30),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: theme.colorScheme.tertiary.withValues(alpha: 0.25),
                    ),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.info_outline_rounded,
                        size: 19,
                        color: theme.colorScheme.tertiary,
                      ),
                      const SizedBox(width: 9),
                      Expanded(
                        child: Text(
                          'Use this space to notice patterns, not to diagnose. Chest pain, breathing difficulty, fainting, severe sudden headache, severe or worsening abdominal pain, repeated vomiting, or blood / black stool may need prompt medical assessment.',
                          style: theme.textTheme.bodySmall,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            Expanded(
              child: ListView.builder(
                keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
                padding: const EdgeInsets.fromLTRB(12, 0, 12, 18),
                itemCount: widget.module.groups.length,
                itemBuilder: (context, index) {
                  final group = widget.module.groups[index];
                  return _buildGroup(group, index);
                },
              ),
            ),
            SafeArea(
              top: false,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
                decoration: BoxDecoration(
                  color: theme.scaffoldBackgroundColor,
                  border: Border(
                    top: BorderSide(color: theme.colorScheme.outlineVariant),
                  ),
                ),
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 180),
                  child: _dirty || _saving
                      ? SizedBox(
                          key: const ValueKey('save-action'),
                          width: double.infinity,
                          child: FilledButton.icon(
                            onPressed: _saving ? null : _saveNow,
                            icon: _saving
                                ? const SizedBox(
                                    width: 17,
                                    height: 17,
                                    child: CircularProgressIndicator(strokeWidth: 2),
                                  )
                                : const Icon(Icons.save_rounded),
                            label: Text(_saving ? 'Saving changes…' : 'Save changes'),
                          ),
                        )
                      : Container(
                          key: const ValueKey('saved-status'),
                          padding: const EdgeInsets.symmetric(vertical: 9),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.check_circle_outline_rounded,
                                size: 18,
                                color: theme.colorScheme.tertiary,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'All changes saved automatically',
                                style: theme.textTheme.labelLarge?.copyWith(
                                  color: theme.colorScheme.onSurfaceVariant,
                                ),
                              ),
                            ],
                          ),
                        ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGroup(GroupDef group, int index) {
    final theme = Theme.of(context);
    final progress = _groupProgress(group);
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6),
      color: theme.colorScheme.surfaceContainerLow,
      elevation: 0,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
        side: BorderSide(color: theme.colorScheme.outlineVariant),
      ),
      child: ExpansionTile(
        key: PageStorageKey('${widget.module.id}.${group.id}'),
        initiallyExpanded: index == 0,
        tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 7),
        childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 18),
        expandedCrossAxisAlignment: CrossAxisAlignment.start,
        title: Text(
          group.title,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 3),
          child: Text(
            progress,
            style: theme.textTheme.labelMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ),
        children: [
          if (group.description != null) ...[
            Container(
              width: double.infinity,
              margin: const EdgeInsets.only(bottom: 14),
              padding: const EdgeInsets.all(11),
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceContainerHigh,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                group.description!,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ),
          ],
          if (group.repeatable)
            _buildRepeater(group)
          else
            for (var fieldIndex = 0; fieldIndex < group.fields.length; fieldIndex++) ...[
              FieldInput(
                key: ValueKey('${group.storageKey}.${group.fields[fieldIndex].key}'),
                field: group.fields[fieldIndex],
                value: _data[fieldStorageKey(group, group.fields[fieldIndex])],
                onChanged: (value) {
                  _data[fieldStorageKey(group, group.fields[fieldIndex])] = value;
                  _changed();
                },
              ),
              if (fieldIndex != group.fields.length - 1)
                const SizedBox(height: 13),
            ],
        ],
      ),
    );
  }

  String _groupProgress(GroupDef group) {
    if (group.repeatable) {
      final raw = _data[repeatStorageKey(group)];
      final count = raw is List ? raw.length : 0;
      return '$count ${count == 1 ? 'entry' : 'entries'}';
    }
    final filled = group.fields.where((field) {
      final value = _data[fieldStorageKey(group, field)];
      if (value == null || value == '') return false;
      if (value is List) return value.isNotEmpty;
      return true;
    }).length;
    return '$filled of ${group.fields.length} fields filled';
  }

  Widget _buildRepeater(GroupDef group) {
    final raw = _data[repeatStorageKey(group)];
    final entries = _entryMaps(raw);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (entries.isEmpty)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 18),
            margin: const EdgeInsets.only(bottom: 10),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surfaceContainerHigh,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Column(
              children: [
                Icon(
                  Icons.inbox_outlined,
                  size: 25,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
                const SizedBox(height: 7),
                Text(
                  'No entries yet',
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                const SizedBox(height: 3),
                Text(
                  'Add your first entry when you have something to record.',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ),
        for (var index = 0; index < entries.length; index++)
          Card(
            color: Theme.of(context).colorScheme.surfaceContainerLow,
            child: ListTile(
              title: Text(
                _entryTitle(group, entries[index], index),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              subtitle: Text(
                _entrySubtitle(group, entries[index]),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              leading: CircleAvatar(
                radius: 16,
                child: Text('${index + 1}', style: Theme.of(context).textTheme.labelMedium),
              ),
              onTap: () => _editEntry(group, index: index),
              trailing: PopupMenuButton<String>(
                onSelected: (action) {
                  if (action == 'edit') _editEntry(group, index: index);
                  if (action == 'delete') _deleteEntry(group, index);
                },
                itemBuilder: (_) => const [
                  PopupMenuItem(value: 'edit', child: Text('Edit')),
                  PopupMenuItem(value: 'delete', child: Text('Delete')),
                ],
              ),
            ),
          ),
        const SizedBox(height: 8),
        Align(
          alignment: Alignment.centerLeft,
          child: OutlinedButton.icon(
            onPressed: () => _editEntry(group),
            icon: const Icon(Icons.add),
            label: const Text('Add entry'),
          ),
        ),
      ],
    );
  }

  List<Map<String, dynamic>> _entryMaps(dynamic raw) {
    if (raw is! List) return <Map<String, dynamic>>[];
    return raw
        .whereType<Map>()
        .map((item) => Map<String, dynamic>.from(item))
        .toList();
  }

  String _entryTitle(GroupDef group, Map<String, dynamic> entry, int index) {
    for (final field in group.fields) {
      final value = entry[field.key];
      if (value != null && value.toString().trim().isNotEmpty && value != false) {
        return value.toString().split('\n').first;
      }
    }
    return 'Entry ${index + 1}';
  }

  String _entrySubtitle(GroupDef group, Map<String, dynamic> entry) {
    final parts = <String>[];
    for (final field in group.fields.skip(1)) {
      final value = entry[field.key];
      if (value == null || value == '' || value == false) continue;
      parts.add(value is List ? value.join(', ') : value.toString());
      if (parts.length == 2) break;
    }
    return parts.join(' · ');
  }

}

class _SaveStateLabel extends StatelessWidget {
  const _SaveStateLabel({required this.saving, required this.dirty});

  final bool saving;
  final bool dirty;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final label = saving ? 'Saving' : (dirty ? 'Unsaved' : 'Saved');
    final color = dirty
        ? theme.colorScheme.tertiary
        : theme.colorScheme.onSurfaceVariant;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (saving)
            SizedBox(
              width: 13,
              height: 13,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: color,
              ),
            )
          else
            Icon(
              dirty ? Icons.edit_rounded : Icons.check_rounded,
              size: 15,
              color: color,
            ),
          const SizedBox(width: 5),
          Text(
            label,
            style: theme.textTheme.labelMedium?.copyWith(
              color: color,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class EntryEditorDialog extends StatelessWidget {
  const EntryEditorDialog({
    super.key,
    required this.title,
    required this.group,
    required this.initial,
  });

  final String title;
  final GroupDef group;
  final Map<String, dynamic> initial;

  @override
  Widget build(BuildContext context) {
    final values = Map<String, dynamic>.from(initial);
    return StatefulBuilder(
      builder: (context, setDialogState) => AlertDialog(
        title: Text(title),
        content: SizedBox(
          width: double.maxFinite,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                for (final field in group.fields) ...[
                  FieldInput(
                    key: ValueKey(field.key),
                    field: field,
                    value: values[field.key],
                    onChanged: (value) => setDialogState(() {
                      values[field.key] = value;
                    }),
                  ),
                  const SizedBox(height: 16),
                ],
              ],
            ),
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          FilledButton(
            onPressed: () {
              final hasContent = values.values.any((value) {
                // An explicitly selected false toggle is still a meaningful answer.
                if (value == null || value == '') return false;
                if (value is List) return value.isNotEmpty;
                return true;
              });
              if (!hasContent) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Add at least one detail before saving.')),
                );
                return;
              }
              Navigator.pop(context, values);
            },
            child: const Text('Save entry'),
          ),
        ],
      ),
    );
  }
}
