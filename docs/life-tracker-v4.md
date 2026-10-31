# Daily Life Tracker (v4) — App Structure

Structure for the Android app. Each section lists its fields, input type, and options. Dates, totals, streaks and averages are calculated by the app (marked **auto**). Every field except Date is optional and can be skipped.

---

## 0. Conventions

**Field types**

| Type | Meaning |
|---|---|
| text | Short free text |
| long text | Multi-line note (voice input allowed) |
| number | Whole or decimal number, unit shown |
| scale | 1-10 chips or slider |
| yes/no | Toggle |
| time / date | Picker |
| duration | Minutes (app can display hh:mm) |
| single / multi | Chips: pick one / pick many |
| repeat | Entry group, add as many rows as needed |
| link | Reference to a master-data item or another entry |
| auto | Calculated or filled by the app, not typed |

**Scale direction:** 10 = best, except stress, anxiety, pain, mental fatigue, urge strength, intrusiveness and difficulty, where 10 = worst or strongest. These are labelled "(10 = worst)".

**Shared option sets**

| Set | Options |
|---|---|
| SEVERITY | none, mild, moderate, strong |
| PART OF DAY | morning, afternoon, evening, night |
| LIFE AREA | health, mind, work, learning, money, relationships, family, spiritual, home, fun, other |
| EMOTIONS | calm, happy, grateful, hopeful, motivated, content, excited, proud, loved, tired, bored, restless, anxious, worried, sad, lonely, irritable, angry, frustrated, overwhelmed, guilty, ashamed, numb |
| STRESS CAUSES | workload, deadlines, money, health, relationships, family, uncertainty about the future, lack of sleep, conflict, noise or environment, too many decisions, social pressure, self-expectations, news or social media, other |
| TASK STATUS | todo, doing, done, moved to later, waiting, dropped |

**Every section also has:** Notes (long text), Tags (multi), and optional photo or voice-note attachment.

---

## 1. Daily Log

| Field | Type | Options / notes |
|---|---|---|
| Date | date | auto = today, editable |
| Day | auto | Day of week |
| Location(s) today | multi | home, office, outdoors, travel, other |
| Weather | single | sunny, cloudy, rainy, hot, cold, humid, stormy |
| Type of day | multi | work, study, rest, travel, social, family, errands, sick or recovery, holiday or day off, event |
| Special occasion or event | text | Birthday, appointment, deadline, etc. |
| Day focus or intention (morning) | text | |
| How I want to feel today | single | EMOTIONS |
| Overall day rating | scale | 1-10 |
| Day in one word | text | |

**Top 3 priorities** (repeat, max 3)

| Field | Type | Options / notes |
|---|---|---|
| Priority | text | |
| Linked goal | link | Goals master list |
| Result | single | done, partly done, not done |
| If not done, why | single | ran out of time, low energy, blocked, unclear, distracted, deprioritized, unexpected event, avoided |

**End-of-day reflection**

| Field | Type | Options / notes |
|---|---|---|
| What I did today | long text | |
| Biggest win | text | |
| Biggest drain | text | |
| Biggest mistake or regret | text | |
| What went well | long text | |
| What did not go well | long text | |
| What I would do differently | long text | |
| Lesson of the day | text | |

**Tomorrow**

| Field | Type | Options / notes |
|---|---|---|
| First task for tomorrow | text | |
| Top priority for tomorrow | text | |
| Preparation done | multi | clothes ready, bag ready, schedule checked, alarm set, tasks planned, meals planned |
| Log completion | auto | Sections filled today |

---

## 2. Health & Body

### 2a. Sleep

| Field | Type | Options / notes |
|---|---|---|
| Target bedtime | time | From targets in master data |
| Target wake time | time | From targets in master data |
| Screens off at | time | |
| Last meal at | time | |
| Last caffeine at | time | |
| Went to bed at | time | |
| Slept by target time | auto | yes/no from bedtime |
| Time to fall asleep | duration | minutes |
| Woke up at | time | |
| Woke by | single | alarm, naturally, disturbed |
| Snooze count | number | |
| Total sleep | auto | hours, after fall-asleep time and wake-ups |
| Sleep debt vs target | auto | hours |
| Activity before sleep | multi | screen, reading, prayer, walk, work, talking, meal, exercise, shower, meditation, nothing |
| Sleep environment | multi | dark, quiet, cool, comfortable, noise, light, too hot, too cold |
| Sleep aids | multi | none, music, supplement, medicine, other |
| Dreams | single | none, pleasant, neutral, disturbing |
| Grogginess on waking | single | SEVERITY |
| Energy on waking | scale | 1-10 |
| Sleep quality | scale | 1-10 |

