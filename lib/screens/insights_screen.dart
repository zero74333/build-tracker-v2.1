import 'package:flutter/material.dart';

import '../data/database.dart';

class InsightsScreen extends StatefulWidget {
  const InsightsScreen({super.key});

  @override
  State<InsightsScreen> createState() => _InsightsScreenState();
}

class _InsightsScreenState extends State<InsightsScreen> {
  Map<String, Map<String, dynamic>> _all = {};
  bool _loading = true;
  String? _loadError;

  @override
  void initState() {
    super.initState();
    _load();
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

  List<MapEntry<String, Map<String, dynamic>>> get _recent {
    final entries = _all.entries.toList()..sort((a, b) => b.key.compareTo(a.key));
    return entries.take(7).toList();
  }

  double? _average(String key) {
    final values = _recent
        .map((entry) => _toDouble(entry.value[key]))
        .whereType<double>()
        .toList();
    if (values.isEmpty) return null;
    return values.reduce((a, b) => a + b) / values.length;
  }

  double? _toDouble(dynamic value) {
    if (value is num) return value.toDouble();
    return value == null ? null : double.tryParse(value.toString());
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final recent = _recent;
    return SafeArea(
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
                        const Text('Could not load insights'),
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
              : RefreshIndicator(
              onRefresh: _load,
              child: ListView(
                padding: const EdgeInsets.fromLTRB(18, 16, 18, 28),
                children: [
                  Text('PATTERNS OVER TIME', style: theme.textTheme.labelSmall?.copyWith(letterSpacing: 1.8, color: theme.colorScheme.tertiary)),
                  Text('Insights', style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w700)),
                  Text('A simple view of your recent records. Averages use days where a value was entered.', style: theme.textTheme.bodySmall),
                  const SizedBox(height: 18),
                  if (_all.isEmpty)
                    const Card(child: Padding(padding: EdgeInsets.all(20), child: Text('Save a few daily entries to start seeing patterns here.')))
                  else ...[
                    _InsightMetric(title: 'Average day rating', value: _average('daily.rating'), color: const Color(0xFFC9A65A)),
                    _InsightMetric(title: 'Average mood', value: _average('mind.mood'), color: const Color(0xFF8C86C8)),
                    _InsightMetric(title: 'Average sleep', value: _average('sleep.hours'), color: const Color(0xFF5EADA2), suffix: 'h'),
                    _InsightMetric(title: 'Average stress', value: _average('mind.stress'), color: const Color(0xFFCC927A), worst: true),
                    const SizedBox(height: 14),
                    Text('Recent days', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
                    const SizedBox(height: 8),
                    for (final entry in recent)
                      _DayTrendRow(
                        date: entry.key,
                        rating: _toDouble(entry.value['daily.rating']),
                        mood: _toDouble(entry.value['mind.mood']),
                      ),
                  ],
                ],
              ),
            ),
    );
  }
}

class _InsightMetric extends StatelessWidget {
  const _InsightMetric({
    required this.title,
    required this.value,
    required this.color,
    this.suffix = '/ 10',
    this.worst = false,
  });

  final String title;
  final double? value;
  final Color color;
  final String suffix;
  final bool worst;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final normalized = value == null ? 0.0 : (value! / 10).clamp(0.0, 1.0).toDouble();
    return Card(
      margin: const EdgeInsets.only(bottom: 9),
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(child: Text(title, style: theme.textTheme.titleSmall)),
                Text(value == null ? '—' : '${value!.toStringAsFixed(1)} $suffix', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
              ],
            ),
            const SizedBox(height: 9),
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: LinearProgressIndicator(
                value: normalized,
                minHeight: 7,
                color: color,
                backgroundColor: theme.colorScheme.surfaceContainerHighest,
              ),
            ),
            if (worst)
              Padding(
                padding: const EdgeInsets.only(top: 5),
                child: Text('Higher values indicate more strain.', style: theme.textTheme.bodySmall),
              ),
          ],
        ),
      ),
    );
  }
}

class _DayTrendRow extends StatelessWidget {
  const _DayTrendRow({required this.date, required this.rating, required this.mood});
  final String date;
  final double? rating;
  final double? mood;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      margin: const EdgeInsets.only(bottom: 7),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(child: Text(date, style: theme.textTheme.labelLarge)),
                Text('Day ${rating?.toStringAsFixed(0) ?? '—'}  ·  Mood ${mood?.toStringAsFixed(0) ?? '—'}', style: theme.textTheme.bodySmall),
              ],
            ),
            const SizedBox(height: 9),
            Row(
              children: [
                const SizedBox(width: 36, child: Text('Day', style: TextStyle(fontSize: 11))),
                Expanded(
                  child: LinearProgressIndicator(
                    value: rating == null ? 0 : (rating! / 10).clamp(0.0, 1.0).toDouble(),
                    color: const Color(0xFFC9A65A),
                    minHeight: 5,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 5),
            Row(
              children: [
                const SizedBox(width: 36, child: Text('Mood', style: TextStyle(fontSize: 11))),
                Expanded(
                  child: LinearProgressIndicator(
                    value: mood == null ? 0 : (mood! / 10).clamp(0.0, 1.0).toDouble(),
                    color: const Color(0xFF8C86C8),
                    minHeight: 5,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
