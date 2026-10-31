import 'package:flutter/material.dart';

import '../data/database.dart';
import '../data/fields.dart';
import 'section_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key, required this.date});

  final String date;

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  Map<String, dynamic> _data = {};
  bool _loading = true;
  String? _loadError;

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void didUpdateWidget(covariant DashboardScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.date != widget.date) _load();
  }

  Future<void> _load() async {
    if (mounted && !_loading) {
      setState(() {
        _loading = true;
        _loadError = null;
      });
    } else {
      _loadError = null;
    }
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

  Future<void> _openModule(ModuleDef module) async {
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => SectionScreen(module: module, date: widget.date),
      ),
    );
    await _load();
  }

  Future<void> _quickCapture() async {
    final titleController = TextEditingController();
    final detailsController = TextEditingController();
    var category = 'Idea';
    final result = await showDialog<Map<String, String>>(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: const Text('Quick capture'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                DropdownButtonFormField<String>(
                  initialValue: category,
                  decoration: const InputDecoration(labelText: 'Capture as'),
                  items: const [
                    DropdownMenuItem(value: 'Idea', child: Text('Idea')),
                    DropdownMenuItem(value: 'Thought', child: Text('Thought')),
                    DropdownMenuItem(value: 'Question', child: Text('Question')),
                    DropdownMenuItem(value: 'Learning', child: Text('Learning')),
                  ],
                  onChanged: (value) => setDialogState(() => category = value ?? 'Idea'),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: titleController,
                  autofocus: true,
                  textCapitalization: TextCapitalization.sentences,
                  decoration: const InputDecoration(
                    labelText: 'Title or first thought',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: detailsController,
                  minLines: 2,
                  maxLines: 4,
                  textCapitalization: TextCapitalization.sentences,
                  decoration: const InputDecoration(
                    labelText: 'Details (optional)',
                    border: OutlineInputBorder(),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(dialogContext), child: const Text('Cancel')),
            FilledButton(
              onPressed: () {
                if (titleController.text.trim().isEmpty) {
                  ScaffoldMessenger.of(dialogContext).showSnackBar(
                    const SnackBar(content: Text('Enter a title before capturing.')),
                  );
                  return;
                }
                Navigator.pop(dialogContext, {
                  'title': titleController.text.trim(),
                  'details': detailsController.text.trim(),
                  'category': category,
                });
              },
              child: const Text('Capture'),
            ),
          ],
        ),
      ),
    );
    titleController.dispose();
    detailsController.dispose();
    if (result == null || !mounted) return;

    try {
      final data = await TrackerDb.load(widget.date);
      final key = 'ideaverse_idea_inbox.entries';
      final raw = data[key];
      final entries = raw is List
          ? raw.whereType<Map>().map((item) => Map<String, dynamic>.from(item)).toList()
          : <Map<String, dynamic>>[];
      entries.add({
        'title': result['title'],
        'details': result['details'],
        'capture_type': result['category'],
        'category': 'Other',
        'status': 'New',
      });
      data[key] = entries;
      await TrackerDb.save(widget.date, data);
      await _load();
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Saved to the Ideaverse inbox.')),
      );
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Could not save capture: $error')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    if (_loadError != null) {
      return SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(28),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.storage_rounded, size: 44, color: theme.colorScheme.error),
                const SizedBox(height: 12),
                Text('Could not load your dashboard', style: theme.textTheme.titleMedium),
                const SizedBox(height: 6),
                Text(_loadError!, textAlign: TextAlign.center, style: theme.textTheme.bodySmall),
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
    final parsedDate = DateTime.tryParse(widget.date);
    final dateLabel = parsedDate == null
        ? widget.date
        : '${_weekday(parsedDate.weekday)}, ${parsedDate.day} ${_month(parsedDate.month)} ${parsedDate.year}';

    return SafeArea(
      child: LayoutBuilder(
        builder: (context, constraints) {
          final columns = constraints.maxWidth >= 720 ? 3 : 2;
          return CustomScrollView(
            slivers: [
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(18, 14, 18, 6),
                sliver: SliverToBoxAdapter(
                  child: Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(14),
                        child: Image.asset('assets/icon.png', width: 54, height: 54, fit: BoxFit.cover),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('LIFE SPACE', style: theme.textTheme.labelSmall?.copyWith(letterSpacing: 2.0, color: theme.colorScheme.tertiary)),
                            Text('Your dashboard', style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w700)),
                            Text(dateLabel, style: theme.textTheme.bodySmall),
                          ],
                        ),
                      ),
                      IconButton(
                        tooltip: 'Quick capture',
                        onPressed: _quickCapture,
                        icon: const Icon(Icons.add_circle_outline_rounded, size: 30),
                      ),
                    ],
                  ),
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 14),
                sliver: SliverToBoxAdapter(
                  child: _OverviewCard(
                    date: widget.date,
                    data: _data,
                    loading: _loading,
                    onQuickCapture: _quickCapture,
                  ),
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(18, 0, 18, 10),
                sliver: SliverToBoxAdapter(
                  child: Row(
                    children: [
                      Expanded(child: Text('Your spaces', style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700))),
                      Text('${modules.length} sections', style: theme.textTheme.labelMedium),
                    ],
                  ),
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(14, 0, 14, 24),
                sliver: SliverGrid(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) => _ModuleCard(
                      module: modules[index],
                      data: _data,
                      loading: _loading,
                      onTap: () => _openModule(modules[index]),
                    ),
                    childCount: modules.length,
                  ),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: columns,
                    mainAxisExtent: 156,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  String _weekday(int day) => const ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'][day - 1];
  String _month(int month) => const ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'][month - 1];
}