**Wake-ups during the night** (repeat)

| Field | Type | Options / notes |
|---|---|---|
| Time | time | |
| Duration | duration | minutes |
| Reason | single | bathroom, noise, thoughts, pain, heat or cold, thirst, hunger, bad dream, unknown, other |

**Naps** (repeat)

| Field | Type | Options / notes |
|---|---|---|
| Start time | time | |
| Duration | duration | minutes |
| Felt after | single | refreshed, neutral, groggier |

### 2b. Meals & Intake

**Meals** (repeat)

| Field | Type | Options / notes |
|---|---|---|
| Meal type | single | breakfast, lunch, dinner, snack, drink only |
| Time | time | |
| What I ate | text | Pick from foods list or type |
| Portion | single | small, normal, large |
| Source | single | home-cooked, restaurant, packaged, delivery |
| Healthy | single | yes, partly, no |
| Eaten how | multi | sitting, on a screen, rushed, with others, alone |
| Reason for eating | single | hunger, habit, boredom, stress, social, craving |
| Hunger before | scale | 1-10 |
| Fullness after | scale | 1-10 |
| Photo | attachment | optional |

**Daily intake summary**

| Field | Type | Options / notes |
|---|---|---|
| Healthy meals (out of 3) | auto | From the Healthy field |
| Skipped meals | multi | breakfast, lunch, dinner |
| Hunger and fullness overall | single | normal, low, high |
| Longest gap between meals | auto | hours |
| Late-night eating | yes/no | |
| Fasting today | yes/no | Type and hours if yes |
| Cravings | multi | sweet, salty, fried, caffeine, other |
| Fibre, fruit or vegetables | number | servings |
| Protein | number | servings |
| Processed or fast food | number | count |
| Fried or oily food | number | count |
| Sugary snacks or desserts | number | count |

**Hydration and drinks**

| Field | Type | Options / notes |
|---|---|---|
| Water | number | liters |
| Water target met | auto | From targets |
| Other drinks | repeat | type (tea, coffee, juice, soda, energy drink, milk, other) and count |
| Total caffeine | auto | cups |
| Sugary drinks | number | count |

**Supplements and probiotics** (repeat)

| Field | Type | Options / notes |
|---|---|---|
| Name | link | Medicines and supplements master list |
| Dose | text | |
| Time | time | |
| Taken | yes/no | |

**Other intake** (optional, off by default)

| Field | Type | Options / notes |
|---|---|---|
| Tobacco, alcohol or other | repeat | type, amount, time |

### 2c. Gut Health

**Bowel movements** (repeat)

| Field | Type | Options / notes |
|---|---|---|
| Time | time | |
| Consistency | single | Bristol type 1-7, or normal, hard, loose, mixed |
| Colour | single | normal brown, light, dark, green, other |
| Ease | single | easy, mild effort, straining |
| Emptying | single | complete, incomplete |
| Urgency | single | none, mild, urgent |
| Pain during | single | SEVERITY |
| Blood or mucus seen | single | none, blood, mucus, both |

**Daily gut summary**

| Field | Type | Options / notes |
|---|---|---|
| Bowel movement count | auto | |
| Days since last bowel movement | auto | |
| Overall gut comfort | scale | 1-10 |

**Gut symptoms** (repeat)

| Field | Type | Options / notes |
|---|---|---|
| Symptom | single | bloating, gas, acidity or heartburn, reflux, stomach pain or cramps, nausea, vomiting, belching, loose motion, constipation, appetite loss, early fullness, other |
| Severity | single | SEVERITY |
| Where | multi | upper, middle, lower, left, right, all over |
| Started at | time | |
| Lasted | duration | minutes |
| Linked meal | link | Meals logged today |
| Suspected trigger | text | |
| What helped | multi | walking, warm water, medicine, rest, nothing |

**Food observations**

| Field | Type | Options / notes |
|---|---|---|
| Discomfort after meals | repeat | which meal, minutes after, how long |
| Foods that seemed to cause a problem | repeat | food, symptom |
| Foods that felt good | repeat | food |

