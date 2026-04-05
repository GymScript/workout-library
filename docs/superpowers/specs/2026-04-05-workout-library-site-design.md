# Workout Library — GitHub Pages Site Design

**Date:** 2026-04-05
**Status:** Approved

---

## Overview

A Jekyll-based GitHub Pages site at `www.gymscript.app` containing ready-to-use workout scripts. Each page targets search keywords (e.g. "beginner push day workout"), presents a copyable script, and converts visitors into GymScript app users via an "Open in GymScript" deep-link button.

---

## Architecture

Plain Jekyll — no theme gem, no CSS framework. Custom layouts, a single CSS file, and a custom Ruby plugin for build-time base64 encoding. Content managed via Jekyll collections.

**File structure:**

```
_workouts/
  strength/
    push-day-beginner.md
  hiit/
    20-min-full-body.md
_layouts/
  default.html       # base: <head>, <nav>, <footer>
  workout.html       # extends default, workout page structure
  category.html      # extends default, lists workouts in a category
_plugins/
  base64_filter.rb   # adds {{ script | base64_encode }} Liquid filter
pages/
  index.md           # homepage — /
  workouts.md        # /workouts/ — all categories
assets/
  css/main.css
  js/copy-script.js  # clipboard copy for the script block only
_config.yml
Gemfile
```

**`_config.yml` key settings:**
- `url: https://www.gymscript.app`
- `collections: { workouts: { output: true, permalink: /workouts/:path/ } }`
- `plugins: [jekyll-sitemap]`

Note: `_plugins/` runs at build time via GitHub Actions (`bundle exec jekyll build`). GitHub Pages' native builder uses safe mode (no custom plugins), but the existing Actions workflow bypasses this.

---

## Content Model

Each workout is a Markdown file with YAML front matter:

```yaml
---
layout: workout
title: "Beginner Push Day"
category: strength
category_label: "Strength"
description: "Chest, shoulders, and triceps — 4 exercises, ~45 min. Great starting point for upper body pushing strength."
duration: "45 min"
difficulty: Beginner
exercises:
  - Bench Press
  - Overhead Press
  - Incline Dumbbell Press
  - Tricep Dips
script: |
  Bench press 4x8 @ 60kg rest 2min
  Overhead press 3x10 rest 90s
  Incline dumbbell press 3x12 rest 90s
  Tricep dips 3x10 rest 60s
---
```

The `script` field is both the visible SEO content and the source for the import link URL. The `exercises` list is used for `HowTo` structured data steps.

**Multi-language (future):** Front matter will gain a `lang` field (default `en`). Translated workout files live alongside English ones with the same slug. URL structure becomes `/workouts/<lang>/<category>/<slug>/` when `lang != en`, keeping `/workouts/<category>/<slug>/` for English to avoid breaking existing URLs.

---

## URL Structure

```
/                                        homepage
/workouts/                               all categories
/workouts/strength/                      strength category
/workouts/strength/push-day-beginner/    individual workout (English)
/workouts/hiit/20-min-full-body/         individual workout (English)
```

Future localised URLs (non-breaking addition):
```
/workouts/es/strength/push-day-beginner/
/workouts/fr/hiit/20-min-full-body/
```

Categories (strength, hiit, cardio, flexibility) are derived from the `category` front matter field. Each category requires a hand-authored Markdown file in `pages/` (e.g. `pages/strength.md`) using the `category.html` layout — Jekyll does not auto-generate these.

---

## Page Layouts

### Homepage (`index.md`)
- Hero: one-line pitch ("Ready-to-run workouts for GymScript"), "Browse Workouts" CTA
- Featured workout cards (3–4), linking to individual workout pages
- Brief explanation of GymScript with App Store / Play Store links

### Category page
- `<h1>` category name + short description
- Responsive grid of workout cards: title, description, duration badge, difficulty badge
- Each card links to the workout page

