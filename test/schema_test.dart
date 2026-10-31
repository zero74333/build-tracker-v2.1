import 'package:flutter_test/flutter_test.dart';
import 'package:zeeshan_daily_life_style/data/database.dart';
import 'package:zeeshan_daily_life_style/data/fields.dart';

List<String> _regularStorageKeys() => [
      for (final module in modules)
        for (final group in module.groups.where((group) => !group.repeatable))
          for (final field in group.fields) fieldStorageKey(group, field),
    ];

FieldType? _typeForStorageKey(String storageKey) {
  for (final module in modules) {
    for (final group in module.groups.where((group) => !group.repeatable)) {
      for (final field in group.fields) {
        if (fieldStorageKey(group, field) == storageKey) return field.type;
      }
    }
  }
  return null;
}

void main() {
  group('Tracker structure', () {
    test('contains the nine dashboard modules with unique identifiers', () {
      final ids = modules.map((module) => module.id).toList();
      expect(ids, hasLength(9));
      expect(ids.toSet().length, ids.length);
      expect(ids, containsAll([
        'daily',
        'health',
        'mind',
        'ideaverse',
        'work',
        'money',
        'social',
        'habits',
        'activities',
      ]));
    });

    test('groups and fields have unique identifiers within each module', () {
      for (final module in modules) {
        final groupIds = module.groups.map((group) => group.id).toList();
        expect(
          groupIds.toSet().length,
          groupIds.length,
          reason: 'Duplicate group id in ${module.id}',
        );
        for (final group in module.groups) {
          final fieldIds = group.fields.map((field) => field.key).toList();
          expect(
            fieldIds.toSet().length,
            fieldIds.length,
            reason: 'Duplicate field key in ${module.id}.${group.id}',
          );
          expect(group.fields, isNotEmpty,
              reason: 'Empty group in ${module.id}.${group.id}');
        }
      }
    });

    test('regular field storage keys do not collide', () {
      final keys = _regularStorageKeys().toList();
      expect(
        keys.toSet().length,
        keys.length,
        reason: 'Two regular fields must not overwrite the same saved value.',
      );
    });

    test('explicitly saved false toggles count as completed entries', () {
      final habits = modules.firstWhere((module) => module.id == 'habits');
      expect(filledFieldCount({'habits.prayer': false}, habits), 1);
    });

    test('all choice fields define at least one option', () {
      for (final module in modules) {
        for (final group in module.groups) {
          for (final field in group.fields) {
            if (field.type == FieldType.choice || field.type == FieldType.multiChoice) {
              expect(field.options, isNotEmpty,
                  reason: 'Missing options for ${module.id}.${group.id}.${field.key}');
              expect(field.options.toSet().length, field.options.length,
                  reason: 'Duplicate options for ${module.id}.${group.id}.${field.key}');
            }
          }
        }
      }
    });

    test('repeating group storage keys are unique and do not collide with fields', () {
      final repeatedKeys = [
        for (final module in modules)
          for (final group in module.groups.where((group) => group.repeatable))
            repeatStorageKey(group),
      ];
      expect(repeatedKeys.toSet().length, repeatedKeys.length);
      expect(
        _regularStorageKeys().toSet().intersection(repeatedKeys.toSet()),
        isEmpty,
        reason: 'A repeatable list must not overwrite a regular field.',
      );
    });

    test('all 81 storage keys from the earlier app remain represented', () {
      const legacyKeys = <String>{
        'daily.type', 'daily.rating', 'daily.p1', 'daily.p2', 'daily.p3',
        'daily.win', 'daily.drain', 'daily.did', 'daily.lesson', 'daily.tomorrow',
        'sleep.target', 'sleep.bed', 'sleep.on_target', 'sleep.hours',
        'sleep.fall_asleep', 'sleep.wake', 'sleep.wakeups', 'sleep.before_bed',
        'sleep.energy_wake', 'sleep.quality',
        'mind.mood', 'mind.energy', 'mind.stress', 'mind.happiness',
        'mind.smile', 'mind.journal',
        'habits.prayer', 'habits.reading', 'habits.walk', 'habits.skill',
        'habits.gratitude', 'habits.screen', 'habits.building', 'habits.breaking',
        'health.meals', 'health.healthy_meals', 'health.water', 'health.fibre',
        'health.hunger', 'health.activity', 'health.bowel', 'health.stool',
        'health.straining', 'health.bloating', 'health.gas', 'health.acidity',
        'health.stomach_pain', 'health.nausea', 'health.after_meal',
        'health.triggers', 'health.probiotic', 'health.symptoms', 'health.medicines',
        'work.tasks_planned', 'work.tasks_done', 'work.deep_hours',
        'work.skill_hours', 'work.skill_name', 'work.output', 'work.career',
        'work.goal', 'work.goal_progress', 'work.blockers', 'work.pending',
        'money.income', 'money.spent', 'money.expenses', 'money.no_spend',
        'money.saved', 'money.bills',
        'social.in_person', 'social.non_person', 'social.social_energy',
        'activities.major', 'activities.unexpected', 'activities.gaps',
        'activities.gap_common', 'activities.training', 'activities.next_practice',
        'activities.new_things', 'activities.memories',
      };
      expect(legacyKeys, hasLength(81));
      expect(_regularStorageKeys(), containsAll(legacyKeys));
    });

    test('legacy boolean and text values retain compatible input types', () {
      for (final key in [
        'sleep.on_target',
        'habits.prayer',
        'habits.reading',
        'habits.walk',
        'habits.skill',
        'habits.gratitude',
        'habits.screen',
        'health.straining',
        'health.nausea',
        'money.no_spend',
      ]) {
        expect(_typeForStorageKey(key), FieldType.toggle, reason: key);
      }
      expect(_typeForStorageKey('sleep.before_bed'), FieldType.text);
      expect(_typeForStorageKey('money.income'), FieldType.multiline);
      expect(_typeForStorageKey('money.expenses'), FieldType.multiline);
    });

    test('date key uses a stable ISO date format', () {
      expect(dateKey(DateTime(2026, 10, 5)), '2026-10-05');
    });
  });
}
