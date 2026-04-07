# App Store Badge Icons — Design Spec

**Date:** 2026-04-07  
**Status:** Approved

## Problem

All three locations that link to the App Store and Google Play use plain text or custom-styled `btn btn--store` buttons. Apple and Google brand guidelines require use of their official badge artwork, and the official badges are universally recognizable by users.

## Goal

Replace all app store text/button links with self-hosted official SVG badges.

## Assets

Download official SVG badge files and commit to:

- `assets/img/badge-app-store.svg` — Apple "Download on the App Store" badge
- `assets/img/badge-google-play.svg` — Google "Get it on Google Play" badge

**Sources:**
- Apple badge: https://developer.apple.com/app-store/marketing/guidelines/ (Marketing Artwork section)
- Google badge: https://play.google.com/intl/en_us/badges/ (official badge generator/download)

## HTML Pattern

Every store link becomes:

```html
<a href="<store-url>" rel="noopener noreferrer" class="store-badge">
  <img src="/assets/img/badge-app-store.svg"
       alt="Download on the App Store"
       height="40">
</a>
<a href="<store-url>" rel="noopener noreferrer" class="store-badge">
  <img src="/assets/img/badge-google-play.svg"
       alt="Get it on Google Play"
       height="40">
</a>
```

- `height="40"` is the standard badge height; width scales from the SVG viewBox
- `alt` text matches the official badge label (required by Apple/Google guidelines)
- `btn btn--store` class removed from all links

## CSS Changes

Remove `.btn--store` and its hover/focus rules from `assets/css/main.css`.

Add a minimal replacement:

```css
.store-badge {
  display: inline-block;
  line-height: 0; /* prevent gap below inline img */
}
```

## Locations

1. **`_layouts/default.html`** — footer `.footer-store-links` (currently plain text links)
2. **`_layouts/workout.html`** — `.download-prompt__links` (currently `btn btn--store`)
3. **`_pages/index.md`** — `.about-gymscript__links` (currently `btn btn--store`)

## Out of Scope

- No changes to the "Get GymScript" nav/hero links (those are not store badge contexts)
- No changes to link `href` values
