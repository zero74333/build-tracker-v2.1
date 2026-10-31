import 'package:flutter/material.dart';

enum FieldType { text, multiline, number, rating, toggle, choice, multiChoice }

class FieldDef {
  const FieldDef(
    this.key,
    this.label,
    this.type, {
    this.options = const [],
    this.hint,
    this.unit,
    this.worstIsHigh = false,
  });

  final String key;
  final String label;
  final FieldType type;
  final List<String> options;
  final String? hint;
  final String? unit;
  final bool worstIsHigh;
}

/// A group is a visually separate card inside a module.
/// Repeating groups store a list of maps; regular groups store one value per field.
class GroupDef {
  const GroupDef({
    required this.id,
    required this.title,
    required this.storageKey,
    required this.fields,
    this.description,
    this.repeatable = false,
  });

  final String id;
  final String title;
  final String storageKey;
  final String? description;
  final List<FieldDef> fields;
  final bool repeatable;
}

class ModuleDef {
  const ModuleDef({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.tint,
    required this.groups,
  });

  final String id;
  final String title;
  final String subtitle;
  final IconData icon;
  final Color tint;
  final List<GroupDef> groups;
}

const emotions = [
  'Calm', 'Happy', 'Grateful', 'Hopeful', 'Motivated', 'Content', 'Excited',
  'Proud', 'Loved', 'Tired', 'Bored', 'Restless', 'Anxious', 'Worried', 'Sad',
  'Lonely', 'Irritable', 'Angry', 'Frustrated', 'Overwhelmed', 'Guilty', 'Numb',
];

const _severity = ['None', 'Mild', 'Moderate', 'Strong'];
const _partOfDay = ['Morning', 'Afternoon', 'Evening', 'Night'];
const _taskStatus = ['To do', 'Doing', 'Done', 'Moved to later', 'Waiting', 'Dropped'];