### Workout page
1. Breadcrumb: Home → Strength → Push Day Beginner
2. `<h1>` title + meta row (category badge, duration, difficulty)
3. Description paragraph (SEO prose)
4. Script block: monospace inset, "Copy script" button (`copy-script.js`, clipboard API)
5. "Open in GymScript" primary button — `href` pre-rendered at build time: `https://gymscript.app/import?script={{ page.script | base64_encode | url_encode }}`
6. Download prompt: "Don't have GymScript? Free on iOS & Android" → App Store / Play Store links
7. Back link to category page

---

## Import Link — Build-Time Generation

`_plugins/base64_filter.rb` adds a `base64_encode` Liquid filter:

```ruby
require "base64"

module Jekyll
  module Base64Filter
    def base64_encode(input)
      Base64.strict_encode64(input.to_s)
    end
  end
end

Liquid::Template.register_filter(Jekyll::Base64Filter)
```

Usage in `workout.html` layout:
```liquid
{% assign encoded = page.script | base64_encode | url_encode %}
<a href="https://gymscript.app/import?script={{ encoded }}">Open in GymScript</a>
```

This produces a fully resolved `href` in the static HTML — no JavaScript required for the import button. The encoding matches `encodeScriptForLink` in gymscript's `src/lib/linkImport.ts` (`Base64.strict_encode64` = standard base64, which `decodeImportedScript` handles).

`copy-script.js` remains for the clipboard copy button only (progressive enhancement — the script text is visible and selectable without JS).

---

## Visual Design

Dark palette matching GymScript's web UI:

| Token | Value |
|---|---|
| `--bg` | `#0b0b0c` |
| `--surface` | `#111217` |
| `--border` | `#2a2a2c` |
| `--text` | `#f9fafb` |
| `--muted` | `#9ca3af` |
| `--accent` | `#7AB8FF` |

- Fluid type: `clamp()` for headings and body, no hard pixel breakpoints for font sizes
- Max content width: `720px`, centred
- Responsive grid on category pages: single column on mobile, 2-col on wider viewports
- Dark default; light mode via `@media (prefers-color-scheme: light)` overriding CSS custom properties — no JS required
- No images required for MVP

---

## SEO

### Per-page `<head>`
- `<title>`: `{{ page.title }} Workout | GymScript Workout Library`
- `<meta name="description">`: `{{ page.description }}`
- `<link rel="canonical" href="{{ page.url | absolute_url }}">`
- Open Graph: `og:title`, `og:description`, `og:url`, `og:type: website`

### Structured Data (workout pages)
`HowTo` JSON-LD: name = workout title, step = each item in `exercises` front matter list. Signals structured workout content to Google.

### Sitemap
`jekyll-sitemap` gem auto-generates `/sitemap.xml`. All canonical URLs use `https://www.gymscript.app`.

### Internal linking
- Homepage links to all category pages
- Category pages link to all workouts in that category
- Each workout links back to its category (breadcrumb)

### Cross-linking to gymscript.app
- Import button `href` is a do-follow link to `gymscript.app`
- App Store / Play Store CTAs also link out to `gymscript.app`

---

## Accessibility

- Semantic HTML: `<main>`, `<article>`, `<nav>`, `<footer>`, correct heading hierarchy per page
- All interactive elements (buttons, links) keyboard-navigable
- Visible focus rings (`outline` not suppressed)
- Colour contrast ≥ 4.5:1 for all text/bg combinations
- `aria-label` on icon-only buttons (e.g. Copy)
- `role="region"` + `aria-label` on the script block
- `lang="en"` on `<html>` (updated to match `page.lang` when multi-language ships)

---

## Dependencies

| Gem | Purpose |
|---|---|
| `jekyll` | Static site builder |
| `jekyll-sitemap` | Auto-generates sitemap.xml |

No npm, no build pipeline beyond the existing GitHub Actions workflow.

---

## Out of Scope (this phase)

- Exercise library pages (planned for later as part of "Option C")
- Multi-language workout content (structure planned above, implementation deferred)
- Search / filtering on the category page
- User-submitted workouts
- Analytics
