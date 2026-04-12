---
layout: default
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
      <a href="{{ '/workouts/' | relative_url }}" class="btn btn--primary">Browse Workouts</a>
    </div>
  </section>

  <h2 class="section-heading">Featured Workouts</h2>

  {% assign featured = site.workouts | where: "featured", true | sort: "title" %}
  {% if featured.size == 0 %}
    {% assign featured = site.workouts | sort: "title" %}
  {% endif %}

  <ul class="workout-grid" role="list">
    {% for workout in featured limit: 4 %}
      {% include workout-card.html workout=workout show_category=true %}
    {% endfor %}
  </ul>

  <div class="about-gymscript">
    <h2>What is GymScript?</h2>
    <p>Write your workout in plain words — GymScript turns it into sets, reps, and timers. No account needed. Free on iOS and Android.</p>
    <div class="about-gymscript__links">
      <a href="https://apps.apple.com/app/gymscript/id6751173133" class="store-badge" rel="noopener noreferrer">
        <img src="/assets/img/badge-app-store.svg" alt="Download on the App Store" width="120" height="40">
      </a>
      <a href="https://play.google.com/store/apps/details?id=loveboat.gymscript" class="store-badge" rel="noopener noreferrer">
        <img src="/assets/img/badge-google-play.svg" alt="Get it on Google Play" width="135" height="40">
      </a>
    </div>
  </div>
</div>
