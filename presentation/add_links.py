with open('../README.md', 'r') as f:
    content = f.read()

presentation_links = """## 📸 Interactive Presentations

Guarda la nostra fantastica intro animata:
- [🇮🇹 Slideshow Polaroid (Italiano)](./presentation/123-merged.it.html)
- [🇬🇧 Polaroid Slideshow (English)](./presentation/123-merged.en.html)

"""

new_content = content.replace('## 🎥 Video Highlights', presentation_links + '## 🎥 Video Highlights')

with open('../README.md', 'w') as f:
    f.write(new_content)