**Urine and hydration check**

| Field | Type | Options / notes |
|---|---|---|
| Urination count | number | |
| Colour | single | clear, light yellow, dark yellow, brown or red |
| Burning or pain | yes/no | |
| Night trips | number | |

> App note: if blood in stool, black stool, severe or worsening pain, repeated vomiting, trouble swallowing or unexplained weight loss is logged, show a gentle prompt to consider medical advice.

### 2d. Movement

**Exercise sessions** (repeat)

| Field | Type | Options / notes |
|---|---|---|
| Type | single | walk, run, gym, yoga, stretching, cycling, swimming, sport, home workout, other |
| Start time | time | |
| Duration | duration | minutes |
| Intensity | scale | 1-10 |
| Distance | number | km |
| Where | single | indoors, outdoors |
| Felt after | single | energised, okay, drained, sore |

**Daily movement summary**

| Field | Type | Options / notes |
|---|---|---|
| Steps | number | |
| Active minutes | auto | |
| Sitting hours | number | |
| Movement breaks | number | count |
| Stretching or mobility | duration | minutes |
| Outdoors or sunlight | duration | minutes |
| Soreness | repeat | body part, severity (1-10, 10 = worst) |
| Rest day | yes/no | |

### 2e. Body & Symptoms

| Field | Type | Options / notes |
|---|---|---|
| Physical energy | scale | Morning, afternoon, evening (1-10 each) |
| Signs of illness today | yes/no | |
| Hygiene and self-care | multi | brushed teeth morning, brushed teeth night, shower, skincare, grooming |
| Side effects noticed | long text | |

**Symptoms** (repeat)

| Field | Type | Options / notes |
|---|---|---|
| Symptom | single | headache, body pain, joint pain, back or neck pain, eye strain, sore throat, cough, cold or runny nose, fever, dizziness, chest discomfort, shortness of breath, palpitations, skin issue, swelling, fatigue, other |
| Where | text | |
| Severity | scale | 1-10 (10 = worst) |
| Started at | time | |
| How long | duration | minutes or hours |
| Suspected trigger | text | |
| What helped | text | |

> App note: for chest discomfort, shortness of breath, fainting or a severe sudden headache, show a prompt to seek urgent medical care.

**Vitals** (optional, if measured)

| Field | Type | Options / notes |
|---|---|---|
| Weight | number | kg |
| Blood pressure | number | systolic / diastolic |
| Resting heart rate | number | bpm |
| Temperature | number | |
| Oxygen saturation | number | % |
| Blood sugar | number | value, unit, timing (fasting or after meal) |
| Time measured | time | |

**Medicines** (repeat)

| Field | Type | Options / notes |
|---|---|---|
| Name | link | Medicines and supplements master list |
| Dose | text | |
| Scheduled time | time | |
| Taken at | time | |
| Status | single | taken, late, missed, skipped on purpose |
| Reason if missed | text | |

**Medical follow-ups**

| Field | Type | Options / notes |
|---|---|---|
| Appointment | repeat | date, doctor or place, reason |
| Test pending or result due | repeat | test, date |
| Refill due | date | |
| Questions to ask the doctor | repeat | text |

**Cycle tracking** (optional module, enable only if applicable)

| Field | Type | Options / notes |
|---|---|---|
| Cycle day | number | |
| Flow | single | none, light, medium, heavy |
| Related symptoms | multi | cramps, mood changes, fatigue, headache, bloating, other |

---

## 3. Mind & Mood

### 3a. Mood check-ins (repeat, up to 4 a day)

| Field | Type | Options / notes |
|---|---|---|
| Part of day | single | PART OF DAY |
| Mood | scale | 1-10 |
| Emotions | multi | EMOTIONS |
| What influenced it | multi | sleep, food, people, work, news, weather, thoughts, health, nothing clear |

### 3b. Daily mind summary

| Field | Type | Options / notes |
|---|---|---|
| Overall mood | scale | 1-10 |
| Happiness | scale | 1-10 |
| Calm | scale | 1-10 |
| Motivation | scale | 1-10 |
| Confidence | scale | 1-10 |
| Sense of purpose | scale | 1-10 |
| Loneliness | scale | 1-10 (10 = worst) |
| Irritability | single | SEVERITY |
| Self-talk | single | kind, neutral, harsh |