class _OverviewCard extends StatelessWidget {
  const _OverviewCard({
    required this.date,
    required this.data,
    required this.loading,
    required this.onQuickCapture,
  });

  final String date;
  final Map<String, dynamic> data;
  final bool loading;
  final VoidCallback onQuickCapture;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final rating = data['daily.rating'];
    final mood = data['mind.mood'];
    final dayWord = data['daily.one_word'];
    final totalFilled = modules.fold<int>(0, (sum, module) => sum + filledFieldCount(data, module));
    return Card(
      color: theme.colorScheme.surfaceContainerHigh,
      child: Padding(
        padding: const EdgeInsets.all(17),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(child: Text('Today at a glance', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700))),
                Icon(Icons.auto_graph_rounded, color: theme.colorScheme.tertiary),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                _Metric(value: rating == null ? '—' : '$rating/10', label: 'Day rating'),
                const SizedBox(width: 22),
                _Metric(value: mood == null ? '—' : '$mood/10', label: 'Mood'),
                const SizedBox(width: 22),
                _Metric(value: loading ? '…' : '$totalFilled', label: 'Details saved'),
              ],
            ),
            if (dayWord is String && dayWord.trim().isNotEmpty) ...[
              const SizedBox(height: 10),
              Text('“$dayWord”', style: theme.textTheme.bodyMedium?.copyWith(fontStyle: FontStyle.italic)),
            ],
            const SizedBox(height: 12),
            Align(
              alignment: Alignment.centerLeft,
              child: TextButton.icon(
                onPressed: onQuickCapture,
                icon: const Icon(Icons.bolt_rounded, size: 18),
                label: const Text('Capture an idea or thought'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Metric extends StatelessWidget {
  const _Metric({required this.value, required this.label});
  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(value, style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700)),
          Text(label, style: theme.textTheme.labelSmall),
        ],
      ),
    );
  }
}

class _ModuleCard extends StatelessWidget {
  const _ModuleCard({
    required this.module,
    required this.data,
    required this.loading,
    required this.onTap,
  });

  final ModuleDef module;
  final Map<String, dynamic> data;
  final bool loading;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final filled = filledFieldCount(data, module);
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(13),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 38,
                    height: 38,
                    decoration: BoxDecoration(
                      color: module.tint.withValues(alpha: 0.16),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(module.icon, color: module.tint),
                  ),
                  const Spacer(),
                  Icon(Icons.arrow_outward_rounded, size: 17, color: theme.colorScheme.onSurfaceVariant),
                ],
              ),
              const Spacer(),
              Text(module.title, maxLines: 1, overflow: TextOverflow.ellipsis, style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700)),
              const SizedBox(height: 3),
              Text(module.subtitle, maxLines: 2, overflow: TextOverflow.ellipsis, style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant, height: 1.2)),
              const SizedBox(height: 7),
              Text(loading ? 'Loading…' : '$filled saved details', style: theme.textTheme.labelSmall?.copyWith(color: module.tint)),
            ],
          ),
        ),
      ),
    );
  }
}
