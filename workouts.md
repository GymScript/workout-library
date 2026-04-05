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