### 3c. Energy & Mental Fatigue

| Field | Type | Options / notes |
|---|---|---|
| Mental energy | scale | Morning, afternoon, evening (1-10 each) |
| Mental fatigue | scale | 1-10 (10 = worst) |
| Fatigue peaked at | single | PART OF DAY |
| Likely causes | multi | poor sleep, long focus without breaks, too many decisions, multitasking, screen overload, emotional strain, noise, meetings, hunger or dehydration, no clear task, other |
| Brain fog | single | SEVERITY |
| Focus and clarity | scale | 1-10 |
| Longest focus stretch | duration | minutes |
| What restored me | multi | break, walk, nap, food or water, music, talking, nothing |

### 3d. Anxiety

| Field | Type | Options / notes |
|---|---|---|
| Anxiety level | scale | 1-10 (10 = worst) |
| Peaked at | single | PART OF DAY |
| Trigger or situation | text | |
| Topic | multi | STRESS CAUSES |
| Body signs | multi | fast heartbeat, tight chest, shallow breathing, shaking, sweating, stomach upset, muscle tension, restlessness, dry mouth, dizziness |
| Thought patterns | multi | overthinking, worst-case thinking, replaying the past, fear of the future, self-criticism, comparing with others, need for certainty, avoidance |
| How long it lasted | duration | minutes |
| What I did | multi | breathing, walk, prayer, talked to someone, music, writing, distraction, avoided it, nothing |
| Did it help | scale | 1-10 |
| Something I avoided because of it | text | |

### 3e. Stress

| Field | Type | Options / notes |
|---|---|---|
| Stress level | scale | 1-10 (10 = worst) |
| Causes | multi | STRESS CAUSES |
| Main source | text | |
| How much is in my control | single | in my control, partly, not in my control |
| Stress signs | multi | tension, headache, irritability, poor focus, low appetite, overeating, sleep trouble, snapping at people, procrastinating |
| One step to reduce it | text | |
| Recovered by evening | single | yes, partly, no |

### 3f. Calming practices

| Field | Type | Options / notes |
|---|---|---|
| Practices done | multi | breathing, meditation, prayer, walk, music, nature, journaling, talking to someone, stretching, nap, shower, none |
| Minutes spent | duration | |

### 3g. Positives & Reflection

| Field | Type | Options / notes |
|---|---|---|
| Something that made me smile | text | |
| Something that drained me | text | |
| Gratitude | repeat | up to 3 |
| Something I am proud of | text | |
| What I need more of or less of tomorrow | text | |
| Short journal | long text | |

> App note: if mood is 3 or lower, or anxiety is 8 or higher, for 3 days in a row, show a gentle prompt suggesting talking to a trusted person or a professional.

---

## 4. Ideaverse

One place to capture everything in your head, sort it, and connect it. Every entry can link to goals, projects, tasks, people, learnings, and other entries, which is what makes it a "verse" instead of a list.

**Capture:** a quick-add button opens a blank entry. Type, voice note, or photo first, and classify later.

### 4a. Idea of the Day (one pinned per day)

| Field | Type | Options / notes |
|---|---|---|
| Idea | link | Pick from today's Idea Inbox, or type new |
| Why this one | text | |
| Potential | scale | 1-10 |
| First small step | text | |

### 4b. Idea Inbox (repeat)

| Field | Type | Options / notes |
|---|---|---|
| Title | text | |
| Details | long text | |
| Category | single | business, app or tech, career, creative, health, money, relationships, learning, lifestyle, fun or random, other |
| Where it came from | single | own mind, conversation, book, video, social media, dream, walking, work, other |
| Problem it solves | text | |
| Excitement | scale | 1-10 |
| Effort | scale | 1-10 (10 = hardest) |
| Mood when captured | single | EMOTIONS |
| Status | single | new, exploring, planned, in progress, done, parked, dropped |
| Next small action | text | Can be turned into a task |
| Review date | date | |
| Linked goal or project | link | |
| Related ideas | link | Multiple |
| Captured at | auto | |

### 4c. Major Thoughts & Realizations (repeat)