const modules = <ModuleDef>[
  ModuleDef(
    id: 'daily',
    title: 'Daily Log',
    subtitle: 'Intentions, priorities and the story of your day',
    icon: Icons.today_rounded,
    tint: Color(0xFFC9A65A),
    groups: [
      GroupDef(
        id: 'overview',
        title: 'Day overview',
        storageKey: 'daily',
        description: 'Set a direction in the morning and record the day in a few words.',
        fields: [
          FieldDef('type', 'Type of day', FieldType.choice, options: ['Workday', 'Weekend', 'Holiday', 'Festival', 'Travel', 'Sick', 'Rest', 'Busy', 'Slow']),
          FieldDef('location', 'Where I spent the day', FieldType.multiChoice, options: ['Home', 'Office', 'Outdoors', 'Travel', 'Other']),
          FieldDef('occasion', 'Special occasion or event', FieldType.text, hint: 'Appointment, birthday, deadline…'),
          FieldDef('focus', 'Day focus or intention', FieldType.text),
          FieldDef('desired_feeling', 'How I want to feel today', FieldType.choice, options: emotions),
          FieldDef('rating', 'Overall day rating', FieldType.rating),
          FieldDef('one_word', 'Day in one word', FieldType.text),
        ],
      ),
      GroupDef(
        id: 'priorities',
        title: 'Top priorities',
        storageKey: 'daily',
        description: 'Keep the list short. Record what happened to each priority.',
        fields: [
          FieldDef('p1', 'Priority 1', FieldType.text),
          FieldDef('p1_result', 'Priority 1 result', FieldType.choice, options: ['Done', 'Partly done', 'Not done']),
          FieldDef('p2', 'Priority 2', FieldType.text),
          FieldDef('p2_result', 'Priority 2 result', FieldType.choice, options: ['Done', 'Partly done', 'Not done']),
          FieldDef('p3', 'Priority 3', FieldType.text),
          FieldDef('p3_result', 'Priority 3 result', FieldType.choice, options: ['Done', 'Partly done', 'Not done']),
        ],
      ),
      GroupDef(
        id: 'reflection',
        title: 'End-of-day reflection',
        storageKey: 'daily',
        description: 'A factual review, not a judgement of yourself.',
        fields: [
          FieldDef('did', 'What I did today', FieldType.multiline),
          FieldDef('win', 'Biggest win', FieldType.text),
          FieldDef('drain', 'Biggest drain', FieldType.text),
          FieldDef('regret', 'Mistake or regret', FieldType.text),
          FieldDef('went_well', 'What went well', FieldType.multiline),
          FieldDef('not_well', 'What did not go well', FieldType.multiline),
          FieldDef('differently', 'What I would do differently', FieldType.multiline),
          FieldDef('lesson', 'Lesson of the day', FieldType.text),
          FieldDef('moral', 'Moral of the day', FieldType.text),
        ],
      ),
      GroupDef(
        id: 'tomorrow',
        title: 'Prepare for tomorrow',
        storageKey: 'daily',
        fields: [
          FieldDef('tomorrow', 'First task for tomorrow', FieldType.text),
          FieldDef('top_priority', 'Top priority for tomorrow', FieldType.text),
          FieldDef('preparation', 'Preparation completed', FieldType.multiChoice, options: ['Clothes ready', 'Bag ready', 'Schedule checked', 'Alarm set', 'Tasks planned', 'Meals planned']),
        ],
      ),
    ],
  ),
  ModuleDef(
    id: 'health',
    title: 'Health & Body',
    subtitle: 'Sleep, meals, digestion, movement and symptoms',
    icon: Icons.favorite_rounded,
    tint: Color(0xFF5EADA2),
    groups: [
      GroupDef(
        id: 'sleep', title: 'Sleep', storageKey: 'sleep',
        description: 'Compare sleep timing and quality with your daily energy.',
        fields: [
          FieldDef('target', 'Target bedtime', FieldType.text, hint: 'e.g. 10:30 PM'),
          FieldDef('target_wake', 'Target wake time', FieldType.text),
          FieldDef('screens_off', 'Screens off at', FieldType.text),
          FieldDef('last_meal', 'Last meal at', FieldType.text),
          FieldDef('bed', 'Went to bed at', FieldType.text),
          FieldDef('on_target', 'Slept by target time', FieldType.toggle),
          FieldDef('fall_asleep', 'Time to fall asleep', FieldType.number, unit: 'min'),
          FieldDef('wake', 'Woke up at', FieldType.text),
          FieldDef('wake_method', 'Woke up by', FieldType.choice, options: ['Alarm', 'Naturally', 'Disturbed']),
          FieldDef('hours', 'Total sleep', FieldType.number, unit: 'hours'),
          FieldDef('wakeups', 'Night wake-ups and reasons', FieldType.multiline),
          FieldDef('before_bed', 'Activity before sleep (notes)', FieldType.text),
          FieldDef('before_bed_activities', 'Activities before sleep', FieldType.multiChoice, options: ['Screen', 'Reading', 'Prayer', 'Work', 'Meal', 'Walk', 'Exercise', 'Shower', 'Nothing']),
          FieldDef('energy_wake', 'Energy on waking', FieldType.rating),
          FieldDef('quality', 'Sleep quality', FieldType.rating),
          FieldDef('groggy', 'Grogginess on waking', FieldType.choice, options: _severity),
          FieldDef('dreams', 'Dreams', FieldType.choice, options: ['None', 'Pleasant', 'Neutral', 'Disturbing']),
        ],
      ),
      GroupDef(
        id: 'meals', title: 'Meals & intake', storageKey: 'health',
        description: 'Use one line per meal. Note the meal experience and how your stomach felt afterwards.',
        fields: [
          FieldDef('breakfast', 'Breakfast — food, time, portion and experience', FieldType.multiline, hint: 'What I ate, how much, how I felt, and how my stomach felt afterwards.'),
          FieldDef('breakfast_quality', 'Breakfast quality', FieldType.rating),
          FieldDef('lunch', 'Lunch — food, time, portion and experience', FieldType.multiline, hint: 'What I ate, how much, how I felt, and how my stomach felt afterwards.'),
          FieldDef('lunch_quality', 'Lunch quality', FieldType.rating),
          FieldDef('dinner', 'Dinner — food, time, portion and experience', FieldType.multiline, hint: 'What I ate, how much, how I felt, and how my stomach felt afterwards.'),
          FieldDef('dinner_quality', 'Dinner quality', FieldType.rating),
          FieldDef('snacks', 'Snacks and other food', FieldType.multiline),
          FieldDef('meals', 'Earlier combined meals log', FieldType.multiline),
          FieldDef('meal_quality', 'Overall meal quality', FieldType.rating),
          FieldDef('healthy_meals', 'Healthy meals (out of 3)', FieldType.number, unit: '/ 3'),
          FieldDef('water', 'Water', FieldType.number, unit: 'glasses'),
          FieldDef('other_drinks', 'Other drinks and quantity', FieldType.text),
          FieldDef('caffeine', 'Caffeine', FieldType.number, unit: 'cups'),
          FieldDef('fibre', 'Fruit, vegetables and fibre', FieldType.text),
          FieldDef('protein', 'Protein sources', FieldType.text),
          FieldDef('hunger', 'Overall hunger', FieldType.choice, options: ['Normal', 'Low', 'High', 'Skipped meals']),
          FieldDef('late_eating', 'Late-night eating', FieldType.toggle),
          FieldDef('cravings', 'Cravings', FieldType.multiChoice, options: ['Sweet', 'Salty', 'Fried', 'Caffeine', 'Other']),
          FieldDef('after_meal', 'Stomach experience after each meal', FieldType.multiline, hint: 'Meal → comfort / bloating / pain / reflux / other changes'),
          FieldDef('probiotic', 'Probiotic or digestive supplement', FieldType.text),
        ],
      ),
      GroupDef(
        id: 'gut', title: 'Gut health', storageKey: 'health',
        description: 'Track patterns over time. This log is not a diagnosis.',
        fields: [
          FieldDef('bowel', 'Bowel movements', FieldType.number, unit: 'count'),
          FieldDef('stool', 'Stool consistency', FieldType.choice, options: ['Bristol 1', 'Bristol 2', 'Bristol 3', 'Bristol 4', 'Bristol 5', 'Bristol 6', 'Bristol 7', 'Normal', 'Hard', 'Loose', 'Mixed']),
          FieldDef('ease', 'Ease of passing stool', FieldType.choice, options: ['Easy', 'Mild effort', 'Straining']),
          FieldDef('emptying', 'Emptying', FieldType.choice, options: ['Complete', 'Incomplete']),
          FieldDef('urgency', 'Urgency', FieldType.choice, options: ['None', 'Mild', 'Urgent']),
          FieldDef('gut_comfort', 'Overall gut comfort', FieldType.rating),
          FieldDef('bloating', 'Bloating', FieldType.choice, options: _severity),
          FieldDef('gas', 'Gas', FieldType.choice, options: _severity),
          FieldDef('acidity', 'Acidity or heartburn', FieldType.choice, options: _severity),
          FieldDef('reflux', 'Reflux', FieldType.choice, options: _severity),
          FieldDef('stomach_pain', 'Stomach pain or cramps (where and severity)', FieldType.text),
          FieldDef('straining', 'Straining or incomplete emptying', FieldType.toggle),
          FieldDef('nausea', 'Nausea noticed', FieldType.toggle),
          FieldDef('nausea_severity', 'Nausea severity', FieldType.choice, options: _severity),
          FieldDef('triggers', 'Foods that seemed to cause a problem', FieldType.text),
          FieldDef('foods_good', 'Foods that felt comfortable', FieldType.text),
          FieldDef('what_helped', 'What helped', FieldType.multiChoice, options: ['Rest', 'Warm water', 'Walking', 'Medicine', 'Nothing', 'Other']),
          FieldDef('gut_notes', 'Other digestive observations', FieldType.multiline),
          FieldDef('urination_count', 'Urination count', FieldType.number),
          FieldDef('urine_colour', 'Urine colour', FieldType.choice, options: ['Clear', 'Light yellow', 'Dark yellow', 'Brown or red']),
          FieldDef('urine_pain', 'Burning or pain while urinating', FieldType.toggle),
          FieldDef('night_trips', 'Night trips to urinate', FieldType.number),
          FieldDef('blood_mucus', 'Blood or mucus noticed in stool', FieldType.choice, options: ['None', 'Blood', 'Mucus', 'Both']),
        ],
      ),
      GroupDef(
        id: 'movement', title: 'Movement & activity', storageKey: 'health',
        fields: [
          FieldDef('activity', 'Activity and exercise', FieldType.multiline),
          FieldDef('steps', 'Steps', FieldType.number),
          FieldDef('active_minutes', 'Active minutes', FieldType.number, unit: 'min'),
          FieldDef('sitting', 'Sitting time', FieldType.number, unit: 'hours'),
          FieldDef('breaks', 'Movement breaks', FieldType.number),
          FieldDef('sunlight', 'Outdoors or sunlight', FieldType.number, unit: 'min'),
          FieldDef('stretching', 'Stretching or mobility', FieldType.number, unit: 'min'),
          FieldDef('rest_day', 'Rest day', FieldType.toggle),
        ],
      ),
      GroupDef(
        id: 'body', title: 'Body & symptoms', storageKey: 'health',
        fields: [
          FieldDef('energy_morning', 'Physical energy — morning', FieldType.rating),
          FieldDef('energy_afternoon', 'Physical energy — afternoon', FieldType.rating),
          FieldDef('energy_evening', 'Physical energy — evening', FieldType.rating),
          FieldDef('symptoms', 'Symptoms (what, where, severity 1–10)', FieldType.multiline),
          FieldDef('hygiene', 'Self-care completed', FieldType.multiChoice, options: ['Brush teeth morning', 'Brush teeth night', 'Shower', 'Skincare', 'Grooming']),
          FieldDef('medicines', 'Medicines or supplements (name, dose, time)', FieldType.multiline),
          FieldDef('weight', 'Weight', FieldType.number, unit: 'kg'),
          FieldDef('blood_pressure', 'Blood pressure', FieldType.text, hint: 'Systolic / diastolic'),
          FieldDef('heart_rate', 'Resting heart rate', FieldType.number, unit: 'bpm'),
          FieldDef('temperature', 'Temperature', FieldType.number, unit: '°C'),
          FieldDef('health_notes', 'Additional health notes', FieldType.multiline),
        ],
      ),
    ],
  ),
  ModuleDef(
    id: 'mind', title: 'Mind & Mood',
    subtitle: 'Mood, mental energy, stress and emotional patterns',
    icon: Icons.psychology_alt_rounded,
    tint: Color(0xFF8C86C8),
    groups: [
      GroupDef(
        id: 'mood_checkins', title: 'Mood check-ins', storageKey: 'mind_mood_checkins', repeatable: true,
        description: 'Record different parts of the day separately when your mood changes.',
        fields: [
          FieldDef('part', 'Part of day', FieldType.choice, options: _partOfDay),
          FieldDef('mood', 'Mood', FieldType.rating),
          FieldDef('emotions', 'Emotions', FieldType.multiChoice, options: emotions),
          FieldDef('influence', 'What influenced it', FieldType.multiChoice, options: ['Sleep', 'Food', 'People', 'Work', 'News', 'Weather', 'Thoughts', 'Health', 'Nothing clear']),
        ],
      ),
      GroupDef(
        id: 'mood', title: 'Daily mood summary', storageKey: 'mind',
        fields: [
          FieldDef('mood', 'Overall mood', FieldType.rating),
          FieldDef('happiness', 'Happiness', FieldType.rating),
          FieldDef('smile', 'Something that made me smile', FieldType.text),
          FieldDef('calm', 'Calm', FieldType.rating),
          FieldDef('motivation', 'Motivation', FieldType.rating),
          FieldDef('confidence', 'Confidence', FieldType.rating),
          FieldDef('purpose', 'Sense of purpose', FieldType.rating),
          FieldDef('loneliness', 'Loneliness', FieldType.rating, worstIsHigh: true),
          FieldDef('emotions', 'Emotions experienced', FieldType.multiChoice, options: emotions),
          FieldDef('self_talk', 'Self-talk', FieldType.choice, options: ['Kind', 'Neutral', 'Harsh']),
        ],
      ),
      GroupDef(
        id: 'mental_energy', title: 'Energy & mental fatigue', storageKey: 'mind',
        fields: [
          FieldDef('energy', 'Mental energy', FieldType.rating),
          FieldDef('fatigue', 'Mental fatigue', FieldType.rating, worstIsHigh: true),
          FieldDef('fatigue_peak', 'Fatigue peaked at', FieldType.choice, options: _partOfDay),
          FieldDef('fatigue_causes', 'Likely causes', FieldType.multiChoice, options: ['Poor sleep', 'Long focus', 'Too many decisions', 'Multitasking', 'Screen overload', 'Emotional strain', 'Noise', 'Hunger or dehydration', 'Unclear task', 'Other']),
          FieldDef('brain_fog', 'Brain fog', FieldType.choice, options: _severity),
          FieldDef('clarity', 'Focus and clarity', FieldType.rating),
          FieldDef('focus_stretch', 'Longest focus stretch', FieldType.number, unit: 'min'),
          FieldDef('restored_by', 'What restored me', FieldType.multiChoice, options: ['Break', 'Walk', 'Nap', 'Food or water', 'Music', 'Talking', 'Prayer', 'Nothing']),
        ],
      ),
      GroupDef(
        id: 'anxiety_stress', title: 'Anxiety & stress', storageKey: 'mind',
        fields: [
          FieldDef('anxiety', 'Anxiety level', FieldType.rating, worstIsHigh: true),
          FieldDef('anxiety_trigger', 'Anxiety trigger or situation', FieldType.multiline),
          FieldDef('anxiety_body', 'Physical signs', FieldType.multiChoice, options: ['Fast heartbeat', 'Tight chest', 'Shallow breathing', 'Shaking', 'Sweating', 'Stomach upset', 'Muscle tension', 'Restlessness', 'Dry mouth', 'Dizziness']),
          FieldDef('thought_patterns', 'Thought patterns', FieldType.multiChoice, options: ['Overthinking', 'Worst-case thinking', 'Replaying the past', 'Fear of future', 'Self-criticism', 'Comparing with others', 'Need for certainty', 'Avoidance']),
          FieldDef('anxiety_duration', 'How long it lasted', FieldType.number, unit: 'min'),
          FieldDef('coping', 'What I did to cope', FieldType.multiChoice, options: ['Breathing', 'Prayer', 'Walk', 'Talked to someone', 'Music', 'Writing', 'Distraction', 'Nothing']),
          FieldDef('stress', 'Stress level', FieldType.rating, worstIsHigh: true),
          FieldDef('stress_causes', 'Stress causes', FieldType.multiChoice, options: ['Workload', 'Deadlines', 'Money', 'Health', 'Relationships', 'Family', 'Future uncertainty', 'Lack of sleep', 'Conflict', 'Noise', 'Social media', 'Self-expectations', 'Other']),
          FieldDef('control', 'How much was in my control', FieldType.choice, options: ['In my control', 'Partly', 'Not in my control']),
          FieldDef('reduce_stress', 'One step to reduce it', FieldType.text),
          FieldDef('recovered', 'Recovered by evening', FieldType.choice, options: ['Yes', 'Partly', 'No']),
        ],
      ),
      GroupDef(
        id: 'reflection', title: 'Calming practices & reflection', storageKey: 'mind',
        fields: [
          FieldDef('practices', 'Practices done', FieldType.multiChoice, options: ['Breathing', 'Meditation', 'Prayer', 'Walk', 'Music', 'Nature', 'Journaling', 'Talking', 'Stretching', 'Nap', 'Shower', 'None']),
          FieldDef('practice_minutes', 'Time spent', FieldType.number, unit: 'min'),
          FieldDef('drain', 'Something that drained me', FieldType.text),
          FieldDef('gratitude', 'Gratitude', FieldType.multiline),
          FieldDef('proud', 'Something I am proud of', FieldType.text),
          FieldDef('tomorrow_need', 'What I need more or less of tomorrow', FieldType.text),
          FieldDef('journal', 'Short journal', FieldType.multiline),
        ],
      ),
    ],
  ),
  ModuleDef(
    id: 'ideaverse', title: 'Ideaverse',
    subtitle: 'Capture ideas, insights, questions and things worth remembering',
    icon: Icons.auto_awesome_rounded,
    tint: Color(0xFF5A9CB5),
    groups: [
      GroupDef(
        id: 'idea_of_day', title: 'Idea of the day', storageKey: 'ideaverse_idea_of_day',
        fields: [
          FieldDef('idea', 'Pinned idea', FieldType.text),
          FieldDef('why', 'Why this idea matters', FieldType.multiline),
          FieldDef('potential', 'Potential', FieldType.rating),
          FieldDef('first_step', 'First small step', FieldType.text),
        ],
      ),
      GroupDef(
        id: 'idea_inbox', title: 'Idea inbox', storageKey: 'ideaverse_idea_inbox', repeatable: true,
        description: 'Capture first. You can classify and develop the idea later.',
        fields: [
          FieldDef('title', 'Idea title', FieldType.text),
          FieldDef('details', 'Details', FieldType.multiline),
          FieldDef('capture_type', 'Captured as', FieldType.choice, options: ['Idea', 'Thought', 'Question', 'Learning']),
          FieldDef('category', 'Category', FieldType.choice, options: ['Business', 'App or tech', 'Career', 'Creative', 'Health', 'Money', 'Relationships', 'Learning', 'Lifestyle', 'Fun', 'Other']),
          FieldDef('source', 'Where it came from', FieldType.choice, options: ['My mind', 'Conversation', 'Book', 'Video', 'Social media', 'Dream', 'Walking', 'Work', 'Other']),
          FieldDef('problem', 'Problem it solves', FieldType.text),
          FieldDef('excitement', 'Excitement', FieldType.rating),
          FieldDef('effort', 'Effort required', FieldType.rating, worstIsHigh: true),
          FieldDef('status', 'Status', FieldType.choice, options: ['New', 'Exploring', 'Planned', 'In progress', 'Done', 'Parked', 'Dropped']),
          FieldDef('next_action', 'Next small action', FieldType.text),
          FieldDef('review_date', 'Review date', FieldType.text, hint: 'YYYY-MM-DD'),
          FieldDef('related', 'Related ideas or project', FieldType.text),
        ],
      ),
      GroupDef(
        id: 'realizations', title: 'Major thoughts & realizations', storageKey: 'ideaverse_realizations', repeatable: true,
        fields: [
          FieldDef('thought', 'Thought or realization', FieldType.multiline),
          FieldDef('type', 'Type', FieldType.choice, options: ['Insight', 'Belief', 'Decision', 'Realization', 'Fear', 'Value', 'Principle', 'Perspective shift']),
          FieldDef('trigger', 'What triggered it', FieldType.text),
          FieldDef('life_area', 'Life area', FieldType.choice, options: ['Health', 'Mind', 'Work', 'Learning', 'Money', 'Relationships', 'Family', 'Spiritual', 'Home', 'Fun', 'Other']),
          FieldDef('importance', 'Importance', FieldType.rating),
          FieldDef('certainty', 'How sure I am', FieldType.rating),
          FieldDef('principle', 'Save as a personal principle', FieldType.toggle),
        ],
      ),
      GroupDef(
        id: 'stuck_thoughts', title: 'Thoughts stuck in mind', storageKey: 'ideaverse_stuck_thoughts', repeatable: true,
        fields: [
          FieldDef('thought', 'Recurring thought', FieldType.multiline),
          FieldDef('theme', 'Theme', FieldType.choice, options: ['Worry', 'Regret', 'Plan', 'Conversation replay', 'Fear', 'Desire', 'Question', 'Unfinished task', 'Other']),
          FieldDef('times', 'Times it returned today', FieldType.number),
          FieldDef('intensity', 'Intensity', FieldType.rating, worstIsHigh: true),
          FieldDef('trigger', 'When it shows up', FieldType.multiChoice, options: ['Idle time', 'Bedtime', 'After scrolling', 'During work', 'While eating', 'Alone', 'With people']),
          FieldDef('action', 'Is there an action I can take?', FieldType.choice, options: ['Yes', 'No', 'Not sure']),
          FieldDef('response', 'How I handled it', FieldType.choice, options: ['Wrote it down', 'Took action', 'Talked to someone', 'Distraction', 'Let it go', 'Ignored it', 'Still stuck']),
          FieldDef('status', 'Status', FieldType.choice, options: ['Active', 'Easing', 'Resolved']),
        ],
      ),
      GroupDef(
        id: 'learnings', title: 'New things I learned', storageKey: 'ideaverse_learnings', repeatable: true,
        fields: [
          FieldDef('learned', 'What I learned', FieldType.text),
          FieldDef('teachback', 'Explain it in one line', FieldType.multiline),
          FieldDef('topic', 'Topic or field', FieldType.text),
          FieldDef('type', 'Type', FieldType.choice, options: ['Fact', 'Concept', 'Skill', 'Tip', 'Lesson from mistake', 'Perspective']),
          FieldDef('source', 'Source', FieldType.choice, options: ['Book', 'Article', 'Video', 'Course', 'Person', 'Experience', 'Mistake', 'Other']),
          FieldDef('understanding', 'Understanding', FieldType.rating),
          FieldDef('use', 'How I will use it', FieldType.text),
          FieldDef('revisit', 'Revisit', FieldType.choice, options: ['Tomorrow', 'In 3 days', 'In a week', 'In a month', 'Never']),
        ],
      ),
      GroupDef(
        id: 'questions', title: 'Questions & curiosities', storageKey: 'ideaverse_questions', repeatable: true,
        fields: [
          FieldDef('question', 'Question', FieldType.text),
          FieldDef('why', 'Why it matters', FieldType.text),
          FieldDef('where', 'Where to look', FieldType.text),
          FieldDef('status', 'Status', FieldType.choice, options: ['Open', 'Researching', 'Answered']),
          FieldDef('answer', 'Answer or current understanding', FieldType.multiline),
        ],
      ),
      GroupDef(
        id: 'quotes', title: 'Quotes & snippets', storageKey: 'ideaverse_quotes', repeatable: true,
        fields: [
          FieldDef('text', 'Quote or snippet', FieldType.multiline),
          FieldDef('source', 'Source', FieldType.text),
          FieldDef('why', 'Why it mattered to me', FieldType.text),
        ],
      ),
      GroupDef(
        id: 'brain_dump', title: 'Brain dump', storageKey: 'ideaverse_brain_dump',
        fields: [
          FieldDef('notes', 'Unsorted notes', FieldType.multiline, hint: 'Write freely. Organise it later.'),
          FieldDef('sort_into', 'Sort into', FieldType.choice, options: ['Idea', 'Thought', 'Task', 'Question', 'Learning', 'Keep unsorted']),
        ],
      ),
    ],
  ),
  ModuleDef(
    id: 'work', title: 'Work & Learning',
    subtitle: 'Tasks, focus sessions, practice and long-term goals',
    icon: Icons.work_outline_rounded,
    tint: Color(0xFFB58B67),
    groups: [
      GroupDef(
        id: 'tasks', title: 'Tasks', storageKey: 'work_tasks', repeatable: true,
        description: 'Add tasks individually so they can be reviewed and carried forward.',
        fields: [
          FieldDef('task', 'Task', FieldType.text),
          FieldDef('group', 'Group', FieldType.choice, options: ['Must do today', 'Should do', 'Nice to have', 'Waiting on others', 'Recurring', 'Backlog']),
          FieldDef('category', 'Category', FieldType.choice, options: ['Work', 'Study', 'Career', 'Personal', 'Health', 'Money or admin', 'Home', 'Errands', 'Creative']),
          FieldDef('priority', 'Priority', FieldType.choice, options: ['High', 'Medium', 'Low']),
          FieldDef('due', 'Due date', FieldType.text, hint: 'YYYY-MM-DD'),
          FieldDef('estimate', 'Estimated time', FieldType.number, unit: 'min'),
          FieldDef('actual', 'Actual time', FieldType.number, unit: 'min'),
          FieldDef('energy', 'Energy needed', FieldType.choice, options: ['High', 'Medium', 'Low']),
          FieldDef('status', 'Status', FieldType.choice, options: _taskStatus),
          FieldDef('why_not', 'If not done, why?', FieldType.text),
          FieldDef('next_step', 'Next action', FieldType.text),
        ],
      ),
      GroupDef(
        id: 'focus', title: 'Focus sessions', storageKey: 'work_focus', repeatable: true,
        fields: [
          FieldDef('start', 'Start time', FieldType.text),
          FieldDef('end', 'End time', FieldType.text),
          FieldDef('task', 'Task or subject', FieldType.text),
          FieldDef('type', 'Session type', FieldType.choice, options: ['Deep work', 'Shallow or admin', 'Meeting', 'Study', 'Creative', 'Learning']),
          FieldDef('quality', 'Focus quality', FieldType.rating),
          FieldDef('distractions', 'Number of distractions', FieldType.number),
          FieldDef('main_distraction', 'Main distraction', FieldType.multiChoice, options: ['Phone', 'Social media', 'Messages', 'Noise', 'People', 'Browser tabs', 'My thoughts', 'Hunger or tiredness', 'None']),
          FieldDef('break', 'Break taken', FieldType.toggle),
        ],
      ),
      GroupDef(
        id: 'study', title: 'Study & skill practice', storageKey: 'work_study', repeatable: true,
        fields: [
          FieldDef('skill', 'Skill or subject', FieldType.text),
          FieldDef('topic', 'Topic', FieldType.text),
          FieldDef('resource', 'Resource', FieldType.choice, options: ['Book', 'Course', 'Video', 'Article', 'Practice', 'Mentor', 'Other']),
          FieldDef('method', 'Method', FieldType.multiChoice, options: ['Read', 'Watch', 'Practice', 'Teach', 'Take notes', 'Revise', 'Project']),
          FieldDef('time', 'Time spent', FieldType.number, unit: 'min'),
          FieldDef('understanding', 'Understanding', FieldType.rating),
          FieldDef('takeaway', 'Key takeaway', FieldType.text),
          FieldDef('next_step', 'Next step', FieldType.text),
        ],
      ),
      GroupDef(
        id: 'progress', title: 'Output, goals & blockers', storageKey: 'work',
        fields: [
          FieldDef('tasks_planned', 'Tasks planned', FieldType.number),
          FieldDef('tasks_done', 'Tasks completed', FieldType.number),
          FieldDef('deep_hours', 'Deep work hours', FieldType.number),
          FieldDef('skill_hours', 'Study or skill hours', FieldType.number),
          FieldDef('skill_name', 'Main skill worked on', FieldType.text),
          FieldDef('output', 'What I produced', FieldType.multiline),
          FieldDef('career', 'Career progress', FieldType.multiline),
          FieldDef('goal', 'Goal I moved forward', FieldType.text),
          FieldDef('goal_progress', 'Progress made', FieldType.rating),
          FieldDef('blockers', 'Blockers and how to unblock them', FieldType.multiline),
          FieldDef('avoidance', 'Something I avoided and why', FieldType.text),
          FieldDef('pending', 'Pending for tomorrow', FieldType.multiline),
          FieldDef('satisfaction', 'Work satisfaction', FieldType.rating),
        ],
      ),
    ],
  ),
  ModuleDef(
    id: 'money', title: 'Money',
    subtitle: 'Income, spending, savings and financial decisions',
    icon: Icons.account_balance_wallet_rounded,
    tint: Color(0xFF66A88D),
    groups: [
      GroupDef(
        id: 'income', title: 'Income', storageKey: 'money_income', repeatable: true,
        fields: [
          FieldDef('source', 'Source', FieldType.text),
          FieldDef('type', 'Type', FieldType.choice, options: ['Salary', 'Freelance or business', 'Gift', 'Refund', 'Interest or dividends', 'Sale', 'Other']),
          FieldDef('amount', 'Amount', FieldType.number, unit: '₹'),
          FieldDef('account', 'Account', FieldType.choice, options: ['Cash', 'Bank', 'Wallet', 'Other']),
        ],
      ),
      GroupDef(
        id: 'expenses', title: 'Expenses', storageKey: 'money_expenses', repeatable: true,
        fields: [
          FieldDef('item', 'Item', FieldType.text),
          FieldDef('category', 'Category', FieldType.choice, options: ['Food', 'Groceries', 'Transport', 'Rent', 'Bills', 'Health', 'Education', 'Shopping', 'Entertainment', 'Subscriptions', 'Gifts or charity', 'Family', 'Personal care', 'Travel', 'Debt', 'Other']),
          FieldDef('amount', 'Amount', FieldType.number, unit: '₹'),
          FieldDef('method', 'Payment method', FieldType.choice, options: ['Cash', 'Debit card', 'Credit card', 'Bank transfer', 'UPI', 'Other']),
          FieldDef('need', 'Need or want', FieldType.choice, options: ['Need', 'Want']),
          FieldDef('planned', 'Planned or impulse', FieldType.choice, options: ['Planned', 'Impulse']),
          FieldDef('mood', 'Mood at purchase', FieldType.choice, options: emotions),
          FieldDef('for_whom', 'For whom', FieldType.choice, options: ['Me', 'Family', 'Friend', 'Shared', 'Work']),
        ],
      ),
      GroupDef(
        id: 'summary', title: 'Daily money summary', storageKey: 'money',
        fields: [
          FieldDef('income', 'Income notes (earlier format)', FieldType.multiline),
          FieldDef('total_income', 'Total income', FieldType.number, unit: '₹'),
          FieldDef('expenses', 'Earlier combined expenses log', FieldType.multiline),
          FieldDef('spent', 'Total spent', FieldType.number, unit: '₹'),
          FieldDef('no_spend', 'No-spend day', FieldType.toggle),
          FieldDef('saved', 'Saved or invested', FieldType.number, unit: '₹'),
          FieldDef('budget', 'Daily budget', FieldType.number, unit: '₹'),
          FieldDef('bills', 'Bills due soon (name, date, amount, paid)', FieldType.multiline),
          FieldDef('debts', 'Debts or lending (person, amount, due date)', FieldType.multiline),
          FieldDef('money_stress', 'Money stress', FieldType.rating, worstIsHigh: true),
          FieldDef('lesson', 'Money lesson or decision', FieldType.text),
        ],
      ),
    ],
  ),
  ModuleDef(
    id: 'social', title: 'Relationships & Social',
    subtitle: 'Meaningful interactions, support and boundaries',
    icon: Icons.people_alt_rounded,
    tint: Color(0xFFCC927A),
    groups: [
      GroupDef(
        id: 'interactions', title: 'Interactions', storageKey: 'social_interactions', repeatable: true,
        fields: [
          FieldDef('person', 'Person', FieldType.text),
          FieldDef('relationship', 'Relationship', FieldType.choice, options: ['Family', 'Partner', 'Friend', 'Colleague', 'Mentor', 'Client', 'Neighbour', 'Stranger', 'Online contact']),
          FieldDef('mode', 'Mode', FieldType.choice, options: ['In person', 'Call', 'Video', 'Message', 'Email', 'Social media', 'Group']),
          FieldDef('duration', 'Duration', FieldType.number, unit: 'min'),
          FieldDef('initiated', 'Started by', FieldType.choice, options: ['Me', 'Them', 'Mutual']),
          FieldDef('topic', 'Topic', FieldType.text),
          FieldDef('what_happened', 'What happened', FieldType.multiline),
          FieldDef('quality', 'Interaction quality', FieldType.rating),
          FieldDef('effect', 'Effect on me', FieldType.choice, options: ['Charged', 'Neutral', 'Drained']),
          FieldDef('follow_up', 'Follow-up needed', FieldType.text),
        ],
      ),
      GroupDef(
        id: 'connection', title: 'Connection & care', storageKey: 'social',
        fields: [
          FieldDef('in_person', 'In-person interaction (who and what)', FieldType.text),
          FieldDef('non_person', 'Call, message or online interaction', FieldType.text),
          FieldDef('social_energy', 'Social energy', FieldType.choice, options: ['Charged', 'Neutral', 'Drained']),
          FieldDef('time_alone', 'Time alone', FieldType.number, unit: 'hours'),
          FieldDef('family_time', 'Family time', FieldType.number, unit: 'min'),
          FieldDef('kindness_given', 'Kind thing I did', FieldType.text),
          FieldDef('kindness_received', 'Kind thing I received', FieldType.text),
          FieldDef('support_given', 'Support I gave', FieldType.text),
          FieldDef('support_received', 'Support I received', FieldType.text),
          FieldDef('appreciation', 'Appreciation expressed', FieldType.toggle),
          FieldDef('quality_time', 'Quality time given to someone I care about', FieldType.toggle),
        ],
      ),
      GroupDef(
        id: 'conflicts', title: 'Conflict & boundaries', storageKey: 'social_conflicts', repeatable: true,
        fields: [
          FieldDef('person', 'With whom', FieldType.text),
          FieldDef('cause', 'Cause', FieldType.text),
          FieldDef('my_part', 'My part in it', FieldType.multiline),
          FieldDef('response', 'How I handled it', FieldType.choice, options: ['Calm talk', 'Avoided it', 'Argued', 'Apologised', 'Waited']),
          FieldDef('resolved', 'Resolved?', FieldType.choice, options: ['Yes', 'In progress', 'No']),
          FieldDef('boundary_set', 'Boundary I set', FieldType.text),
          FieldDef('boundary_missed', 'Boundary I missed', FieldType.text),
          FieldDef('apology', 'Apology owed', FieldType.text),
        ],
      ),
    ],
  ),
  ModuleDef(
    id: 'habits', title: 'Habits & Routines',
    subtitle: 'Daily habits, screen use and routines',
    icon: Icons.check_circle_outline_rounded,
    tint: Color(0xFF9AA66B),
    groups: [
      GroupDef(
        id: 'daily_habits', title: 'Daily habit checklist', storageKey: 'habits',
        fields: [
          FieldDef('prayer', 'Prayer completed', FieldType.toggle),
          FieldDef('prayer_count', 'Prayer count', FieldType.number, unit: '/ 5'),
          FieldDef('reading', 'Reading completed', FieldType.toggle),
          FieldDef('reading_minutes', 'Reading time', FieldType.number, unit: 'min'),
          FieldDef('walk', 'Walking or exercise completed', FieldType.toggle),
          FieldDef('walk_minutes', 'Walking or exercise time', FieldType.number, unit: 'min'),
          FieldDef('skill', 'Skill practice completed', FieldType.toggle),
          FieldDef('skill_minutes', 'Skill practice time', FieldType.number, unit: 'min'),
          FieldDef('gratitude', 'Journal or gratitude', FieldType.toggle),
          FieldDef('screen', 'Screen time under limit', FieldType.toggle),
          FieldDef('stretching', 'Stretching', FieldType.number, unit: 'min'),
          FieldDef('meditation', 'Meditation or breathing', FieldType.number, unit: 'min'),
          FieldDef('sunlight', 'Sunlight', FieldType.number, unit: 'min'),
          FieldDef('no_phone', 'No phone in first hour', FieldType.toggle),
          FieldDef('plan_tomorrow', 'Planned tomorrow', FieldType.toggle),
          FieldDef('tidy', 'Tidied up', FieldType.toggle),
          FieldDef('building', 'Habit I am building this week', FieldType.text),
          FieldDef('breaking', 'Habit I am breaking this week', FieldType.text),
        ],
      ),
      GroupDef(
        id: 'screen_time', title: 'Screen time', storageKey: 'habits_screen',
        fields: [
          FieldDef('total', 'Total screen time', FieldType.number, unit: 'hours'),
          FieldDef('limit', 'Daily limit', FieldType.number, unit: 'hours'),
          FieldDef('pickups', 'Phone pickups', FieldType.number),
          FieldDef('social_media', 'Social media', FieldType.number, unit: 'hours'),
          FieldDef('entertainment', 'Entertainment', FieldType.number, unit: 'hours'),
          FieldDef('productive', 'Productive use', FieldType.number, unit: 'hours'),
          FieldDef('first_screen', 'First screen after waking', FieldType.text),
          FieldDef('last_screen', 'Last screen before bed', FieldType.text),
          FieldDef('late_scroll', 'Late-night scrolling', FieldType.number, unit: 'min'),
          FieldDef('main_app', 'Main app used', FieldType.text),
          FieldDef('urge', 'Urge to scroll', FieldType.rating, worstIsHigh: true),
        ],
      ),
      GroupDef(
        id: 'building', title: 'Habits I am building', storageKey: 'habits_building', repeatable: true,
        fields: [
          FieldDef('habit', 'Habit', FieldType.text),
          FieldDef('why', 'Why it matters', FieldType.text),
          FieldDef('cue', 'Cue or trigger', FieldType.text),
          FieldDef('tiny_version', 'Tiny version completed', FieldType.toggle),
          FieldDef('difficulty', 'Difficulty today', FieldType.rating, worstIsHigh: true),
          FieldDef('reward', 'Reward', FieldType.text),
          FieldDef('missed_reason', 'If missed, why?', FieldType.multiChoice, options: ['Forgot', 'Tired', 'Busy', 'Unmotivated', 'Sick', 'Travel', 'Environment', 'Other']),
        ],
      ),
      GroupDef(
        id: 'breaking', title: 'Habits I am breaking', storageKey: 'habits_breaking', repeatable: true,
        fields: [
          FieldDef('habit', 'Habit', FieldType.text),
          FieldDef('why', 'Why I want to stop', FieldType.text),
          FieldDef('urges', 'Urges today', FieldType.number),
          FieldDef('strongest', 'Strongest urge', FieldType.rating, worstIsHigh: true),
          FieldDef('triggers', 'Triggers', FieldType.multiChoice, options: ['Boredom', 'Stress', 'Tiredness', 'Loneliness', 'Place', 'People', 'Time of day', 'Emotion', 'Other']),
          FieldDef('slips', 'Slips today', FieldType.number),
          FieldDef('instead', 'What I did instead', FieldType.text),
          FieldDef('tomorrow', 'What I will try tomorrow', FieldType.text),
        ],
      ),
      GroupDef(
        id: 'routines', title: 'Routines', storageKey: 'habits_routines',
        fields: [
          FieldDef('morning', 'Morning routine', FieldType.choice, options: ['Done', 'Partly', 'Skipped']),
          FieldDef('evening', 'Evening routine', FieldType.choice, options: ['Done', 'Partly', 'Skipped']),
          FieldDef('bedtime', 'Bedtime routine', FieldType.choice, options: ['Done', 'Partly', 'Skipped']),
          FieldDef('missed_steps', 'Routine steps missed', FieldType.text),
          FieldDef('habit_note', 'Habit observation', FieldType.multiline),
        ],
      ),
    ],
  ),
  ModuleDef(
    id: 'activities', title: 'Activities & Experiences',
    subtitle: 'Events, unexpected changes, small gaps and practice',
    icon: Icons.explore_rounded,
    tint: Color(0xFF6C9BBF),
    groups: [
      GroupDef(
        id: 'major', title: 'Major activities', storageKey: 'activities_major', repeatable: true,
        fields: [
          FieldDef('activity', 'Activity', FieldType.text),
          FieldDef('plan', 'Planned or unplanned', FieldType.choice, options: ['Planned', 'Unplanned']),
          FieldDef('category', 'Category', FieldType.multiChoice, options: ['Work', 'Study', 'Social', 'Family', 'Health', 'Fun', 'Errand', 'Creative', 'Spiritual', 'Travel', 'Other']),
          FieldDef('time', 'Start and end time', FieldType.text, hint: 'e.g. 10:00–11:30'),
          FieldDef('where', 'Where', FieldType.text),
          FieldDef('with_whom', 'With whom', FieldType.text),
          FieldDef('outcome', 'Outcome', FieldType.rating),
          FieldDef('energy', 'Effect on energy', FieldType.choice, options: ['Gave energy', 'Neutral', 'Took energy']),
          FieldDef('worth', 'Worth the time?', FieldType.choice, options: ['Yes', 'Partly', 'No']),
        ],
      ),
      GroupDef(
        id: 'unexpected', title: 'Unexpected events', storageKey: 'activities_unexpected', repeatable: true,
        fields: [
          FieldDef('event', 'What happened', FieldType.text),
          FieldDef('category', 'Category', FieldType.choice, options: ['Health', 'Work', 'Family', 'Money', 'Travel', 'Technology', 'Weather', 'Social', 'Other']),
          FieldDef('cause', 'Cause', FieldType.text),
          FieldDef('time_delta', 'Time lost (-) or gained (+)', FieldType.number, unit: 'min'),
          FieldDef('money_impact', 'Money impact', FieldType.number, unit: '₹'),
          FieldDef('response', 'How I responded', FieldType.multiline),
          FieldDef('mood_effect', 'Effect on mood', FieldType.rating, worstIsHigh: true),
          FieldDef('learned', 'What I learned', FieldType.text),
          FieldDef('different', 'What I would do differently', FieldType.text),
        ],
      ),
      GroupDef(
        id: 'gaps', title: 'Gap-filling activities', storageKey: 'activities_gaps', repeatable: true,
        description: 'Record what happened in short gaps between planned tasks.',
        fields: [
          FieldDef('window', 'Time window', FieldType.text),
          FieldDef('duration', 'Duration', FieldType.number, unit: 'min'),
          FieldDef('what', 'What I did', FieldType.text),
          FieldDef('category', 'Category', FieldType.choice, options: ['Productive', 'Rest', 'Social', 'Digital', 'Errand']),
          FieldDef('helpful', 'How helpful was it?', FieldType.rating),
          FieldDef('trigger', 'What triggered it', FieldType.choice, options: ['Boredom', 'Waiting', 'Tiredness', 'Avoiding a task', 'Habit']),
          FieldDef('alternative', 'What I could do instead', FieldType.text),
        ],
      ),
      GroupDef(
        id: 'training', title: 'Training & development practice', storageKey: 'activities_training', repeatable: true,
        fields: [
          FieldDef('skill', 'Skill', FieldType.text),
          FieldDef('drill', 'Drill or practice', FieldType.text),
          FieldDef('volume', 'Volume (reps, pages or problems)', FieldType.text),
          FieldDef('time', 'Time spent', FieldType.number, unit: 'min'),
          FieldDef('difficulty', 'Difficulty', FieldType.rating, worstIsHigh: true),
          FieldDef('quality', 'Quality or accuracy', FieldType.rating),
          FieldDef('improved', 'What improved', FieldType.text),
          FieldDef('stuck', 'What is still difficult', FieldType.text),
          FieldDef('feedback', 'Feedback received', FieldType.text),
          FieldDef('next', 'Next practice step', FieldType.text),
        ],
      ),
      GroupDef(
        id: 'new_things', title: 'New things I tried', storageKey: 'activities_new_things', repeatable: true,
        fields: [
          FieldDef('what', 'What I tried', FieldType.text),
          FieldDef('category', 'Category', FieldType.choice, options: ['Food', 'Place', 'Activity', 'Tool or app', 'Skill', 'Person', 'Hobby', 'Other']),
          FieldDef('rating', 'How it went', FieldType.rating),
          FieldDef('surprise', 'What surprised me', FieldType.text),
          FieldDef('again', 'Would I do it again?', FieldType.choice, options: ['Yes', 'Maybe', 'No']),
        ],
      ),
      GroupDef(
        id: 'memories', title: 'Things I want to remember', storageKey: 'activities_memories', repeatable: true,
        fields: [
          FieldDef('moment', 'Moment', FieldType.text),
          FieldDef('who', 'Who was there', FieldType.text),
          FieldDef('where', 'Where', FieldType.text),
          FieldDef('why', 'Why it matters', FieldType.multiline),
          FieldDef('feeling', 'How it felt', FieldType.choice, options: emotions),
          FieldDef('favourite', 'Favourite memory', FieldType.toggle),
        ],
      ),
      GroupDef(
        id: 'legacy_activity_notes', title: 'Earlier activity notes', storageKey: 'activities',
        description: 'These fields keep entries from the earlier version of the tracker accessible.',
        fields: [
          FieldDef('major', 'Major activities (earlier log)', FieldType.multiline),
          FieldDef('unexpected', 'Unexpected events (earlier log)', FieldType.multiline),
          FieldDef('gaps', 'Gap-filling activities (earlier log)', FieldType.multiline),
          FieldDef('gap_common', 'Most common gap activity', FieldType.text),
          FieldDef('training', 'Training and practice (earlier log)', FieldType.multiline),
          FieldDef('next_practice', 'Next practice step', FieldType.text),
          FieldDef('new_things', 'New things I tried (earlier log)', FieldType.text),
          FieldDef('memories', 'Things I want to remember (earlier log)', FieldType.multiline),
        ],
      ),
      GroupDef(
        id: 'time_allocation', title: 'Time allocation', storageKey: 'activities_time',
        description: 'Enter approximate hours. Aim for a realistic picture, not perfect precision.',
        fields: [
          FieldDef('sleep', 'Sleep', FieldType.number, unit: 'hours'),
          FieldDef('work', 'Work', FieldType.number, unit: 'hours'),
          FieldDef('study', 'Study', FieldType.number, unit: 'hours'),
          FieldDef('exercise', 'Exercise', FieldType.number, unit: 'hours'),
          FieldDef('meals', 'Meals', FieldType.number, unit: 'hours'),
          FieldDef('social', 'Family and social', FieldType.number, unit: 'hours'),
          FieldDef('rest', 'Rest and leisure', FieldType.number, unit: 'hours'),
          FieldDef('screen', 'Screen and digital', FieldType.number, unit: 'hours'),
          FieldDef('chores', 'Chores and errands', FieldType.number, unit: 'hours'),
          FieldDef('travel', 'Travel or commute', FieldType.number, unit: 'hours'),
          FieldDef('spiritual', 'Prayer or reflection', FieldType.number, unit: 'hours'),
          FieldDef('other', 'Other', FieldType.number, unit: 'hours'),
        ],
      ),
    ],
  ),
];

String fieldStorageKey(GroupDef group, FieldDef field) =>
    '${group.storageKey}.${field.key}';

String repeatStorageKey(GroupDef group) => '${group.storageKey}.entries';

int filledFieldCount(Map<String, dynamic> data, ModuleDef module) {
  var count = 0;
  for (final group in module.groups) {
    if (group.repeatable) {
      final value = data[repeatStorageKey(group)];
      if (value is List) count += value.length;
    } else {
      for (final field in group.fields) {
        final value = data[fieldStorageKey(group, field)];
        if (value != null && value != '' &&
            !(value is List && value.isEmpty)) {
          count++;
        }
      }
    }
  }
  return count;
}

int fieldCount(ModuleDef module) => module.groups.fold<int>(
      0,
      (sum, group) => sum + (group.repeatable ? 1 : group.fields.length),
    );
