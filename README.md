# Workout Library

Static Jekyll site serving ready-to-use workout scripts at [www.gymscript.app](https://www.gymscript.app). Each page targets a search keyword, presents a copyable workout script, and links directly into the GymScript app via a deep-link import button.

## Stack

- Jekyll (no theme, no CSS framework)
- GitHub Actions → GitHub Pages
- Custom Ruby plugin for build-time base64 encoding of import links

## Local Development

```bash
bundle install
bundle exec jekyll serve
```

Site runs at `http://localhost:4000`.

## Deployment

Push to `main` — GitHub Actions builds and deploys automatically.

## Structure

```
_workouts/          workout content (Jekyll collection)
_layouts/           page templates
_plugins/           base64_filter.rb for import link generation
assets/             CSS and JS
pages/              homepage, category index pages
_config.yml
```

## Adding a Workout

Create a Markdown file in `_workouts/<category>/`:

```yaml
---
layout: workout
title: "Beginner Push Day"
category: strength
category_label: "Strength"
description: "..."
duration: "45 min"
difficulty: Beginner
exercises:
  - Bench Press
  - Overhead Press
script: |
  Bench press 4x8 @ 60kg rest 2min
  Overhead press 3x10 rest 90s
---
```