| Field | Type | Options / notes |
|---|---|---|
| Thought | long text | |
| Type | single | insight, belief, decision, realization, fear, value, principle, perspective shift |
| What triggered it | text | |
| Life area | single | LIFE AREA |
| Importance | scale | 1-10 |
| How sure I am | scale | 1-10 |
| Changes what I will do | yes/no | If yes, what |
| Save as a personal principle | yes/no | Adds to Principles list |

### 4d. Thoughts Stuck in Mind (repeat)

| Field | Type | Options / notes |
|---|---|---|
| Thought | long text | |
| Theme | single | worry, regret, plan, replaying a conversation, fear, desire, question, unfinished task, other |
| Times it came back today | number | |
| Intensity | scale | 1-10 (10 = strongest) |
| When it shows up | multi | idle time, bedtime, after scrolling, during work, while eating, alone, with people |
| Feeling linked to it | single | EMOTIONS |
| What might be behind it | text | Need, fear, unfinished task, etc. |
| Is there an action I can take | yes/no | If yes, what |
| How I handled it | single | wrote it down, took action, talked to someone, distracted myself, let it go, ignored it, still stuck |
| Status | single | active, easing, resolved |
| Days running | auto | |

### 4e. New Things I Learned (repeat)

| Field | Type | Options / notes |
|---|---|---|
| What I learned | text | |
| In one line (teach-back) | text | |
| Topic or field | text | |
| Type | single | fact, concept, skill, tip, lesson from a mistake, perspective |
| Source | single | book, article, video, course, person, experience, mistake, other |
| Understanding | scale | 1-10 |
| How I will use it | text | |
| Linked skill | link | |
| Revisit | single | tomorrow, in 3 days, in a week, in a month, never |

### 4f. Questions & Curiosities (repeat)

| Field | Type | Options / notes |
|---|---|---|
| Question | text | |
| Why it matters | text | |
| Where to look | text | |
| Status | single | open, researching, answered |
| Answer | long text | |

### 4g. Quotes & Snippets (repeat)

| Field | Type | Options / notes |
|---|---|---|
| Text | long text | |
| Source | text | |
| Why it hit me | text | |

### 4h. Brain Dump

| Field | Type | Options / notes |
|---|---|---|
| Unsorted notes | long text | Free space, sort later |
| Sort into | single | idea, thought, task, question, learning, nothing |

### 4i. Ideaverse summary

| Field | Type | Options / notes |
|---|---|---|
| Entries captured today | auto | By type |
| Ideas still new after 7 days | auto | Surfaced for review: act, park, or drop |
| Stuck thoughts still active | auto | |
| Revisits due today | auto | From learnings |

---

## 5. Work & Learning

### 5a. Tasks (repeat)

| Field | Type | Options / notes |
|---|---|---|
| Task | text | |
| Group | single | must do today, should do, nice to have, waiting on others, recurring, backlog |
| Category | single | work, study, career, personal, health, money or admin, home, errands, social, creative |
| Priority | single | high, medium, low |
| Linked goal or project | link | |
| Due date | date | |
| Estimated time | duration | minutes |
| Actual time | duration | minutes |
| Energy needed | single | high, medium, low |
| Where | single | home, office, computer, phone, outside, anywhere |
| Status | single | TASK STATUS |
| Waiting on | link | People |
| If not done, why | single | ran out of time, low energy, blocked, unclear, distracted, deprioritized, avoided, interrupted |
| Repeats | single | no, daily, weekly, monthly |
| Subtasks | repeat | checklist items |
| Reminder | time | |

**Task totals (auto):** planned, completed, moved, dropped, completion rate.

### 5b. Focus sessions (repeat)

| Field | Type | Options / notes |
|---|---|---|
| Start and end time | time | |
| Task | link | |
| Type | single | deep work, shallow or admin, meeting, study, creative, learning |
| Focus quality | scale | 1-10 |
| Distractions | number | count |
| Main distraction | multi | phone, social media, messages, noise, people, browser tabs, my own thoughts, hunger or tiredness, none |
| Break taken | yes/no | |

**Totals (auto):** deep work hours, shallow work hours, meeting hours, most productive time of day.

### 5c. Study & skill practice (repeat)

| Field | Type | Options / notes |
|---|---|---|
| Skill | link | Skills master list |
| Topic | text | |
| Resource | single | book, course, video, article, practice, mentor, other |
| Method | multi | read, watch, practice, teach, take notes, revise, project |
| Time | duration | minutes |
| Understanding | scale | 1-10 |
| Key takeaway | text | |
| Next step | text | |

