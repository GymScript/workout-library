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
  <p class="workouts-intro">
    Browse ready-to-run workout scripts. Tap any workout to see the script and open it directly in GymScript.
  </p>

  <div class="category-list">
    {% assign category_pages = site.pages | where: "layout", "category" | sort: "title" %}
    {% for cat in category_pages %}
      {% assign cat_workouts = site.workouts | where: "category", cat.slug | sort: "title" %}
      {% if cat_workouts.size > 0 %}
      <section class="category-section">
        <h2>{{ cat.title | split: " " | first }}</h2>
        <ul class="workout-grid" role="list">
          {% for workout in cat_workouts limit: 4 %}
            {% include workout-card.html workout=workout %}
          {% endfor %}
        </ul>
        {% if cat_workouts.size > 4 %}
        <a href="{{ cat.url | relative_url }}" class="view-all">View all {{ cat.title | split: " " | first }} workouts &rarr;</a>
        {% endif %}
      </section>
      {% endif %}
    {% endfor %}
  </div>
</div>
