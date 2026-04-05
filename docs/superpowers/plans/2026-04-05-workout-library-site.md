# Workout Library Site Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Build a Jekyll GitHub Pages site at `www.gymscript.app` with workout script pages that drive SEO traffic and convert visitors to GymScript app users.

**Architecture:** Plain Jekyll — no theme, no CSS framework. Custom layouts, one CSS file using design tokens, a Ruby plugin for build-time base64 import-link generation. Content in `_workouts/` collection as Markdown with YAML front matter.

**Tech Stack:** Jekyll 4, jekyll-sitemap, Ruby minitest (plugin tests), vanilla CSS (custom properties + media queries), minimal vanilla JS (clipboard copy only).

---

## File Map

| File | Responsibility |
|---|---|
| `Gemfile` | Ruby dependencies |
| `_config.yml` | Site settings, collection, plugins |
| `_plugins/base64_filter.rb` | Liquid `base64_encode` filter (URL-safe, no padding) |
| `tests/test_base64_filter.rb` | Minitest suite for the plugin |
| `_layouts/default.html` | Base HTML: `<head>`, nav, footer, SEO meta |
| `_layouts/workout.html` | Workout page: breadcrumb, script block, import btn, structured data |
| `_layouts/category.html` | Category page: heading, workout card grid |
| `assets/css/main.css` | All styles — dark default, light mode via `prefers-color-scheme` |
| `assets/js/copy-script.js` | Clipboard copy for script block (progressive enhancement) |
| `index.md` | Homepage — hero, featured workouts, GymScript CTA |
| `workouts.md` | `/workouts/` — all categories |
| `strength.md` | `/workouts/strength/` — strength category |
| `hiit.md` | `/workouts/hiit/` — HIIT category |
| `_workouts/strength/push-day-beginner.md` | Sample workout |
| `_workouts/strength/pull-day-beginner.md` | Sample workout |
| `_workouts/hiit/20-min-full-body.md` | Sample workout |
| `CNAME` | Custom domain |

---

## Task 1: Project Foundation

**Files:**
- Create: `Gemfile`
- Create: `_config.yml`

- [ ] **Step 1: Create Gemfile**

```ruby
# Gemfile
source "https://rubygems.org"

gem "jekyll", "~> 4.3"
gem "jekyll-sitemap"

group :test do
  gem "minitest", "~> 5.0"
end
```

- [ ] **Step 2: Create _config.yml**

```yaml
# _config.yml
title: GymScript Workout Library
description: >-
  Free ready-to-run workout scripts for the GymScript app.
  Browse by category, copy a script, and open it directly in the app.
url: https://www.gymscript.app
baseurl: ""

collections:
  workouts:
    output: true
    permalink: /workouts/:path/

defaults:
  - scope:
      path: ""
      type: workouts
    values:
      layout: workout

plugins:
  - jekyll-sitemap

exclude:
  - Gemfile
  - Gemfile.lock
  - tests/
  - vendor/
```

- [ ] **Step 3: Create .gitignore**

```
_site/
.jekyll-cache/
.bundle/
vendor/
```

- [ ] **Step 4: Install dependencies**

```bash
bundle install
```

Expected: Gemfile.lock created, gems installed.

- [ ] **Step 5: Commit**

```bash
git add Gemfile Gemfile.lock _config.yml .gitignore
git commit -m "feat: project foundation — Gemfile, config, gitignore"
```

---

## Task 2: Base64 Plugin (TDD)

**Files:**
- Create: `tests/test_base64_filter.rb`
- Create: `_plugins/base64_filter.rb`

- [ ] **Step 1: Write failing test**

```ruby
# tests/test_base64_filter.rb
require "minitest/autorun"
require "base64"

# Load plugin without Liquid in scope
module Liquid; module Template; def self.register_filter(_); end; end; end unless defined?(Liquid)
require_relative "../_plugins/base64_filter"

class TestBase64Filter < Minitest::Test
  include Jekyll::Base64Filter

  def test_roundtrips_ascii_script
    input = "Bench press 4x8 @ 60kg rest 2min\nOverhead press 3x10 rest 90s"
    encoded = base64_encode(input)
    padded  = encoded + "=" * ((4 - encoded.length % 4) % 4)
    assert_equal input, Base64.urlsafe_decode64(padded)
  end

  def test_output_is_url_safe
    input = "Squat 5x5 @ 100kg rest 3min"
    assert_match(/\A[A-Za-z0-9_-]*\z/, base64_encode(input))
  end

  def test_no_padding_characters
    refute_includes base64_encode("Push-ups 3x15 rest 60s"), "="
  end

  def test_roundtrips_utf8
    input = "Sentadillas 3x10 @ 60kg descanso 2min"
    encoded = base64_encode(input)
    padded  = encoded + "=" * ((4 - encoded.length % 4) % 4)
    assert_equal input, Base64.urlsafe_decode64(padded)
  end

  def test_empty_string
    assert_equal "", base64_encode("")
  end
end
```