### 5d. Output & Career

| Field | Type | Options / notes |
|---|---|---|
| What I produced | repeat | item, type (document, code, design, content, decision, client work, other), quantity |
| Career progress today | multi | applications sent, interviews, networking, portfolio work, certification, skill milestone, pay or promotion talk, none |
| Career progress score | scale | 1-10 |
| Career notes | long text | |

### 5e. Goals

**Goal progress** (repeat)

| Field | Type | Options / notes |
|---|---|---|
| Goal | link | Goals master list |
| Moved forward by | scale | 1-10 |
| Progress after today | number | % |
| What moved it | text | |
| Next milestone | text | |
| On track | single | yes, at risk, no |

### 5f. Blockers & Procrastination

**Blockers** (repeat)

| Field | Type | Options / notes |
|---|---|---|
| Blocker | text | |
| Type | single | unclear next step, waiting on someone, missing tool or info, skill gap, low energy, distraction, time, money, fear or doubt, other |
| Action to unblock | text | |
| Who and by when | text | |

**Avoidance**

| Field | Type | Options / notes |
|---|---|---|
| Something I avoided today | text | |
| Why | multi | boring, unclear, scary, tired, perfectionism, no deadline, too big, distracted |

### 5g. Close-out

| Field | Type | Options / notes |
|---|---|---|
| Time wasted (estimate) | duration | minutes |
| Work satisfaction | scale | 1-10 |
| Pending for tomorrow | repeat | text, can carry into tomorrow's tasks |

---

## 6. Money

**Income** (repeat)

| Field | Type | Options / notes |
|---|---|---|
| Source | text | |
| Type | single | salary, freelance or business, gift, refund, interest or dividends, sale, other |
| Amount | number | |
| Account | single | cash, bank, wallet, other |

**Expenses** (repeat)

| Field | Type | Options / notes |
|---|---|---|
| Item | text | |
| Category | single | food, groceries, transport, rent, bills and utilities, health, education, shopping, entertainment, subscriptions, gifts or charity, family, personal care, travel, debt payment, other |
| Amount | number | |
| Payment method | single | cash, debit card, credit card, bank transfer, wallet or UPI, other |
| Need or want | single | need, want |
| Planned or impulse | single | planned, impulse |
| Mood at purchase | single | EMOTIONS |
| For whom | single | me, family, friend, shared, work |
| Recurring | yes/no | |
| Receipt photo | attachment | optional |

**Daily money totals (auto)**

| Field | Type | Options / notes |
|---|---|---|
| Total income | auto | |
| Total spent | auto | |
| Net for the day | auto | |
| Daily budget | auto | From master data |
| Remaining | auto | |
| Impulse total | auto | |
| Spending by category | auto | |
| No-spend day | auto | yes if total spent is zero, can override |

**Saved & invested** (repeat)

| Field | Type | Options / notes |
|---|---|---|
| Type | single | savings, emergency fund, investment, goal fund, retirement, giving |
| Amount | number | |
| Where | text | |

**Bills & subscriptions due in the next 7 days** (auto-pulled)

| Field | Type | Options / notes |
|---|---|---|
| Bill | link | Bills master list |
| Due date | date | |
| Amount | number | |
| Auto-pay | yes/no | |
| Paid | yes/no | |
| Paid on | date | |
| Overdue | auto | |

**Debts & lending** (repeat)

| Field | Type | Options / notes |
|---|---|---|
| Person | link | |
| Direction | single | I owe, owed to me |
| Amount | number | |
| Due date | date | |
| Paid so far | number | |

**Money mindset**

| Field | Type | Options / notes |
|---|---|---|
| Money stress | scale | 1-10 (10 = worst) |
| Financial goal progress | link | Goal and % |
| Big purchase being considered | repeat | item, price, date to decide |
| Money lesson or decision | text | |
| Balance snapshot | number | optional |

---

## 7. Relationships & Social

**Interactions** (repeat)

| Field | Type | Options / notes |
|---|---|---|
| Person | link | People master list |
| Relationship | single | family, partner, friend, colleague, mentor, client, neighbor, stranger, online contact |
| Mode | single | in person, call, video, message, email, social media, group |
| Duration | duration | minutes |
| Started by | single | me, them, mutual |
| Topic | text | |
| What happened | long text | |
| Quality | scale | 1-10 |
| Effect on me | single | charged, neutral, drained |
| Follow-up needed | text | Optional date |

