# App Store Badge Icons Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Replace all plain-text / custom-styled app store links with official Apple and Google badge SVGs, self-hosted in `assets/img/`.

**Architecture:** Download two official badge SVGs, commit them to `assets/img/`, then update all three locations that contain store links to use `<img>` tags inside a minimal `.store-badge` wrapper. Remove the now-unused `.btn--store` CSS rules.

**Tech Stack:** Jekyll 4, plain HTML/CSS, no JS.

---

## File Map

| File | Change |
|------|--------|
| `assets/img/badge-app-store.svg` | **Create** — Apple badge SVG |
| `assets/img/badge-google-play.svg` | **Create** — Google badge SVG |
| `assets/css/main.css` | Remove `.btn--store` rules (lines 243–254); add `.store-badge` rule |
| `_layouts/default.html` | Update footer store links (lines 37–38) |
| `_layouts/workout.html` | Update download-prompt links (lines 45–50) |
| `_pages/index.md` | Update about-gymscript links (lines 37–38) |

---

## Task 1: Download and commit official badge SVGs

**Files:**
- Create: `assets/img/badge-app-store.svg`
- Create: `assets/img/badge-google-play.svg`

- [ ] **Step 1: Download Apple badge SVG**

Go to https://developer.apple.com/app-store/marketing/guidelines/ and download the SVG badge file ("Download on the App Store"). Save it as `assets/img/badge-app-store.svg`.

Alternatively, Apple hosts the badge directly. Run:
```bash
curl -L "https://developer.apple.com/assets/elements/badges/download-on-the-app-store.svg" \
  -o assets/img/badge-app-store.svg
```

Verify the file is valid SVG:
```bash
head -c 200 assets/img/badge-app-store.svg
```
Expected: output starts with `<svg` or `<?xml`.

- [ ] **Step 2: Download Google Play badge SVG**

Go to https://play.google.com/intl/en_us/badges/ and download the SVG badge ("Get it on Google Play"). Save it as `assets/img/badge-google-play.svg`.

Alternatively:
```bash
curl -L "https://play.google.com/intl/en_us/badges/static/images/badges/en_badge_web_generic.svg" \
  -o assets/img/badge-google-play.svg
```

Verify:
```bash
head -c 200 assets/img/badge-google-play.svg
```
Expected: output starts with `<svg` or `<?xml`.

- [ ] **Step 3: Verify files render in browser**

Run the Jekyll dev server:
```bash
bundle exec jekyll serve
```
Open http://localhost:4000/assets/img/badge-app-store.svg and http://localhost:4000/assets/img/badge-google-play.svg in a browser. Both should display the badge images.

- [ ] **Step 4: Commit badge assets**

```bash
git add assets/img/badge-app-store.svg assets/img/badge-google-play.svg
git commit -m "feat: add official App Store and Google Play badge SVGs"
```

---

## Task 2: Update footer store links in `_layouts/default.html`

**Files:**
- Modify: `_layouts/default.html:36-39`

- [ ] **Step 1: Replace footer text links with badge images**

In `_layouts/default.html`, replace lines 36–39:

```html
      <div class="footer-store-links">
        <a href="https://apps.apple.com/app/gymscript/id6751173133" rel="noopener noreferrer">Download on the App Store</a>
        <a href="https://play.google.com/store/apps/details?id=loveboat.gymscript" rel="noopener noreferrer">Get it on Google Play</a>
      </div>
```

With:

```html
      <div class="footer-store-links">
        <a href="https://apps.apple.com/app/gymscript/id6751173133" class="store-badge" rel="noopener noreferrer">
          <img src="/assets/img/badge-app-store.svg" alt="Download on the App Store" height="40">
        </a>
        <a href="https://play.google.com/store/apps/details?id=loveboat.gymscript" class="store-badge" rel="noopener noreferrer">
          <img src="/assets/img/badge-google-play.svg" alt="Get it on Google Play" height="40">
        </a>
      </div>
```

- [ ] **Step 2: Verify in browser**

