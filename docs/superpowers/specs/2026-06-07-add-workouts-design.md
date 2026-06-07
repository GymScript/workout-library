# Add Workouts — Design Spec
Date: 2026-06-07

## Goal

Expand the workout library from 14 to 30 pages across 4 categories to improve SEO surface area. Quality-first: each page targets a real search query with a distinct, useful description.

## New Categories

| Slug | URL | Category Label |
|------|-----|----------------|
| `mobility` | `/mobility/` | Mobility |
| `bodyweight` | `/bodyweight/` | Bodyweight |

Each requires: `_pages/<slug>.md` (layout: category) + `_workouts/<slug>/` directory.

## Script Format

- Strength: `Exercise NxR @ moderate weight rest Tmin` (load-agnostic for new files)
- Bodyweight: `Exercise NxR rest Ts` (no weight)
- HIIT/Mobility: `Exercise NxTs rest Ts` (timed holds/intervals)

## Workouts — Mobility (5)

| File | Title | Duration | Difficulty | Search intent |
|------|-------|----------|------------|---------------|
| `morning-full-body-stretch.md` | Morning Full-Body Stretch | 15 min | Beginner | morning stretch routine |
| `hip-flexor-glute-release.md` | Hip Flexor & Glute Release | 20 min | Beginner | hip flexor stretch routine |
| `upper-back-shoulder-opener.md` | Upper Back & Shoulder Opener | 20 min | Beginner | desk posture stretch |
| `post-workout-cooldown.md` | Post-Workout Cooldown | 15 min | Beginner | cooldown routine after gym |
| `deep-flexibility-flow.md` | Deep Flexibility Flow | 30 min | Intermediate | full body flexibility workout |

## Workouts — Bodyweight (5)

| File | Title | Duration | Difficulty |
|------|-------|----------|------------|
| `beginner-full-body.md` | Beginner Bodyweight Full-Body | 30 min | Beginner |
| `push-up-progression.md` | Push-Up Progression | 25 min | Beginner |
| `pull-up-dip-strength.md` | Pull-Up & Dip Strength | 35 min | Intermediate |
| `bodyweight-leg-day.md` | Bodyweight Leg Day | 30 min | Intermediate |
| `advanced-calisthenics.md` | Advanced Calisthenics | 40 min | Advanced |

## Workouts — Strength additions (3, load-agnostic)

| File | Title | Duration | Difficulty |
|------|-------|----------|------------|
| `deadlift-focus.md` | Deadlift Focus | 50 min | Intermediate |
| `overhead-press-day.md` | Overhead Press Day | 45 min | Intermediate |
| `beginner-full-body-barbell.md` | Beginner Full-Body Barbell | 45 min | Beginner |

## Workouts — HIIT additions (3)

| File | Title | Duration | Difficulty |
|------|-------|----------|------------|
| `beginner-hiit-foundations.md` | Beginner HIIT Foundations | 20 min | Beginner |
| `upper-body-hiit-circuit.md` | Upper Body HIIT Circuit | 20 min | Intermediate |
| `jump-rope-intervals.md` | Jump Rope Intervals | 25 min | Intermediate |

## Constraints

- Descriptions: 1–2 sentences, specific about exercises, duration, who it's for
- No invented specific kg loads on new strength workouts
- Mobility scripts use `NxTs` timed-hold syntax (same as HIIT), confirmed viable from existing HIIT files
- No template changes required — category discovery is dynamic via `site.pages | where: "layout", "category"`