**Day summary**

| Field | Type | Options / notes |
|---|---|---|
| Time with people | auto | hours |
| Time alone | number | hours |
| Social energy | single | charged, neutral, drained |
| Family time | duration | minutes |
| Quality time given to someone I love | yes/no | |

**Giving & receiving**

| Field | Type | Options / notes |
|---|---|---|
| Kind thing I did | text | |
| Kind thing I received | text | |
| Support I gave | text | |
| Support I received | text | |
| Appreciation expressed | yes/no | |

**Conflict & boundaries** (repeat)

| Field | Type | Options / notes |
|---|---|---|
| With whom | link | |
| Cause | text | |
| My part | text | |
| How I handled it | single | calm talk, avoided it, argued, apologized, waited |
| Resolved | single | yes, in progress, no |
| Boundary I set | text | |
| Boundary I missed | text | |
| Apology owed | text | |

**Connection upkeep**

| Field | Type | Options / notes |
|---|---|---|
| People to reach out to | repeat | person, reason, by when |
| Upcoming birthdays or occasions | auto | From People master list |
| Promises I made | repeat | what, to whom, by when |
| Messages pending a reply | repeat | person, topic |

---

## 8. Habits & Routines

### 8a. Daily habit checklist

Each habit comes from the Habits master list. Default set:

| Habit | Type | Options / notes |
|---|---|---|
| Prayer | number | times, plus on time (yes/no) |
| Reading | duration | minutes |
| Walking or exercise | duration | minutes, auto from 2d |
| Water target met | auto | From 2b |
| Screen time under limit | auto | From 8b |
| Skill practice | duration | minutes, auto from 5c |
| Journal or gratitude | yes/no | |
| Slept on time | auto | From 2a |
| Woke on time | auto | From 2a |
| Stretching | duration | minutes |
| Meditation or breathing | duration | minutes |
| Sunlight | duration | minutes |
| No phone in first hour | yes/no | |
| Planned tomorrow | yes/no | |
| Tidied up | yes/no | |
| Other | custom | Add any habit |

### 8b. Screen time

| Field | Type | Options / notes |
|---|---|---|
| Total screen time | number | hours |
| Daily limit | auto | From targets |
| Under limit | auto | |
| Phone pickups | number | |
| Social media | number | hours |
| Entertainment | number | hours |
| Productive use | number | hours |
| First screen after waking | time | |
| Last screen before bed | time | |
| Late-night scrolling | number | minutes |
| Main app today | text | |
| Urge to scroll | scale | 1-10 (10 = strongest) |

### 8c. Habit I am building (repeat)

| Field | Type | Options / notes |
|---|---|---|
| Habit | link | |
| Why it matters | text | |
| Cue or trigger | text | |
| Tiny version done | yes/no | |
| Streak | auto | Current and best |
| Difficulty today | scale | 1-10 (10 = hardest) |
| Reward | text | |
| If missed, why | multi | forgot, tired, busy, unmotivated, sick, travel, environment, other |

### 8d. Habit I am breaking (repeat)

| Field | Type | Options / notes |
|---|---|---|
| Habit | link | |
| Why I want to stop | text | |
| Urges today | number | count |
| Strongest urge | scale | 1-10 (10 = strongest) |
| Triggers | multi | boredom, stress, tiredness, loneliness, a place, certain people, time of day, an emotion, other |
| Slips | number | count |
| What I did instead | text | |
| Days clean | auto | |
| What I will try tomorrow | text | |

### 8e. Routines

| Field | Type | Options / notes |
|---|---|---|
| Morning routine | single | done, partly, skipped |
| Evening routine | single | done, partly, skipped |
| Bedtime routine | single | done, partly, skipped |
| Routine steps missed | text | |

---

## 9. Activities & Experiences

### 9a. Major activities (repeat)

| Field | Type | Options / notes |
|---|---|---|
| Activity | text | |
| Planned or unplanned | single | planned, unplanned |
| Category | multi | work, study, social, family, health, fun, errand, creative, spiritual, travel, other |
| Start and end time | time | Or duration |
| Where | text | |
| With whom | link | |
| Outcome | scale | 1-10 |
| Effect on my energy | single | gave energy, neutral, took energy |
| Worth the time | single | yes, partly, no |