- [ ] **Step 2: Run test to verify it fails**

```bash
bundle exec ruby tests/test_base64_filter.rb
```

Expected: `NameError: uninitialized constant Jekyll` or `LoadError`.

- [ ] **Step 3: Write plugin**

```ruby
# _plugins/base64_filter.rb
require "base64"

module Jekyll
  module Base64Filter
    # Encodes a string as URL-safe base64 without padding.
    # Compatible with gymscript's decodeImportedScript (handles - and _ chars).
    def base64_encode(input)
      Base64.urlsafe_encode64(input.to_s, padding: false)
    end
  end
end

Liquid::Template.register_filter(Jekyll::Base64Filter) if defined?(Liquid)
```

- [ ] **Step 4: Run tests to verify they pass**

```bash
bundle exec ruby tests/test_base64_filter.rb
```

Expected:
```
5 runs, 5 assertions, 0 failures, 0 errors, 0 skips
```

- [ ] **Step 5: Commit**

```bash
git add _plugins/base64_filter.rb tests/test_base64_filter.rb
git commit -m "feat: base64 Liquid filter plugin with tests"
```

---

## Task 3: Default Layout

**Files:**
- Create: `_layouts/default.html`

- [ ] **Step 1: Create layout**

```html
<!-- _layouts/default.html -->
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>{% if page.title %}{{ page.title | escape }} | {{ site.title }}{% else %}{{ site.title }}{% endif %}</title>
  <meta name="description" content="{{ page.description | default: site.description | strip_html | escape }}">
  <link rel="canonical" href="{{ page.url | absolute_url }}">
  <meta property="og:title" content="{{ page.title | default: site.title | escape }}">
  <meta property="og:description" content="{{ page.description | default: site.description | strip_html | escape }}">
  <meta property="og:url" content="{{ page.url | absolute_url }}">
  <meta property="og:type" content="website">
  <link rel="stylesheet" href="{{ '/assets/css/main.css' | relative_url }}">
</head>
<body>
  <a href="#main" class="skip-link">Skip to content</a>

  <nav class="site-nav" aria-label="Site navigation">
    <div class="container">
      <a href="{{ '/' | relative_url }}" class="nav-logo">GymScript Workouts</a>
      <ul class="nav-links" role="list">
        <li><a href="{{ '/workouts/' | relative_url }}">Workouts</a></li>
        <li><a href="https://gymscript.app" rel="noopener">Get the App</a></li>
      </ul>
    </div>
  </nav>

  <main id="main">
    {{ content }}
  </main>

  <footer class="site-footer">
    <div class="container">
      <p>Free workouts for the <a href="https://gymscript.app" rel="noopener">GymScript app</a></p>
      <div class="footer-store-links">
        <a href="https://apps.apple.com/app/gymscript/id6751173133" rel="noopener noreferrer">Download on the App Store</a>
        <a href="https://play.google.com/store/apps/details?id=loveboat.gymscript" rel="noopener noreferrer">Get it on Google Play</a>
      </div>
      <p class="footer-copy">&copy; {{ 'now' | date: "%Y" }} GymScript</p>
    </div>
  </footer>
</body>
</html>
```

- [ ] **Step 2: Commit**

```bash
git add _layouts/default.html
git commit -m "feat: default layout with SEO head and nav"
```

---

## Task 4: CSS

**Files:**
- Create: `assets/css/main.css`

- [ ] **Step 1: Create stylesheet**

