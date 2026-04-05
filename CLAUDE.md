# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Commands

```bash
bundle install                  # install dependencies
bundle exec jekyll serve        # local dev at http://localhost:4000
bundle exec jekyll build        # production build to _site/

# Run tests (use Homebrew Ruby, not system Ruby 2.6)
/opt/homebrew/opt/ruby/bin/ruby tests/test_base64_filter.rb
```

Push to `main` deploys automatically via GitHub Actions → GitHub Pages.

## Architecture

This is a plain Jekyll 4 site with no theme or CSS framework. All styling is in `assets/css/main.css` using CSS custom properties. Dark mode is the default; light mode overrides via `@media (prefers-color-scheme: light)`.

**Import deep-links** are generated at build time. `_plugins/base64_filter.rb` registers a `base64_encode` Liquid filter using `Base64.urlsafe_encode64(input, padding: false)`. Workout layouts use it to produce `https://gymscript.app/import?script=<encoded>`. This makes pages work without JavaScript and is the core technical feature of the site.

**Collections:**
- `_workouts/` — workout content, output at `/workouts/:category/:slug/`, defaults to `layout: workout`
- `_pages/` — top-level pages (index, workouts index, category pages), explicit `permalink:` in each file's front matter

**Layouts and includes:**
- `_layouts/default.html` — HTML shell with SEO head (canonical, OG tags, `og:type` from front matter), skip link, nav, footer
- `_layouts/workout.html` — article with script block, copy button, import link, HowTo + BreadcrumbList JSON-LD
- `_layouts/category.html` — filters `site.workouts` by `page.slug`, BreadcrumbList JSON-LD
- `_includes/workout-card.html` — shared card partial; accepts `workout`, `heading_level` (default `h3`), `show_category` (default false)

**Adding a category** requires two things: a `_pages/<slug>.md` with `layout: category` and `slug: <slug>`, and workouts in `_workouts/<slug>/` with matching `category: <slug>`. The workouts index (`_pages/workouts.md`) discovers categories dynamically via `site.pages | where: "layout", "category"` — no template edits needed.

**`og:type`** defaults to `"website"`; workout pages get `"article"` via `_config.yml` defaults.
