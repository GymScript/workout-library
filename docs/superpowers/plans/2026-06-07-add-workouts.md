# Add Workouts Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Add 2 new category pages (Mobility, Bodyweight) and 16 workout files to expand the library from 14 to 30 pages.

**Architecture:** Each workout is a Markdown file in `_workouts/<category>/` with YAML front matter. Category pages in `_pages/` are auto-discovered by the site's dynamic category system — no template changes needed. Mobility scripts use timed-hold syntax (`NxTs rest Ts`), identical to HIIT. New strength scripts are load-agnostic (`@ moderate weight`).

**Tech Stack:** Jekyll 4, Liquid, YAML front matter. Build: `/opt/homebrew/opt/ruby/bin/bundle exec jekyll build`

---

### Task 1: Mobility category page

**Files:**
- Create: `_pages/mobility.md`

- [ ] **Create `_pages/mobility.md`**

```markdown
---
layout: category
title: Mobility Workouts
slug: mobility
description: >-
  Stretching and flexibility routines to improve range of motion, reduce
  stiffness, and support recovery. Timed holds load directly into GymScript.
permalink: /mobility/
---
```

- [ ] **Build and verify**

```bash
/opt/homebrew/opt/ruby/bin/bundle exec jekyll build
```

Expected: build succeeds. Check `_site/mobility/index.html` exists and shows "0 workouts" (no workout files yet).

- [ ] **Commit**

```bash
git add _pages/mobility.md
git commit -m "feat: add mobility category page"
```

---

### Task 2: Bodyweight category page

**Files:**
- Create: `_pages/bodyweight.md`

- [ ] **Create `_pages/bodyweight.md`**

```markdown
---
layout: category
title: Bodyweight Workouts
slug: bodyweight
description: >-
  Strength and conditioning with no equipment needed. Push-ups, pull-ups,
  squats, and calisthenics progressions for all levels.
permalink: /bodyweight/
---
```

- [ ] **Build and verify**

```bash
/opt/homebrew/opt/ruby/bin/bundle exec jekyll build
```

Expected: `_site/bodyweight/index.html` exists.

- [ ] **Commit**

```bash
git add _pages/bodyweight.md
git commit -m "feat: add bodyweight category page"
```

---

### Task 3: Mobility workouts (5 files)

**Files:**
- Create: `_workouts/mobility/morning-full-body-stretch.md`
- Create: `_workouts/mobility/hip-flexor-glute-release.md`
- Create: `_workouts/mobility/upper-back-shoulder-opener.md`
- Create: `_workouts/mobility/post-workout-cooldown.md`
- Create: `_workouts/mobility/deep-flexibility-flow.md`

- [ ] **Create `_workouts/mobility/morning-full-body-stretch.md`**

```markdown
---
layout: workout
title: Morning Full-Body Stretch
category: mobility
category_label: Mobility
description: >-
  Wake up stiff joints and loosen tight muscles with this gentle 15-minute
  routine. Seven moves from neck to hips — no equipment, no floor required
  for most. Perfect before coffee or before a workout.
duration: "15 min"
difficulty: Beginner
exercises:
  - Neck Rolls
  - Cat-Cow
  - Thread the Needle
  - Seated Forward Fold
  - Hip Flexor Stretch
  - Supine Twist
  - Child's Pose
script: |
  Neck rolls 2x20s
  Cat-cow 3x30s
  Thread the needle 2x30s rest 5s
  Seated forward fold 3x45s rest 10s
  Hip flexor stretch 3x30s rest 5s
  Supine twist 2x30s rest 5s
  Child's pose 2x45s rest 5s
---
```

- [ ] **Create `_workouts/mobility/hip-flexor-glute-release.md`**

```markdown
---
layout: workout
title: Hip Flexor & Glute Release
category: mobility
category_label: Mobility
description: >-
  Targets the hip flexors, piriformis, and glutes — the muscles most
  compressed by long periods of sitting. Six timed holds, 20 minutes total.
  Ideal after leg day or a long day at a desk.
duration: "20 min"
difficulty: Beginner
exercises:
  - Hip Flexor Lunge Stretch
  - Pigeon Pose
  - Figure Four Stretch
  - Glute Bridge Hold
  - 90-90 Hip Stretch
  - Seated Hip Circles
script: |
  Hip flexor lunge stretch 3x45s rest 10s
  Pigeon pose 3x60s rest 15s
  Figure four stretch 3x45s rest 10s
  Glute bridge hold 3x30s rest 10s
  90-90 hip stretch 3x45s rest 10s
  Seated hip circles 2x30s
---
```

