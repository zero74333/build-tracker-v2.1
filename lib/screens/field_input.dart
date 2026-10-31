import 'package:flutter/material.dart';

import '../data/fields.dart';

/// Renders a single field with an explicit, bounded input height.
/// Keeping heights predictable prevents text inputs from filling the whole
/// available screen on some Android devices / Flutter layouts.
class FieldInput extends StatelessWidget {
  const FieldInput({
    super.key,
    required this.field,
    required this.value,
    required this.onChanged,
  });

  final FieldDef field;
  final dynamic value;
  final ValueChanged<dynamic> onChanged;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    switch (field.type) {
      case FieldType.text:
      case FieldType.multiline:
        final multiline = field.type == FieldType.multiline;
        return SizedBox(
          height: multiline ? 140 : 62,
          child: TextFormField(
            key: ValueKey('${field.key}.text-input'),
            initialValue: value?.toString() ?? '',
            minLines: multiline ? 4 : 1,
            maxLines: multiline ? 4 : 1,
            expands: false,
            textCapitalization: TextCapitalization.sentences,
            keyboardType: multiline ? TextInputType.multiline : TextInputType.text,
            textInputAction: multiline ? TextInputAction.newline : TextInputAction.next,
            scrollPadding: const EdgeInsets.only(bottom: 180),
            decoration: _decoration(field, multiline: multiline),
            onChanged: onChanged,
          ),
        );

      case FieldType.number:
        return SizedBox(
          height: 62,
          child: TextFormField(
            key: ValueKey('${field.key}.number-input'),
            initialValue: value?.toString() ?? '',
            keyboardType: const TextInputType.numberWithOptions(
              decimal: true,
              signed: true,
            ),
            textInputAction: TextInputAction.next,
            scrollPadding: const EdgeInsets.only(bottom: 180),
            decoration: _decoration(field),
            onChanged: (text) {
              if (text.trim().isEmpty) {
                onChanged(null);
                return;
              }
              onChanged(num.tryParse(text) ?? text);
            },
          ),
        );

      case FieldType.rating:
        final hasRating = value is num;
        final score = hasRating
            ? value.toDouble().clamp(1.0, 10.0).toDouble()
            : 5.0;
        final direction = field.worstIsHigh
            ? '10 = strongest / worst'
            : '10 = best';
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 3),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      field.label,
                      style: theme.textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  Text(
                    hasRating ? '${score.round()} / 10' : 'Not rated',
                    style: theme.textTheme.labelLarge?.copyWith(
                      color: theme.colorScheme.tertiary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
              Slider(
                value: score,
                min: 1,
                max: 10,
                divisions: 9,
                label: score.round().toString(),
                onChanged: (next) => onChanged(next.round()),
              ),
              Text(direction, style: theme.textTheme.bodySmall),
            ],
          ),
        );

      case FieldType.toggle:
        return Container(
          decoration: BoxDecoration(
            color: theme.colorScheme.surfaceContainerLow,
            borderRadius: BorderRadius.circular(14),
          ),
          child: SwitchListTile.adaptive(
            contentPadding: const EdgeInsets.symmetric(horizontal: 14),
            title: Text(field.label),
            value: value == true,
            onChanged: onChanged,
          ),
        );

      case FieldType.choice:
        final selected = field.options.contains(value) ? value as String : null;
        return SizedBox(
          height: 62,
          child: DropdownButtonFormField<String>(
            initialValue: selected,
            isExpanded: true,
            decoration: _decoration(field),
            items: [
              for (final option in field.options)
                DropdownMenuItem(
                  value: option,
                  child: Text(option, maxLines: 1, overflow: TextOverflow.ellipsis),
                ),
            ],
            onChanged: onChanged,
          ),
        );

      case FieldType.multiChoice:
        final selected = value is List
            ? value.map((item) => item.toString()).toSet()
            : <String>{};
        return Container(
          width: double.infinity,
          padding: const EdgeInsets.fromLTRB(13, 12, 13, 8),
          decoration: BoxDecoration(
            color: theme.colorScheme.surfaceContainerLow,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: theme.colorScheme.outlineVariant),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                field.label,
                style: theme.textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 9),
              Wrap(
                spacing: 8,
                runSpacing: 2,
                children: [
                  for (final option in field.options)
                    FilterChip(
                      label: Text(option),
                      selected: selected.contains(option),
                      onSelected: (checked) {
                        final next = <String>{...selected};
                        if (checked) {
                          next.add(option);
                        } else {
                          next.remove(option);
                        }
                        onChanged(next.toList());
                      },
                    ),
                ],
              ),
            ],
          ),
        );
    }
  }

  InputDecoration _decoration(FieldDef field, {bool multiline = false}) {
    const radius = BorderRadius.all(Radius.circular(14));
    return InputDecoration(
      labelText: field.label,
      hintText: field.hint,
      suffixText: field.unit,
      alignLabelWithHint: multiline,
      isDense: false,
      contentPadding: EdgeInsets.symmetric(
        horizontal: 16,
        vertical: multiline ? 13 : 12,
      ),
      border: const OutlineInputBorder(borderRadius: radius),
      enabledBorder: OutlineInputBorder(
        borderRadius: radius,
        borderSide: const BorderSide(color: Color(0xFF39474B)),
      ),
      focusedBorder: const OutlineInputBorder(
        borderRadius: radius,
        borderSide: BorderSide(color: Color(0xFFC9A65A), width: 1.6),
      ),
    );
  }
}