```css
/* assets/css/main.css */

/* ---- Reset ---- */
*, *::before, *::after { box-sizing: border-box; margin: 0; padding: 0; }
ul[role="list"], ol[role="list"] { list-style: none; }

/* ---- Tokens (dark default) ---- */
:root {
  --bg:            #0b0b0c;
  --surface:       #111217;
  --border:        #2a2a2c;
  --text:          #f9fafb;
  --muted:         #9ca3af;
  --accent:        #7AB8FF;
  --accent-strong: #4C9EFF;

  --font-sans: system-ui, -apple-system, BlinkMacSystemFont, "Segoe UI", sans-serif;
  --font-mono: ui-monospace, SFMono-Regular, Menlo, Monaco, Consolas, monospace;

  --sp-xs:  0.5rem;
  --sp-sm:  0.75rem;
  --sp-md:  1rem;
  --sp-lg:  1.5rem;
  --sp-xl:  2rem;
  --sp-2xl: 3rem;

  --radius:    0.75rem;
  --radius-sm: 0.5rem;
}

/* ---- Light mode ---- */
@media (prefers-color-scheme: light) {
  :root {
    --bg:            #f9fafb;
    --surface:       #ffffff;
    --border:        #e5e7eb;
    --text:          #111217;
    --muted:         #6b7280;
    --accent:        #1d6fc4;
    --accent-strong: #1558a8;
  }
}

/* ---- Base ---- */
html { color-scheme: dark light; }
body {
  background: var(--bg);
  color: var(--text);
  font-family: var(--font-sans);
  font-size: clamp(1rem, 0.95rem + 0.25vw, 1.125rem);
  line-height: 1.65;
  min-height: 100vh;
  display: flex;
  flex-direction: column;
}

/* ---- Skip link ---- */
.skip-link {
  position: absolute;
  top: -4rem;
  left: var(--sp-md);
  background: var(--accent);
  color: var(--bg);
  padding: 0.5em 1em;
  border-radius: var(--radius-sm);
  font-weight: 700;
  text-decoration: none;
  z-index: 100;
  transition: top 0.15s;
}
.skip-link:focus { top: var(--sp-md); }

/* ---- Focus ---- */
a:focus-visible,
button:focus-visible {
  outline: 2px solid var(--accent);
  outline-offset: 3px;
  border-radius: 3px;
}

/* ---- Links ---- */
a { color: var(--accent); }

/* ---- Container ---- */
.container {
  max-width: 720px;
  margin: 0 auto;
  padding: 0 var(--sp-lg);
}

/* ---- Nav ---- */
.site-nav {
  border-bottom: 1px solid var(--border);
  padding: var(--sp-md) 0;
}
.site-nav .container {
  display: flex;
  align-items: center;
  justify-content: space-between;
  gap: var(--sp-md);
}
.nav-logo {
  font-weight: 800;
  font-size: 1rem;
  color: var(--text);
  text-decoration: none;
  letter-spacing: -0.01em;
  flex-shrink: 0;
}
.nav-logo:hover,
.nav-logo:focus-visible { color: var(--accent); }
.nav-links {
  display: flex;
  gap: var(--sp-lg);
  list-style: none;
}
.nav-links a {
  color: var(--muted);
  text-decoration: none;
  font-size: 0.9rem;
  transition: color 0.15s;
}
.nav-links a:hover,
.nav-links a:focus-visible { color: var(--text); }

/* ---- Main ---- */
main { flex: 1; padding: var(--sp-2xl) 0; }

/* ---- Footer ---- */
.site-footer {
  border-top: 1px solid var(--border);
  padding: var(--sp-xl) 0;
  font-size: 0.875rem;
  color: var(--muted);
}
.site-footer .container {
  display: flex;
  flex-direction: column;
  align-items: center;
  gap: var(--sp-sm);
  text-align: center;
}
.site-footer a {
  color: var(--muted);
  text-decoration: underline;
}
.site-footer a:hover,
.site-footer a:focus-visible { color: var(--text); }
.footer-store-links {
  display: flex;
  gap: var(--sp-lg);
  flex-wrap: wrap;
  justify-content: center;
}
.footer-copy { color: var(--border); }

/* ---- Typography ---- */
h1 {
  font-size: clamp(1.75rem, 1.4rem + 1.5vw, 2.5rem);
  font-weight: 800;
  line-height: 1.1;
  letter-spacing: -0.025em;
}
h2 {
  font-size: clamp(1.2rem, 1rem + 0.8vw, 1.6rem);
  font-weight: 700;
  line-height: 1.2;
  letter-spacing: -0.015em;
}
h3 {
  font-size: clamp(0.95rem, 0.85rem + 0.4vw, 1.15rem);
  font-weight: 700;
  line-height: 1.3;
}
p { max-width: 65ch; }

/* ---- Badges ---- */
.badge {
  display: inline-block;
  padding: 0.2em 0.65em;
  border-radius: 999px;
  font-size: 0.72rem;
  font-weight: 600;
  background: var(--surface);
  border: 1px solid var(--border);
  color: var(--muted);
  text-transform: capitalize;
  letter-spacing: 0.03em;
  white-space: nowrap;
}
.badge--accent {
  background: color-mix(in srgb, var(--accent) 15%, transparent);
  border-color: color-mix(in srgb, var(--accent) 35%, transparent);
  color: var(--accent);
}

/* ---- Buttons ---- */
.btn {
  display: inline-flex;
  align-items: center;
  justify-content: center;
  padding: 0.65em 1.25em;
  border-radius: var(--radius-sm);
  font-family: var(--font-sans);
  font-size: 0.95rem;
  font-weight: 600;
  text-decoration: none;
  cursor: pointer;
  border: 1px solid transparent;
  line-height: 1;
  transition: background 0.15s, border-color 0.15s, color 0.15s, transform 0.1s;
  white-space: nowrap;
}
.btn:active { transform: scale(0.97); }

.btn--primary {
  background: var(--accent);
  color: #0b0b0c;
  border-color: var(--accent);
  width: 100%;
  padding: 0.9em 1.5em;
  font-size: 1rem;
  border-radius: var(--radius);
  margin-bottom: var(--sp-md);
}
.btn--primary:hover,
.btn--primary:focus-visible {
  background: var(--accent-strong);
  border-color: var(--accent-strong);
}

.btn--ghost {
  background: transparent;
  color: var(--muted);
  border-color: var(--border);
  font-size: 0.78rem;
  padding: 0.35em 0.75em;
}
.btn--ghost:hover,
.btn--ghost:focus-visible {
  color: var(--text);
  border-color: var(--muted);
}

.btn--store {
  background: var(--surface);
  color: var(--text);
  border-color: var(--border);
  flex: 1;
  min-width: 130px;
}
.btn--store:hover,
.btn--store:focus-visible {
  border-color: var(--accent);
  color: var(--accent);
}

/* ---- Breadcrumb ---- */
.breadcrumb { margin-bottom: var(--sp-xl); }
.breadcrumb ol {
  display: flex;
  flex-wrap: wrap;
  gap: 0.2em 0;
  list-style: none;
  font-size: 0.82rem;
  color: var(--muted);
}
.breadcrumb li + li::before {
  content: " / ";
  white-space: pre;
  opacity: 0.45;
}
.breadcrumb a {
  color: var(--muted);
  text-decoration: none;
}
.breadcrumb a:hover,
.breadcrumb a:focus-visible { color: var(--text); }
.breadcrumb [aria-current="page"] { color: var(--text); }

/* ---- Workout page ---- */
.workout-header { margin-bottom: var(--sp-lg); }
.workout-header h1 { margin-bottom: var(--sp-sm); }
.workout-meta {
  display: flex;
  flex-wrap: wrap;
  gap: var(--sp-xs);
}
.workout-description {
  color: var(--muted);
  font-size: 1.05rem;
  line-height: 1.7;
  margin-bottom: var(--sp-xl);
}

/* ---- Script block ---- */
.script-block {
  background: var(--surface);
  border: 1px solid var(--border);
  border-radius: var(--radius);
  overflow: hidden;
  margin-bottom: var(--sp-lg);
}
.script-block__header {
  display: flex;
  align-items: center;
  justify-content: space-between;
  padding: var(--sp-sm) var(--sp-md);
  border-bottom: 1px solid var(--border);
  gap: var(--sp-sm);
}
.script-block__label {
  font-size: 0.7rem;
  text-transform: uppercase;
  letter-spacing: 0.07em;
  color: var(--muted);
  font-weight: 700;
}
.script-block pre {
  margin: 0;
  padding: var(--sp-lg);
  font-family: var(--font-mono);
  font-size: clamp(0.85rem, 0.8rem + 0.2vw, 0.95rem);
  line-height: 1.75;
  color: var(--text);
  white-space: pre-wrap;
  word-break: break-word;
}

/* ---- Download prompt ---- */
.download-prompt {
  background: var(--surface);
  border: 1px solid var(--border);
  border-radius: var(--radius);
  padding: var(--sp-lg);
  margin-bottom: var(--sp-xl);
  text-align: center;
}
.download-prompt p {
  color: var(--muted);
  margin: 0 auto var(--sp-md);
  font-size: 0.95rem;
  max-width: none;
}
.download-prompt__links {
  display: flex;
  gap: var(--sp-sm);
  justify-content: center;
  flex-wrap: wrap;
}

/* ---- Back link ---- */
.back-link {
  display: inline-block;
  color: var(--muted);
  text-decoration: none;
  font-size: 0.875rem;
}
.back-link:hover,
.back-link:focus-visible { color: var(--text); }

/* ---- Workout card grid ---- */
.workout-grid {
  display: grid;
  gap: var(--sp-md);
  grid-template-columns: 1fr;
  list-style: none;
  margin-bottom: var(--sp-xl);
}
@media (min-width: 520px) {
  .workout-grid { grid-template-columns: 1fr 1fr; }
}
.workout-card {
  background: var(--surface);
  border: 1px solid var(--border);
  border-radius: var(--radius);
  transition: border-color 0.15s;
}
.workout-card:hover,
.workout-card:focus-within { border-color: var(--accent); }
.workout-card a {
  display: flex;
  flex-direction: column;
  gap: var(--sp-xs);
  padding: var(--sp-lg);
  text-decoration: none;
  color: inherit;
  height: 100%;
}
.workout-card a:focus-visible { outline: none; }
.workout-card__title {
  color: var(--text);
  font-size: 0.95rem;
}
.workout-card__desc {
  font-size: 0.85rem;
  color: var(--muted);
  line-height: 1.5;
  max-width: none;
  flex: 1;
}
.workout-card__meta {
  display: flex;
  flex-wrap: wrap;
  gap: 0.4em;
  margin-top: var(--sp-xs);
}

/* ---- Category page ---- */
.category-header { margin-bottom: var(--sp-xl); }
.category-header h1 { margin-bottom: var(--sp-sm); }
.category-description {
  color: var(--muted);
  font-size: 1.05rem;
  max-width: 55ch;
}

/* ---- Workouts index ---- */
.category-list { display: flex; flex-direction: column; gap: var(--sp-2xl); }
.category-section h2 { margin-bottom: var(--sp-lg); }
.view-all {
  display: inline-block;
  margin-top: var(--sp-xs);
  color: var(--muted);
  font-size: 0.875rem;
  text-decoration: none;
}
.view-all:hover,
.view-all:focus-visible { color: var(--accent); }

/* ---- Homepage hero ---- */
.hero {
  text-align: center;
  padding: var(--sp-2xl) 0;
  margin-bottom: var(--sp-2xl);
}
.hero h1 { margin-bottom: var(--sp-md); }
.hero p {
  font-size: 1.1rem;
  color: var(--muted);
  margin: 0 auto var(--sp-xl);
  max-width: 48ch;
}
.hero-cta {
  display: flex;
  gap: var(--sp-sm);
  justify-content: center;
  flex-wrap: wrap;
}
.hero-cta .btn {
  min-width: 160px;
  width: auto;
}

.section-heading {
  font-size: 0.75rem;
  font-weight: 700;
  text-transform: uppercase;
  letter-spacing: 0.07em;
  color: var(--muted);
  margin-bottom: var(--sp-lg);
}

/* ---- GymScript about block ---- */
.about-gymscript {
  background: var(--surface);
  border: 1px solid var(--border);
  border-radius: var(--radius);
  padding: var(--sp-xl);
  margin-top: var(--sp-2xl);
  text-align: center;
}
.about-gymscript h2 { margin-bottom: var(--sp-sm); }
.about-gymscript p {
  color: var(--muted);
  margin: 0 auto var(--sp-lg);
  max-width: 48ch;
}
.about-gymscript__links {
  display: flex;
  gap: var(--sp-sm);
  justify-content: center;
  flex-wrap: wrap;
}
```