With `bundle exec jekyll serve` running, visit http://localhost:4000 and scroll to the footer. Both badge images should appear side by side, clickable, at roughly 40px tall.

- [ ] **Step 3: Commit**

```bash
git add _layouts/default.html
git commit -m "feat: use official store badges in footer"
```

---

## Task 3: Update download-prompt links in `_layouts/workout.html`

**Files:**
- Modify: `_layouts/workout.html:44-51`

- [ ] **Step 1: Replace download-prompt buttons with badge images**

In `_layouts/workout.html`, replace lines 44–51:

```html
      <div class="download-prompt__links">
        <a href="https://apps.apple.com/app/gymscript/id6751173133"
           class="btn btn--store"
           rel="noopener noreferrer">App Store</a>
        <a href="https://play.google.com/store/apps/details?id=loveboat.gymscript"
           class="btn btn--store"
           rel="noopener noreferrer">Google Play</a>
      </div>
```

With:

```html
      <div class="download-prompt__links">
        <a href="https://apps.apple.com/app/gymscript/id6751173133"
           class="store-badge"
           rel="noopener noreferrer">
          <img src="/assets/img/badge-app-store.svg" alt="Download on the App Store" height="40">
        </a>
        <a href="https://play.google.com/store/apps/details?id=loveboat.gymscript"
           class="store-badge"
           rel="noopener noreferrer">
          <img src="/assets/img/badge-google-play.svg" alt="Get it on Google Play" height="40">
        </a>
      </div>
```

- [ ] **Step 2: Verify in browser**

Visit any workout page (e.g., http://localhost:4000/workouts/strength/push-day-beginner/). Scroll to the download prompt below the "Open in GymScript" button. Both badge images should appear.

- [ ] **Step 3: Commit**

```bash
git add _layouts/workout.html
git commit -m "feat: use official store badges in workout download prompt"
```

---

## Task 4: Update about-GymScript links in `_pages/index.md`

**Files:**
- Modify: `_pages/index.md:37-38`

- [ ] **Step 1: Replace about-section buttons with badge images**

In `_pages/index.md`, replace lines 37–38:

```html
      <a href="https://apps.apple.com/app/gymscript/id6751173133" class="btn btn--store" rel="noopener noreferrer">App Store</a>
      <a href="https://play.google.com/store/apps/details?id=loveboat.gymscript" class="btn btn--store" rel="noopener noreferrer">Google Play</a>
```

With:

```html
      <a href="https://apps.apple.com/app/gymscript/id6751173133" class="store-badge" rel="noopener noreferrer">
        <img src="/assets/img/badge-app-store.svg" alt="Download on the App Store" height="40">
      </a>
      <a href="https://play.google.com/store/apps/details?id=loveboat.gymscript" class="store-badge" rel="noopener noreferrer">
        <img src="/assets/img/badge-google-play.svg" alt="Get it on Google Play" height="40">
      </a>
```

- [ ] **Step 2: Verify in browser**

Visit http://localhost:4000. Scroll to the "What is GymScript?" section. Both badge images should appear.

- [ ] **Step 3: Commit**

```bash
git add _pages/index.md
git commit -m "feat: use official store badges in homepage about section"
```

---

## Task 5: Update CSS — remove `.btn--store`, add `.store-badge`

**Files:**
- Modify: `assets/css/main.css:243-254`

- [ ] **Step 1: Remove `.btn--store` rules**

In `assets/css/main.css`, delete lines 243–254 (the `.btn--store` and `.btn--store:hover` blocks):

```css
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
```

- [ ] **Step 2: Add `.store-badge` rule**

In the same location (where `.btn--store` was), add:

```css
.store-badge {
  display: inline-block;
  line-height: 0;
}
```

- [ ] **Step 3: Verify no broken styles**

With `bundle exec jekyll serve` running, check all three locations:
- http://localhost:4000 — footer and about section
- Any workout page — download prompt

No broken layouts, no missing elements. Badge images should be crisp and clickable.

- [ ] **Step 4: Commit**

```bash
git add assets/css/main.css
git commit -m "style: replace btn--store with store-badge for official badge images"
```