- [ ] **Create `_workouts/mobility/upper-back-shoulder-opener.md`**

```markdown
---
layout: workout
title: Upper Back & Shoulder Opener
category: mobility
category_label: Mobility
description: >-
  Counteracts desk posture with seven moves targeting the thoracic spine,
  chest, and shoulders. 20 minutes of holds and rotations — good before
  an upper body session or after a long day hunched over a screen.
duration: "20 min"
difficulty: Beginner
exercises:
  - Doorway Chest Stretch
  - Thread the Needle
  - Wall Slide
  - Thoracic Rotation
  - Shoulder Cross-Body Stretch
  - Overhead Tricep Stretch
  - Neck Side Stretch
script: |
  Doorway chest stretch 3x30s rest 10s
  Thread the needle 3x30s rest 10s
  Wall slide 3x30s rest 10s
  Thoracic rotation 3x30s rest 10s
  Shoulder cross-body stretch 3x30s rest 10s
  Overhead tricep stretch 2x30s rest 5s
  Neck side stretch 2x20s rest 5s
---
```

- [ ] **Create `_workouts/mobility/post-workout-cooldown.md`**

```markdown
---
layout: workout
title: Post-Workout Cooldown
category: mobility
category_label: Mobility
description: >-
  A structured 15-minute cooldown for after any training session. Works
  through quads, hamstrings, calves, hip flexors, chest, and spine —
  enough to bring heart rate down and reduce next-day soreness.
duration: "15 min"
difficulty: Beginner
exercises:
  - Standing Quad Stretch
  - Seated Hamstring Stretch
  - Calf Stretch
  - Hip Flexor Lunge Stretch
  - Chest Opener
  - Child's Pose
  - Supine Spinal Twist
script: |
  Standing quad stretch 2x30s rest 5s
  Seated hamstring stretch 3x45s rest 10s
  Calf stretch 2x30s rest 5s
  Hip flexor lunge stretch 2x30s rest 5s
  Chest opener 2x30s rest 5s
  Child's pose 3x30s rest 5s
  Supine spinal twist 2x30s rest 5s
---
```

- [ ] **Create `_workouts/mobility/deep-flexibility-flow.md`**

```markdown
---
layout: workout
title: Deep Flexibility Flow
category: mobility
category_label: Mobility
description: >-
  A 30-minute intermediate session for people actively working on flexibility.
  Covers hips, hamstrings, spine, and groin with longer holds and deeper
  positions. Expect some discomfort — not pain.
duration: "30 min"
difficulty: Intermediate
exercises:
  - Sun Salutation Flow
  - Low Lunge with Twist
  - Pigeon Pose
  - Seated Straddle
  - Lizard Pose
  - Frog Stretch
  - Supine Hamstring Stretch
  - Reclined Butterfly
script: |
  Sun salutation flow 3x60s rest 10s
  Low lunge with twist 3x45s rest 10s
  Pigeon pose 4x60s rest 15s
  Seated straddle 3x60s rest 15s
  Lizard pose 3x45s rest 10s
  Frog stretch 3x60s rest 15s
  Supine hamstring stretch 3x45s rest 10s
  Reclined butterfly 3x60s rest 10s
---
```

- [ ] **Build and verify**

```bash
/opt/homebrew/opt/ruby/bin/bundle exec jekyll build
grep "category-count" _site/mobility/index.html
```

Expected: `<p class="category-count">5 workouts</p>`

- [ ] **Commit**

```bash
git add _workouts/mobility/
git commit -m "feat: add 5 mobility workouts"
```

---

### Task 4: Bodyweight workouts (5 files)

**Files:**
- Create: `_workouts/bodyweight/beginner-full-body.md`
- Create: `_workouts/bodyweight/push-up-progression.md`
- Create: `_workouts/bodyweight/pull-up-dip-strength.md`
- Create: `_workouts/bodyweight/bodyweight-leg-day.md`
- Create: `_workouts/bodyweight/advanced-calisthenics.md`

- [ ] **Create `_workouts/bodyweight/beginner-full-body.md`**