- [ ] **Step 2: Commit**

```bash
git add assets/css/main.css
git commit -m "feat: complete stylesheet with dark/light mode"
```

---

## Task 5: Workout Layout

**Files:**
- Create: `_layouts/workout.html`

- [ ] **Step 1: Create layout**

```html
<!-- _layouts/workout.html -->
---
layout: default
---
<div class="container">
  <nav aria-label="Breadcrumb" class="breadcrumb">
    <ol>
      <li><a href="{{ '/' | relative_url }}">Home</a></li>
      <li><a href="{{ '/workouts/' | relative_url }}">Workouts</a></li>
      <li><a href="{{ '/workouts/' | relative_url }}{{ page.category }}/">{{ page.category_label }}</a></li>
      <li><span aria-current="page">{{ page.title }}</span></li>
    </ol>
  </nav>

  <article>
    <header class="workout-header">
      <h1>{{ page.title }}</h1>
      <div class="workout-meta" role="list" aria-label="Workout details">
        <span class="badge badge--accent" role="listitem">{{ page.category_label }}</span>
        {% if page.duration %}<span class="badge" role="listitem">{{ page.duration }}</span>{% endif %}
        {% if page.difficulty %}<span class="badge" role="listitem">{{ page.difficulty }}</span>{% endif %}
      </div>
    </header>

    <p class="workout-description">{{ page.description }}</p>

    <section class="script-block" role="region" aria-label="Workout script">
      <div class="script-block__header">
        <span class="script-block__label">Workout Script</span>
        <button class="btn btn--ghost" data-copy-script aria-label="Copy workout script to clipboard">Copy</button>
      </div>
      <pre data-workout-script>{{ page.script | strip | escape }}</pre>
    </section>

    {% assign encoded_script = page.script | strip | base64_encode %}
    <a href="https://gymscript.app/import?script={{ encoded_script }}"
       class="btn btn--primary"
       rel="noopener"
       aria-label="Open this workout in the GymScript app">
      Open in GymScript
    </a>

    <div class="download-prompt">
      <p>Don&rsquo;t have GymScript? It&rsquo;s free on iOS &amp; Android.</p>
      <div class="download-prompt__links">
        <a href="https://apps.apple.com/app/gymscript/id6751173133"
           class="btn btn--store"
           rel="noopener noreferrer">App Store</a>
        <a href="https://play.google.com/store/apps/details?id=loveboat.gymscript"
           class="btn btn--store"
           rel="noopener noreferrer">Google Play</a>
      </div>
    </div>

    <a href="{{ '/workouts/' | relative_url }}{{ page.category }}/" class="back-link">&larr; Back to {{ page.category_label }}</a>
  </article>

  {% if page.exercises %}
  <script type="application/ld+json">
  {
    "@context": "https://schema.org",
    "@type": "HowTo",
    "name": "{{ page.title | escape }} Workout",
    "description": "{{ page.description | escape }}",
    "step": [
      {% for exercise in page.exercises %}
      {"@type": "HowToStep", "name": "{{ exercise | escape }}"}{% unless forloop.last %},{% endunless %}
      {% endfor %}
    ]
  }
  </script>
  {% endif %}
</div>
<script src="{{ '/assets/js/copy-script.js' | relative_url }}" defer></script>
```

