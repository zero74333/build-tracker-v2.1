import 'package:flutter/material.dart';

import '../data/database.dart';
import 'dashboard_screen.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  Map<String, Map<String, dynamic>> _all = {};
  bool _loading = true;
  String? _loadError;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    if (!_loading) {
      setState(() {
        _loading = true;
        _loadError = null;
      });
    } else {
      _loadError = null;
    }
    try {
      final all = await TrackerDb.loadAll();
      if (!mounted) return;
      setState(() {
        _all = all;
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

  Future<void> _openDate(String date) async {
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => Scaffold(
          appBar: AppBar(title: Text('Journal · $date')),
          body: DashboardScreen(date: date),
        ),
      ),
    );
    await _load();
  }

  Future<void> _addPastDay() async {
    final now = DateTime.now();
    final selected = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: DateTime(2000),
      lastDate: now,
      helpText: 'Choose a date to create or open',
    );
    if (selected == null || !mounted) return;
    await _openDate(dateKey(selected));
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final dates = _all.keys.toList()..sort((a, b) => b.compareTo(a));

    return SafeArea(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(18, 16, 12, 10),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('YOUR RECORD', style: theme.textTheme.labelSmall?.copyWith(letterSpacing: 1.8, color: theme.colorScheme.tertiary)),
                      Text('History', style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w700)),
                      Text('${dates.length} days recorded', style: theme.textTheme.bodySmall),
                    ],
                  ),
                ),
                FilledButton.tonalIcon(
                  onPressed: _addPastDay,
                  icon: const Icon(Icons.add),
                  label: const Text('Add day'),
                ),
              ],
            ),
          ),
          Expanded(
            child: _loading
                ? const Center(child: CircularProgressIndicator())
                : _loadError != null
                ? Center(
                    child: Padding(
                      padding: const EdgeInsets.all(28),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.storage_rounded, size: 42),
                          const SizedBox(height: 10),
                          const Text('Could not load history'),
                          const SizedBox(height: 6),
                          Text(_loadError!, textAlign: TextAlign.center, style: theme.textTheme.bodySmall),
                          const SizedBox(height: 14),
                          FilledButton.icon(
                            onPressed: _load,
                            icon: const Icon(Icons.refresh_rounded),
                            label: const Text('Try again'),
                          ),
                        ],
                      ),
                    ),
                  )
                : dates.isEmpty
                    ? Center(
                        child: Padding(
                          padding: const EdgeInsets.all(32),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.history_rounded, size: 52, color: theme.colorScheme.outline),
                              const SizedBox(height: 12),
                              Text('No saved days yet', style: theme.textTheme.titleMedium),
                              const SizedBox(height: 5),
                              const Text('Your daily records will appear here after you save something.'),
                            ],
                          ),
                        ),
                      )
                    : ListView.separated(
                        padding: const EdgeInsets.fromLTRB(14, 4, 14, 20),
                        itemCount: dates.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 7),
                        itemBuilder: (context, index) {
                          final date = dates[index];
                          final data = _all[date]!;
                          final rating = data['daily.rating'];
                          final mood = data['mind.mood'];
                          final word = data['daily.one_word'];
                          return Card(
                            child: ListTile(
                              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                              leading: CircleAvatar(
                                backgroundColor: theme.colorScheme.tertiaryContainer,
                                child: Icon(Icons.calendar_today_rounded, color: theme.colorScheme.onTertiaryContainer, size: 19),
                              ),
                              title: Text(date, style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700)),
                              subtitle: Text([
                                if (word is String && word.trim().isNotEmpty) word,
                                'Day ${rating ?? '—'}/10',
                                'Mood ${mood ?? '—'}/10',
                              ].join('  ·  '), maxLines: 2, overflow: TextOverflow.ellipsis),
                              trailing: const Icon(Icons.chevron_right_rounded),
                              onTap: () => _openDate(date),
                            ),
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }
}