```markdown
---
layout: workout
title: Beginner Bodyweight Full-Body
category: bodyweight
category_label: Bodyweight
description: >-
  Six fundamental movements covering the whole body with zero equipment.
  Squats, push-ups, lunges, bridges, and planks — 30 minutes and a good
  starting point if you've never trained before.
duration: "30 min"
difficulty: Beginner
exercises:
  - Bodyweight Squat
  - Push-Ups
  - Reverse Lunges
  - Glute Bridges
  - Plank
  - Mountain Climbers
script: |
  Bodyweight squat 3x12 rest 60s
  Push-ups 3x10 rest 60s
  Reverse lunges 3x10 rest 60s
  Glute bridges 3x15 rest 45s
  Plank 3x20s rest 45s
  Mountain climbers 3x20s rest 45s
---
```

- [ ] **Create `_workouts/bodyweight/push-up-progression.md`**

```markdown
---
layout: workout
title: Push-Up Progression
category: bodyweight
category_label: Bodyweight
description: >-
  A structured push-up programme that works from wall push-ups through to
  diamond push-ups. 25 minutes, six variations — designed to build up
  someone who can't do a standard push-up yet.
duration: "25 min"
difficulty: Beginner
exercises:
  - Wall Push-Ups
  - Incline Push-Ups
  - Standard Push-Ups
  - Wide Push-Ups
  - Diamond Push-Ups
  - Push-Up Hold at Bottom
script: |
  Wall push-ups 3x12 rest 45s
  Incline push-ups 3x10 rest 60s
  Standard push-ups 3x8 rest 60s
  Wide push-ups 3x8 rest 60s
  Diamond push-ups 3x6 rest 60s
  Push-up hold at bottom 3x15s rest 45s
---
```

- [ ] **Create `_workouts/bodyweight/pull-up-dip-strength.md`**

```markdown
---
layout: workout
title: Pull-Up & Dip Strength
category: bodyweight
category_label: Bodyweight
description: >-
  Upper body pulling and pushing with a bar and parallel bars. Starts with
  dead hangs and scapular pulls before moving to full pull-ups, chin-ups,
  and dips. 35 minutes — needs access to a pull-up bar.
duration: "35 min"
difficulty: Intermediate
exercises:
  - Dead Hangs
  - Scapular Pulls
  - Assisted Pull-Ups
  - Pull-Ups
  - Bench Dips
  - Parallel Bar Dips
  - Chin-Ups
script: |
  Dead hangs 3x20s rest 60s
  Scapular pulls 3x8 rest 60s
  Assisted pull-ups 3x6 rest 90s
  Pull-ups 4x5 rest 2min
  Bench dips 3x12 rest 60s
  Parallel bar dips 4x8 rest 90s
  Chin-ups 3x5 rest 90s
---
```

- [ ] **Create `_workouts/bodyweight/bodyweight-leg-day.md`**

```markdown
---
layout: workout
title: Bodyweight Leg Day
category: bodyweight
category_label: Bodyweight
description: >-
  Seven lower-body exercises that load the quads, hamstrings, and glutes
  without a barbell. Jump squats, Bulgarian split squats, single-leg bridges,
  and a wall sit finisher. 30 minutes, intermediate level.
duration: "30 min"
difficulty: Intermediate
exercises:
  - Jump Squats
  - Bulgarian Split Squats
  - Single-Leg Glute Bridges
  - Reverse Lunges
  - Step-Ups
  - Wall Sit
  - Calf Raises
script: |
  Jump squats 4x12 rest 60s
  Bulgarian split squats 4x10 rest 60s
  Single-leg glute bridges 3x12 rest 45s
  Reverse lunges 4x10 rest 60s
  Step-ups 3x12 rest 45s
  Wall sit 3x30s rest 45s
  Calf raises 3x20 rest 30s
---
```

- [ ] **Create `_workouts/bodyweight/advanced-calisthenics.md`**

```markdown
---
layout: workout
title: Advanced Calisthenics
category: bodyweight
category_label: Bodyweight
description: >-
  Skill-based bodyweight training for experienced athletes. Handstands,
  L-sits, muscle-up progressions, pistol squats, and front lever work.
  40 minutes — only attempt this if pull-ups and dips are already easy.
duration: "40 min"
difficulty: Advanced
exercises:
  - L-Sit Holds
  - Handstand Hold
  - Muscle-Up Progressions
  - Pistol Squats
  - Front Lever Tuck Hold
  - Pike Push-Ups
  - Dragon Flags
script: |
  L-sit holds 4x15s rest 60s
  Handstand hold 4x20s rest 2min
  Muscle-up progressions 4x4 rest 2min
  Pistol squats 4x5 rest 90s
  Front lever tuck hold 4x10s rest 90s
  Pike push-ups 4x10 rest 60s
  Dragon flags 4x5 rest 90s
---
```