- [ ] **Step 2: Commit**

```bash
git add _layouts/workout.html
git commit -m "feat: workout layout with import link and structured data"
```

---

## Task 6: Category Layout

**Files:**
- Create: `_layouts/category.html`

- [ ] **Step 1: Create layout**

```html
<!-- _layouts/category.html -->
---
layout: default
---
<div class="container">
  <nav aria-label="Breadcrumb" class="breadcrumb">
    <ol>
      <li><a href="{{ '/' | relative_url }}">Home</a></li>
      <li><a href="{{ '/workouts/' | relative_url }}">Workouts</a></li>
      <li><span aria-current="page">{{ page.title }}</span></li>
    </ol>
  </nav>

  <header class="category-header">
    <h1>{{ page.title }}</h1>
    {% if page.description %}
    <p class="category-description">{{ page.description }}</p>
    {% endif %}
  </header>

  {% assign workouts = site.workouts | where: "category", page.slug | sort: "title" %}
  {% if workouts.size > 0 %}
  <ul class="workout-grid" role="list">
    {% for workout in workouts %}
    <li class="workout-card">
      <a href="{{ workout.url | relative_url }}">
        <h2 class="workout-card__title">{{ workout.title }}</h2>
        <p class="workout-card__desc">{{ workout.description }}</p>
        <div class="workout-card__meta">
          {% if workout.duration %}<span class="badge">{{ workout.duration }}</span>{% endif %}
          {% if workout.difficulty %}<span class="badge">{{ workout.difficulty }}</span>{% endif %}
        </div>
      </a>
    </li>
    {% endfor %}
  </ul>
  {% else %}
  <p style="color: var(--muted);">No workouts yet in this category.</p>
  {% endif %}
</div>
```