### 9b. Unexpected events (repeat)

| Field | Type | Options / notes |
|---|---|---|
| What happened | text | |
| Category | single | health, work, family, money, travel, tech, weather, social, other |
| Cause | text | |
| Time lost (-) or gained (+) | duration | minutes |
| Money impact | number | |
| How I responded | text | |
| Effect on my mood | scale | 1-10 |
| What I learned | text | |
| What I would do differently | text | |

### 9c. Gap-filling activities (repeat)

| Field | Type | Options / notes |
|---|---|---|
| Time window | time | Start and end |
| Duration | duration | minutes |
| What I did | text | |
| Category | single | productive, rest, social, digital, errand |
| Helpful | scale | 1-10 |
| What triggered it | single | boredom, waiting, tired, avoiding a task, habit |
| What I could do instead | text | |
| Most common gap activity today | auto | |
| Total gap time | auto | minutes |

### 9d. Training & development practice (repeat)

| Field | Type | Options / notes |
|---|---|---|
| Skill | link | Skills master list |
| Drill or practice | text | |
| Volume | number | Reps, pages or problems, with unit |
| Time | duration | minutes |
| Difficulty | scale | 1-10 (10 = hardest) |
| Quality or accuracy | scale | 1-10 |
| What improved | text | |
| What is stuck | text | |
| Feedback received | text | |
| Next practice step | text | |

### 9e. New things I tried (repeat)

| Field | Type | Options / notes |
|---|---|---|
| What | text | |
| Category | single | food, place, activity, tool or app, skill, person, hobby, other |
| How it went | scale | 1-10 |
| What surprised me | text | |
| Would I do it again | single | yes, maybe, no |

### 9f. Things I want to remember (repeat)

| Field | Type | Options / notes |
|---|---|---|
| Moment | text | |
| Who was there | link | |
| Where | text | |
| Why it matters | text | |
| How it felt | single | EMOTIONS |
| Photo | attachment | optional |
| Favourite | yes/no | Shows in a memories view |

### 9g. Time allocation (hours)

| Category | Type | Options / notes |
|---|---|---|
| Sleep | auto | From 2a |
| Work | auto | From 5b |
| Study | auto | From 5c |
| Exercise | auto | From 2d |
| Meals | number | |
| Family and social | auto | From section 7 |
| Rest and leisure | number | |
| Screen and digital | auto | From 8b |
| Chores and errands | number | |
| Travel or commute | number | |
| Prayer or reflection | number | |
| Other | number | |
| Total | auto | Should be about 24, warn if far off |

---

## 10. Master Data (set up once, reused in dropdowns)

| List | Fields |
|---|---|
| Goals | name, life area, why, target date, milestones, status, progress % |
| Projects | name, linked goal, status, next action |
| Skills | name, current level (1-10), target level, resources |
| Habits | name, build or break, tracking type, target, frequency, cue, reminder |
| Medicines and supplements | name, dose, schedule, purpose, prescribed by, refill date |
| Bills and subscriptions | name, amount, due day, frequency, auto-pay |
| Expense categories | name, monthly budget |
| People | name, relationship, birthday, how often I want to be in touch |
| Foods | name, known trigger or safe food |
| Principles | text, date added, from which thought |
| Custom option lists and tags | Add your own chips to any single or multi field |

**Targets and limits**

| Target | Type |
|---|---|
| Bedtime and wake time | time |
| Sleep hours | number |
| Caffeine cutoff time | time |
| Water | liters |
| Steps | number |
| Screen limit | hours |
| Daily budget | number |

---

## 11. App Notes

- Reminders: optional morning intention, midday check-in, evening log, medicine times, bills due, ideas to review.
- Every section can be collapsed, hidden, or turned off in settings.
- Auto fields never overwrite typed values unless the user taps "use calculated".
- Works offline, syncs when online, with local backup and export (CSV or JSON).
- App lock (PIN or fingerprint), because this holds health, money and private thoughts.
- Quick-add buttons for idea, expense, symptom, water and mood, from the home screen and a widget.
- Trends view: any numeric field over time, plus correlations such as sleep vs mood or food vs gut symptoms.
