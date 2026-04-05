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
    {% assign featured = site.workouts | sort: "title" %}
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