- [ ] **Step 2: Commit**

```bash
git add _layouts/category.html
git commit -m "feat: category layout"
```

---

## Task 7: Homepage

**Files:**
- Create: `index.md`

- [ ] **Step 1: Create homepage**

```markdown
---
layout: default
title: GymScript Workout Library
description: >-
  Free ready-to-run workout scripts for GymScript. Browse by category,
  copy a script, and open it directly in the app.
permalink: /
---

<div class="container">
  <section class="hero">
    <h1>Ready-to-run workouts for GymScript</h1>
    <p>Browse free workout scripts. One tap opens them directly in the app — sets, reps, and rest timers included.</p>
    <div class="hero-cta">
      <a href="{{ '/workouts/' | relative_url }}" class="btn btn--primary" style="width:auto;">Browse Workouts</a>
      <a href="https://gymscript.app" class="btn btn--ghost" style="padding:0.65em 1.25em;" rel="noopener">Get GymScript</a>
    </div>
  </section>

  <p class="section-heading">Featured Workouts</p>

  {% assign featured = site.workouts | where: "featured", true | sort: "title" %}
  {% if featured.size == 0 %}
    {% assign featured = site.workouts | sort: "title" | limit: 4 %}
  {% endif %}

  <ul class="workout-grid" role="list">
    {% for workout in featured limit: 4 %}
    <li class="workout-card">
      <a href="{{ workout.url | relative_url }}">
        <h2 class="workout-card__title">{{ workout.title }}</h2>
        <p class="workout-card__desc">{{ workout.description }}</p>
        <div class="workout-card__meta">
          <span class="badge badge--accent">{{ workout.category_label }}</span>
          {% if workout.duration %}<span class="badge">{{ workout.duration }}</span>{% endif %}
          {% if workout.difficulty %}<span class="badge">{{ workout.difficulty }}</span>{% endif %}
        </div>
      </a>
    </li>
    {% endfor %}
  </ul>

  <div class="about-gymscript">
    <h2>What is GymScript?</h2>
    <p>Write your workout in plain words — GymScript turns it into sets, reps, and timers. No account needed. Free on iOS and Android.</p>
    <div class="about-gymscript__links">
      <a href="https://apps.apple.com/app/gymscript/id6751173133" class="btn btn--store" rel="noopener noreferrer">App Store</a>
      <a href="https://play.google.com/store/apps/details?id=loveboat.gymscript" class="btn btn--store" rel="noopener noreferrer">Google Play</a>
    </div>
  </div>
</div>
```

