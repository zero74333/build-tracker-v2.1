import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

import 'database.dart';
import 'fields.dart';

class ExportService {
  static Future<void> shareMarkdown() async {
    final all = await TrackerDb.loadAll();
    final buffer = StringBuffer('# Zeeshan Daily Life Style\n\n');
    buffer.writeln('Exported: ${DateTime.now().toIso8601String()}');
    buffer.writeln();

    for (final date in all.keys.toList()..sort()) {
      final data = all[date]!;
      buffer.writeln('## $date\n');
      for (final module in modules) {
        final moduleLines = <String>[];
        for (final group in module.groups) {
          if (group.repeatable) {
            final raw = data[repeatStorageKey(group)];
            if (raw is! List || raw.isEmpty) continue;
            moduleLines.add('### ${group.title}');
            for (var i = 0; i < raw.length; i++) {
              final entry = raw[i];
              if (entry is! Map) continue;
              moduleLines.add('**Entry ${i + 1}**');
              for (final field in group.fields) {
                final value = entry[field.key];
                if (!_hasValue(value)) continue;
                moduleLines.add('- ${field.label}: ${_display(value)}');
              }
            }
          } else {
            final lines = <String>[];
            for (final field in group.fields) {
              final value = data[fieldStorageKey(group, field)];
              if (!_hasValue(value)) continue;
              lines.add('- ${field.label}: ${_display(value)}');
            }
            if (lines.isNotEmpty) {
              moduleLines.add('### ${group.title}');
              moduleLines.addAll(lines);
            }
          }
        }
        if (moduleLines.isNotEmpty) {
          buffer.writeln('### ${module.title}');
          for (final line in moduleLines) {
            buffer.writeln(line);
          }
          buffer.writeln();
        }
      }

      // Keep legacy or future fields visible in an export rather than dropping them.
      final knownKeys = <String>{};
      for (final module in modules) {
        for (final group in module.groups) {
          if (group.repeatable) {
            knownKeys.add(repeatStorageKey(group));
          } else {
            knownKeys.addAll(group.fields.map((field) => fieldStorageKey(group, field)));
          }
        }
      }
      final unknown = data.entries.where(
        (entry) => !knownKeys.contains(entry.key) && _hasValue(entry.value),
      ).toList();
      if (unknown.isNotEmpty) {
        buffer.writeln('### Other saved fields');
        for (final entry in unknown) {
          buffer.writeln('- ${entry.key}: ${_display(entry.value)}');
        }
        buffer.writeln();
      }
    }

    final directory = await getTemporaryDirectory();
    final file = File('${directory.path}/zeeshan-life-tracker-export.md');
    await file.writeAsString(buffer.toString());
    await SharePlus.instance.share(
      ShareParams(
        files: [XFile(file.path)],
        subject: 'Zeeshan Daily Life Style — Markdown export',
      ),
    );
  }

  static Future<void> shareBackup() async {
    final all = await TrackerDb.loadAll();
    final directory = await getTemporaryDirectory();
    final file = File('${directory.path}/zeeshan-life-tracker-backup.json');
    await file.writeAsString(
      const JsonEncoder.withIndent('  ').convert(all),
      flush: true,
    );
    await SharePlus.instance.share(
      ShareParams(
        files: [XFile(file.path)],
        subject: 'Zeeshan Daily Life Style — JSON backup',
      ),
    );
  }

  static Future<int> restoreBackup() async {
    final file = await FilePicker.pickFile(
      type: FileType.custom,
      allowedExtensions: ['json'],
    );
    if (file == null) return 0;

    final bytes = await file.readAsBytes();
    final decoded = jsonDecode(utf8.decode(bytes));
    if (decoded is! Map) {
      throw const FormatException('The backup must contain a JSON object.');
    }

    final imported = <String, Map<String, dynamic>>{};
    for (final entry in decoded.entries) {
      if (entry.value is Map && _isValidDate(entry.key.toString())) {
        imported[entry.key.toString()] = Map<String, dynamic>.from(entry.value as Map);
      }
    }
    if (imported.isEmpty) {
      throw const FormatException('No valid dated entries were found in this backup.');
    }
    return TrackerDb.mergeAll(imported);
  }

  static bool _isValidDate(String value) {
    if (!RegExp(r'^\d{4}-\d{2}-\d{2}$').hasMatch(value)) return false;
    final parsed = DateTime.tryParse(value);
    return parsed != null && dateKey(parsed) == value;
  }

  static bool _hasValue(dynamic value) {
    if (value == null || value == '') return false;
    if (value is List) return value.isNotEmpty;
    if (value is Map) return value.isNotEmpty;
    return true;
  }

  static String _display(dynamic value) {
    if (value == true) return 'Yes';
    if (value == false) return 'No';
    if (value is List) return value.join(', ');
    if (value is Map) return jsonEncode(value);
    return value.toString();
  }
}