- [ ] **Build and verify**

```bash
/opt/homebrew/opt/ruby/bin/bundle exec jekyll build
grep "category-count" _site/bodyweight/index.html
```

Expected: `<p class="category-count">5 workouts</p>`

- [ ] **Commit**

```bash
git add _workouts/bodyweight/
git commit -m "feat: add 5 bodyweight workouts"
```

---

### Task 5: Strength additions (3 files)

**Files:**
- Create: `_workouts/strength/deadlift-focus.md`
- Create: `_workouts/strength/overhead-press-day.md`
- Create: `_workouts/strength/beginner-full-body-barbell.md`

- [ ] **Create `_workouts/strength/deadlift-focus.md`**

```markdown
---
layout: workout
title: Deadlift Focus
category: strength
category_label: Strength
description: >-
  Five deadlift variations in one session: Romanian, conventional, sumo,
  stiff-leg, and good mornings. Load-agnostic — use a weight that challenges
  you at the given rep ranges. 50 minutes including full rest periods.
duration: "50 min"
difficulty: Intermediate
exercises:
  - Romanian Deadlift
  - Conventional Deadlift
  - Sumo Deadlift
  - Stiff-Leg Deadlift
  - Good Mornings
script: |
  Romanian deadlift 3x8 @ moderate weight rest 2min
  Conventional deadlift 4x5 @ moderate weight rest 3min
  Sumo deadlift 3x6 @ moderate weight rest 2.5min
  Stiff-leg deadlift 3x10 @ moderate weight rest 2min
  Good mornings 3x10 @ moderate weight rest 90s
---
```

- [ ] **Create `_workouts/strength/overhead-press-day.md`**

```markdown
---
layout: workout
title: Overhead Press Day
category: strength
category_label: Strength
description: >-
  Shoulder-focused session built around the strict press and push press,
  with dumbbell accessory work and face pulls for rear-delt balance.
  45 minutes — good as a standalone shoulder day or the push portion of PPL.
duration: "45 min"
difficulty: Intermediate
exercises:
  - Push Press
  - Strict Overhead Press
  - Dumbbell Shoulder Press
  - Lateral Raises
  - Front Raises
  - Face Pulls
script: |
  Push press 3x5 @ moderate weight rest 2min
  Strict overhead press 4x6 @ moderate weight rest 2min
  Dumbbell shoulder press 3x10 @ moderate weight rest 90s
  Lateral raises 4x12 @ moderate weight rest 60s
  Front raises 3x12 @ moderate weight rest 60s
  Face pulls 3x15 @ moderate weight rest 60s
---
```

- [ ] **Create `_workouts/strength/beginner-full-body-barbell.md`**

```markdown
---
layout: workout
title: Beginner Full-Body Barbell
category: strength
category_label: Strength
description: >-
  Five fundamental barbell movements covering squat, hinge, push, and pull
  patterns. Three sets each, load-agnostic — start light and focus on form.
  45 minutes, suitable for anyone new to barbell training.
duration: "45 min"
difficulty: Beginner
exercises:
  - Goblet Squat
  - Barbell Deadlift
  - Bench Press
  - Barbell Row
  - Overhead Press
script: |
  Goblet squat 3x10 @ moderate weight rest 90s
  Barbell deadlift 3x8 @ moderate weight rest 2min
  Bench press 3x10 @ moderate weight rest 90s
  Barbell row 3x10 @ moderate weight rest 90s
  Overhead press 3x8 @ moderate weight rest 90s
---
```

- [ ] **Build and verify**

```bash
/opt/homebrew/opt/ruby/bin/bundle exec jekyll build
grep "category-count" _site/strength/index.html
```

Expected: `<p class="category-count">12 workouts</p>`

- [ ] **Commit**

```bash
git add _workouts/strength/deadlift-focus.md _workouts/strength/overhead-press-day.md _workouts/strength/beginner-full-body-barbell.md
git commit -m "feat: add 3 strength workouts"
```