- [ ] **Step 2: Commit**

```bash
git add index.md
git commit -m "feat: homepage with hero and featured workouts"
```

---

## Task 8: Sample Workouts

**Files:**
- Create: `_workouts/strength/push-day-beginner.md`
- Create: `_workouts/strength/pull-day-beginner.md`
- Create: `_workouts/hiit/20-min-full-body.md`

- [ ] **Step 1: Create push day workout**

```markdown
---
layout: workout
title: Beginner Push Day
category: strength
category_label: Strength
description: >-
  A beginner-friendly chest, shoulders, and triceps session. Four exercises covering
  all major pushing muscles — takes around 45 minutes including rest periods.
duration: "45 min"
difficulty: Beginner
featured: true
exercises:
  - Bench Press
  - Overhead Press
  - Incline Dumbbell Press
  - Tricep Dips
  - Lateral Raises
script: |
  Bench press 4x8 @ 60kg rest 2min
  Overhead press 3x10 @ 40kg rest 90s
  Incline dumbbell press 3x12 @ 20kg rest 90s
  Tricep dips 3x10 rest 60s
  Lateral raises 3x15 @ 8kg rest 60s
---
```

- [ ] **Step 2: Create pull day workout**

```markdown
---
layout: workout
title: Beginner Pull Day
category: strength
category_label: Strength
description: >-
  A beginner-friendly back and biceps session. Covers vertical and horizontal pulling
  patterns plus arms — takes around 45 minutes including rest periods.
duration: "45 min"
difficulty: Beginner
featured: true
exercises:
  - Barbell Row
  - Pull-Ups
  - Face Pulls
  - Bicep Curls
  - Hammer Curls
script: |
  Barbell row 4x8 @ 60kg rest 2min
  Pull-ups 3x6 rest 2min
  Face pulls 3x15 @ 20kg rest 60s
  Bicep curls 3x12 @ 15kg rest 60s
  Hammer curls 3x12 @ 15kg rest 60s
---
```

- [ ] **Step 3: Create HIIT workout**

```markdown
---
layout: workout
title: 20-Min Full Body HIIT
category: hiit
category_label: HIIT
description: >-
  Five bodyweight exercises in timed sets — no equipment needed. Work 45 seconds,
  rest 15 seconds, repeat for four rounds. Under 20 minutes total.
duration: "20 min"
difficulty: Intermediate
featured: true
exercises:
  - Burpees
  - Jump Squats
  - Push-Ups
  - Mountain Climbers
  - High Knees
script: |
  Burpees 4x45s rest 15s
  Jump squats 4x40s rest 20s
  Push-ups 4x45s rest 15s
  Mountain climbers 4x45s rest 15s
  High knees 4x45s rest 15s
---
```

- [ ] **Step 4: Commit**

```bash
git add _workouts/
git commit -m "feat: add 3 sample workouts (push, pull, HIIT)"
```

---

## Task 9: Index and Category Pages

**Files:**
- Create: `workouts.md`
- Create: `strength.md`
- Create: `hiit.md`

- [ ] **Step 1: Create workouts index**

```markdown
---
layout: default
title: All Workouts
description: >-
  Free workout scripts for GymScript, organised by training type.
  Browse strength, HIIT, cardio, and more.
permalink: /workouts/
---

<div class="container">
  <h1>Workouts</h1>
  <p style="color:var(--muted);margin-bottom:var(--sp-2xl);max-width:55ch;">
    Browse ready-to-run workout scripts. Tap any workout to see the script and open it directly in GymScript.
  </p>

  <div class="category-list">
    {% assign strength_workouts = site.workouts | where: "category", "strength" | sort: "title" %}
    {% if strength_workouts.size > 0 %}
    <section class="category-section">
      <h2>Strength</h2>
      <ul class="workout-grid" role="list">
        {% for workout in strength_workouts limit: 4 %}
        <li class="workout-card">
          <a href="{{ workout.url | relative_url }}">
            <h3 class="workout-card__title">{{ workout.title }}</h3>
            <p class="workout-card__desc">{{ workout.description }}</p>
            <div class="workout-card__meta">
              {% if workout.duration %}<span class="badge">{{ workout.duration }}</span>{% endif %}
              {% if workout.difficulty %}<span class="badge">{{ workout.difficulty }}</span>{% endif %}
            </div>
          </a>
        </li>
        {% endfor %}
      </ul>
      {% if strength_workouts.size > 4 %}
      <a href="{{ '/workouts/strength/' | relative_url }}" class="view-all">View all Strength workouts &rarr;</a>
      {% endif %}
    </section>
    {% endif %}

    {% assign hiit_workouts = site.workouts | where: "category", "hiit" | sort: "title" %}
    {% if hiit_workouts.size > 0 %}
    <section class="category-section">
      <h2>HIIT</h2>
      <ul class="workout-grid" role="list">
        {% for workout in hiit_workouts limit: 4 %}
        <li class="workout-card">
          <a href="{{ workout.url | relative_url }}">
            <h3 class="workout-card__title">{{ workout.title }}</h3>
            <p class="workout-card__desc">{{ workout.description }}</p>
            <div class="workout-card__meta">
              {% if workout.duration %}<span class="badge">{{ workout.duration }}</span>{% endif %}
              {% if workout.difficulty %}<span class="badge">{{ workout.difficulty }}</span>{% endif %}
            </div>
          </a>
        </li>
        {% endfor %}
      </ul>
      {% if hiit_workouts.size > 4 %}
      <a href="{{ '/workouts/hiit/' | relative_url }}" class="view-all">View all HIIT workouts &rarr;</a>
      {% endif %}
    </section>
    {% endif %}
  </div>
</div>
```

