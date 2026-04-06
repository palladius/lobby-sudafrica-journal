---
layout: page
title: "📖 Diario di Viaggio"
subtitle: "🇿🇦 Sudafrica, Febbraio 2026"
permalink: /diario/
cover-img: /assets/images/pixar/20260208/2026-02-08-lion-pride-recreation-pixar.png
---

<style>
.diary-index {
  max-width: 800px;
  margin: 0 auto;
}

.diary-phase {
  margin-bottom: 2.5rem;
}

.diary-phase h2 {
  font-size: 1.5rem;
  color: #333;
  border-bottom: 3px solid #2c7a4b;
  padding-bottom: 0.5rem;
  margin-bottom: 1rem;
}

.diary-day {
  display: flex;
  align-items: center;
  padding: 0.8rem 1rem;
  margin-bottom: 0.5rem;
  border-radius: 8px;
  background: #f8f9fa;
  border-left: 4px solid #2c7a4b;
  transition: all 0.2s ease;
  text-decoration: none;
  color: inherit;
}

.diary-day:hover {
  background: #e8f5e9;
  transform: translateX(4px);
  box-shadow: 0 2px 8px rgba(0,0,0,0.1);
  text-decoration: none;
  color: inherit;
}

.diary-day .day-date {
  font-weight: 700;
  font-size: 0.85rem;
  color: #2c7a4b;
  min-width: 90px;
  letter-spacing: 0.5px;
}

.diary-day .day-title {
  font-size: 1rem;
  flex: 1;
}

.diary-day .day-emoji {
  font-size: 1.3rem;
  margin-right: 0.8rem;
}

.diary-day.placeholder {
  opacity: 0.5;
  border-left-color: #ccc;
}

.diary-day.placeholder .day-date {
  color: #999;
}

.diary-intro {
  text-align: center;
  margin-bottom: 2rem;
  font-size: 1.1rem;
  line-height: 1.6;
  color: #555;
}

.diary-intro em {
  font-style: italic;
  color: #777;
}

.review-badge {
  font-size: 1.1rem;
  margin-left: auto;
  padding-left: 10px;
}
</style>

<div class="diary-index">

<p class="diary-intro">
Il diario del nostro incredibile viaggio in famiglia in Sudafrica 🇿🇦<br>
<em>Tre settimane tra safari, vigneti, e avventure indimenticabili.</em>
</p>

<div class="diary-phase">
<h2>🦁 Prima Tappa: Pilanesberg National Park</h2>

{% assign sorted_posts = site.posts | sort: "date" %}
{% for post in sorted_posts %}
  {% assign post_day = post.date | date: "%-d" | plus: 0 %}
  {% if post_day >= 5 and post_day <= 10 %}
    {% assign is_placeholder = false %}
    {% if post.title contains "📅" %}
      {% assign is_placeholder = true %}
    {% endif %}
    <a href="{{ post.url | relative_url }}" class="diary-day {% if is_placeholder %}placeholder{% endif %}">
      <span class="day-date">{{ post.date | date: "%d/%m" }}</span>
      <span class="day-title">{{ post.title | strip_html }}</span>
      {% if post.reviewed %}
        <span class="review-badge" title="STAR reviewed by Riccardo">⭐</span>
      {% else %}
        <span class="review-badge" title="Da completare: Visualizza foto originali su Google Photos">🚧</span>
      {% endif %}
    </a>
  {% endif %}
{% endfor %}

</div>

<div class="diary-phase">
<h2>🦒 Seconda Tappa: Johannesburg & Dintorni</h2>

{% for post in sorted_posts %}
  {% assign post_day = post.date | date: "%-d" | plus: 0 %}
  {% if post_day >= 11 and post_day <= 12 %}
    {% assign is_placeholder = false %}
    {% if post.title contains "📅" %}
      {% assign is_placeholder = true %}
    {% endif %}
    <a href="{{ post.url | relative_url }}" class="diary-day {% if is_placeholder %}placeholder{% endif %}">
      <span class="day-date">{{ post.date | date: "%d/%m" }}</span>
      <span class="day-title">{{ post.title | strip_html }}</span>
      {% if post.reviewed %}
        <span class="review-badge" title="STAR reviewed by Riccardo">⭐</span>
      {% else %}
        <span class="review-badge" title="Da completare: Visualizza foto originali su Google Photos">🚧</span>
      {% endif %}
    </a>
  {% endif %}
{% endfor %}

</div>

<div class="diary-phase">
<h2>🍷 Terza Tappa: Franschhoek & Cape Winelands</h2>

{% for post in sorted_posts %}
  {% assign post_day = post.date | date: "%-d" | plus: 0 %}
  {% if post_day >= 13 and post_day <= 25 %}
    {% assign is_placeholder = false %}
    {% if post.title contains "📅" %}
      {% assign is_placeholder = true %}
    {% endif %}
    <a href="{{ post.url | relative_url }}" class="diary-day {% if is_placeholder %}placeholder{% endif %}">
      <span class="day-date">{{ post.date | date: "%d/%m" }}</span>
      <span class="day-title">{{ post.title | strip_html }}</span>
      {% if post.reviewed %}
        <span class="review-badge" title="STAR reviewed by Riccardo">⭐</span>
      {% else %}
        <span class="review-badge" title="Da completare: Visualizza foto originali su Google Photos">🚧</span>
      {% endif %}
    </a>
  {% endif %}
{% endfor %}

</div>

<div class="diary-phase">
<h2>✈️ Ritorno</h2>

{% for post in sorted_posts %}
  {% assign post_day = post.date | date: "%-d" | plus: 0 %}
  {% if post_day >= 26 %}
    {% assign is_placeholder = false %}
    {% if post.title contains "📅" %}
      {% assign is_placeholder = true %}
    {% endif %}
    <a href="{{ post.url | relative_url }}" class="diary-day {% if is_placeholder %}placeholder{% endif %}">
      <span class="day-date">{{ post.date | date: "%d/%m" }}</span>
      <span class="day-title">{{ post.title | strip_html }}</span>
      {% if post.reviewed %}
        <span class="review-badge" title="STAR reviewed by Riccardo">⭐</span>
      {% else %}
        <span class="review-badge" title="Da completare: Visualizza foto originali su Google Photos">📸</span>
      {% endif %}
    </a>
  {% endif %}
{% endfor %}

</div>

</div>
