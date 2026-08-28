with open('../README.md', 'r') as f:
    content = f.read()

# Replace the existing links with htmlpreview links
old_it = "- [🇮🇹 Slideshow Polaroid (Italiano)](./presentation/123-merged.it.html)"
old_en = "- [🇬🇧 Polaroid Slideshow (English)](./presentation/123-merged.en.html)"

new_it = "- [🇮🇹 Slideshow Polaroid (Italiano)](https://htmlpreview.github.io/?https://github.com/palladius/lobby-sudafrica-journal/blob/master/presentation/123-merged.it.html)"
new_en = "- [🇬🇧 Polaroid Slideshow (English)](https://htmlpreview.github.io/?https://github.com/palladius/lobby-sudafrica-journal/blob/master/presentation/123-merged.en.html)"

content = content.replace(old_it, new_it)
content = content.replace(old_en, new_en)

with open('../README.md', 'w') as f:
    f.write(content)