- [ ] **Step 2: Create strength category page**

```markdown
---
layout: category
title: Strength Workouts
slug: strength
description: >-
  Barbell and dumbbell programmes for building muscle and strength.
  Copy any script into GymScript and follow sets, reps, and rest timers.
permalink: /workouts/strength/
---
```

- [ ] **Step 3: Create HIIT category page**

```markdown
---
layout: category
title: HIIT Workouts
slug: hiit
description: >-
  High-intensity interval sessions you can do anywhere — no equipment needed.
  GymScript handles the countdown timers so you can focus on the work.
permalink: /workouts/hiit/
---
```

- [ ] **Step 4: Commit**

```bash
git add workouts.md strength.md hiit.md
git commit -m "feat: workouts index and category pages"
```

---

## Task 10: Copy Script JS

**Files:**
- Create: `assets/js/copy-script.js`

- [ ] **Step 1: Create script**

```javascript
// assets/js/copy-script.js
// Progressive enhancement — clipboard copy for the workout script block.
(function () {
  var btn = document.querySelector("[data-copy-script]");
  var pre = document.querySelector("[data-workout-script]");

  if (!btn || !pre || !navigator.clipboard) return;

  btn.addEventListener("click", function () {
    navigator.clipboard.writeText(pre.textContent).then(function () {
      var original = btn.textContent;
      btn.textContent = "Copied!";
      btn.setAttribute("aria-label", "Script copied to clipboard");
      setTimeout(function () {
        btn.textContent = original;
        btn.setAttribute("aria-label", "Copy workout script to clipboard");
      }, 2000);
    });
  });
}());
```

- [ ] **Step 2: Commit**

```bash
git add assets/js/copy-script.js
git commit -m "feat: clipboard copy button for script block"
```

---

## Task 11: Custom Domain

**Files:**
- Create: `CNAME`

- [ ] **Step 1: Create CNAME file**

```
www.gymscript.app
```

(File contains only that one line, no trailing newline required.)

- [ ] **Step 2: Commit**

```bash
git add CNAME
git commit -m "feat: CNAME for www.gymscript.app"
```

---

## Task 12: Build Verification

- [ ] **Step 1: Run full build**

```bash
bundle exec jekyll build
```

Expected: `_site/` generated with no errors. Should see entries like:
```
Generating...
  Jekyll Feed: Generating feed for posts
                    done in X seconds.
```

- [ ] **Step 2: Check generated URLs**

```bash
ls _site/workouts/
```

Expected:
```
hiit/
strength/
```

```bash
ls _site/workouts/strength/
```

Expected:
```
index.html          (strength category page)
push-day-beginner/
pull-day-beginner/
```

- [ ] **Step 3: Verify import link in built HTML**

```bash
grep "gymscript.app/import?script=" _site/workouts/strength/push-day-beginner/index.html
```

Expected: one line containing `href="https://gymscript.app/import?script=` followed by a URL-safe base64 string (only `A-Za-z0-9_-` chars, no `=`).

- [ ] **Step 4: Verify the encoded script round-trips correctly**

Extract the base64 value from the grep above and run:

```bash
ruby -e '
require "base64"
encoded = "PASTE_VALUE_HERE"
padded = encoded + "=" * ((4 - encoded.length % 4) % 4)
puts Base64.urlsafe_decode64(padded)
'
```

Expected output: the workout script text from `_workouts/strength/push-day-beginner.md`.

- [ ] **Step 5: Commit**

No new files — just confirm the build is clean. If any errors appeared in Step 1, fix them before this step.

```bash
git status
```

Expected: `nothing to commit, working tree clean`
