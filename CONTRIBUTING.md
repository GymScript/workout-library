# Contributing Workouts

The easiest way to contribute is to add a workout. Each workout is a single Markdown file — no coding required.

## How to add a workout

1. Fork this repository
2. Create a file in `_workouts/<category>/your-workout-name.md`
3. Use the template below
4. Open a pull request

## Template

```markdown
---
title: "Beginner Pull Day"
category: strength
category_label: Strength
description: >-
  One or two sentences describing the workout. This appears in search results
  and on the workout card, so make it useful.
duration: "45 min"
difficulty: Beginner
exercises:
  - Barbell Row
  - Pull-Ups
  - Bicep Curls
script: |
  Barbell row 4x8 @ 60kg rest 2min
  Pull-ups 3x6 rest 2min
  Bicep curls 3x12 @ 15kg rest 60s
---
```

## Script format

Each line is one exercise:

```
<exercise name> <sets>x<reps> @ <weight> rest <time>
```

Weight and rest are optional. Time can be in seconds (`60s`) or minutes (`2min`). The script is passed directly to GymScript, which parses it into sets, reps, and timers.

## Categories

Current categories: `strength`, `hiit`. To add a new category, create a `_pages/<slug>.md` alongside your workout — see the existing category pages for the required front matter.

## Guidelines

- Make sure the workout actually works — ideally one you've done yourself
- Keep the script concise; one exercise per line