---

### Task 6: HIIT additions (3 files)

**Files:**
- Create: `_workouts/hiit/beginner-hiit-foundations.md`
- Create: `_workouts/hiit/upper-body-hiit-circuit.md`
- Create: `_workouts/hiit/jump-rope-intervals.md`

- [ ] **Create `_workouts/hiit/beginner-hiit-foundations.md`**

```markdown
---
layout: workout
title: Beginner HIIT Foundations
category: hiit
category_label: HIIT
description: >-
  Low-impact intervals for people new to HIIT. Five moves, three rounds,
  all bodyweight — longer work periods with proper rest so you can maintain
  form throughout. 20 minutes total.
duration: "20 min"
difficulty: Beginner
exercises:
  - Marching in Place
  - Bodyweight Squat
  - Incline Push-Ups
  - Lateral Steps
  - Glute Bridges
script: |
  Marching in place 3x40s rest 20s
  Bodyweight squat 3x40s rest 20s
  Incline push-ups 3x30s rest 30s
  Lateral steps 3x40s rest 20s
  Glute bridges 3x40s rest 20s
---
```

- [ ] **Create `_workouts/hiit/upper-body-hiit-circuit.md`**

```markdown
---
layout: workout
title: Upper Body HIIT Circuit
category: hiit
category_label: HIIT
description: >-
  Five upper-body moves done as intervals: push-ups, plank shoulder taps,
  tricep dips, mountain climbers, and burpees. Four rounds each, 20 minutes.
  A good option when you want conditioning without running.
duration: "20 min"
difficulty: Intermediate
exercises:
  - Push-Ups
  - Plank Shoulder Taps
  - Tricep Dips
  - Mountain Climbers
  - Burpees
script: |
  Push-ups 4x35s rest 25s
  Plank shoulder taps 4x35s rest 25s
  Tricep dips 4x35s rest 25s
  Mountain climbers 4x35s rest 25s
  Burpees 4x30s rest 30s
---
```

- [ ] **Create `_workouts/hiit/jump-rope-intervals.md`**

```markdown
---
layout: workout
title: Jump Rope Intervals
category: hiit
category_label: HIIT
description: >-
  Structured jump rope conditioning: standard skipping, double unders, sprint
  intervals, and single-leg work. 25 minutes — needs a jump rope. Works
  cardio and coordination at the same time.
duration: "25 min"
difficulty: Intermediate
exercises:
  - Jump Rope
  - Double Unders
  - Jump Rope Sprint
  - Single Leg Jump Rope
script: |
  Jump rope 6x45s rest 15s
  Double unders 4x30s rest 30s
  Jump rope sprint 4x20s rest 40s
  Single leg jump rope 4x20s rest 40s
---
```

- [ ] **Build and verify**

```bash
/opt/homebrew/opt/ruby/bin/bundle exec jekyll build
grep "category-count" _site/hiit/index.html
```

Expected: `<p class="category-count">8 workouts</p>`

- [ ] **Commit**

```bash
git add _workouts/hiit/beginner-hiit-foundations.md _workouts/hiit/upper-body-hiit-circuit.md _workouts/hiit/jump-rope-intervals.md
git commit -m "feat: add 3 HIIT workouts"
```

---

### Task 7: Final verification

- [ ] **Full build**

```bash
/opt/homebrew/opt/ruby/bin/bundle exec jekyll build
```

Expected: succeeds with no errors.

- [ ] **Check sitemap includes all new URLs**

```bash
grep -c "<loc>" _site/sitemap.xml
```

Expected: at least 35 (was 17, adding 18 new pages).

- [ ] **Check nav shows new categories in built HTML**

```bash
grep "mobility\|bodyweight" _site/index.html | head -5
```

Expected: nav links for `/mobility/` and `/bodyweight/` are NOT present (nav only has Strength and HIIT — that's correct, update nav separately if desired).

- [ ] **Spot-check a workout page renders correctly**

```bash
grep "Open in GymScript\|import?script=" _site/mobility/morning-full-body-stretch/index.html | head -2
```

Expected: the import link exists, confirming the base64 filter ran on the mobility script.

- [ ] **Commit spec and plan docs if not yet committed**

```bash
git add docs/
git commit -m "docs: add workout expansion spec and plan"
```
