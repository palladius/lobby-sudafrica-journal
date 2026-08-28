import re

with open('02-polaroid.html', 'r') as f:
    polaroid_html = f.read()

with open('slideshow.html', 'r') as f:
    slideshow_html = f.read()

# Extract styles from slideshow.html
slideshow_styles = re.search(r'<style>(.*?)</style>', slideshow_html, re.DOTALL).group(1)

# Extract #background-text div from slideshow.html
slideshow_bgtext = re.search(r'<div id="background-text">.*?</div>', slideshow_html, re.DOTALL).group(0)

# Extract JS from slideshow.html
slideshow_js = re.search(r'<script>(.*?)</script>', slideshow_html, re.DOTALL).group(1)

# Modify slideshow_styles to avoid conflicts
slideshow_styles = slideshow_styles.replace('body {', 'body.slideshow-active {')
slideshow_styles = slideshow_styles.replace('.polaroid {', '.falling-polaroid {')
slideshow_styles = slideshow_styles.replace('.polaroid img {', '.falling-polaroid img {')
slideshow_styles = slideshow_styles.replace('.polaroid.show {', '.falling-polaroid.show {')

# Modify slideshow_js
# 1. Change 'polaroid' class to 'falling-polaroid' inside dropPolaroid
slideshow_js = slideshow_js.replace("div.className = 'polaroid';", "div.className = 'falling-polaroid';")
# 2. Remove startIntro and window.onload logic
slideshow_js = re.sub(r'function startIntro\(\).*?window\.onload = \(\) => \{.*?startIntro\(\);\n\s*\};', '', slideshow_js, flags=re.DOTALL)

# Add click event listener to start slideshow
click_logic = """
  let slideshowStarted = false;
  document.body.addEventListener('click', () => {
    if (slideshowStarted) return;
    slideshowStarted = true;
    
    // Fade out stage 2 and background
    const stage2 = document.getElementById('stage-2');
    stage2.style.opacity = '0';
    stage2.style.pointerEvents = 'none';
    
    // Switch to dark background
    document.body.style.background = '#222';
    
    document.getElementById('background-text').style.opacity = '1';
    
    setTimeout(() => {
      stage2.style.display = 'none';
      dropPolaroid();
    }, 1000);
  });
"""

slideshow_js += click_logic

# Merge into 02-polaroid.html
# 1. Append styles
polaroid_html = polaroid_html.replace('</style>', f'{slideshow_styles}\n    </style>')
# 2. Append background text before </body>
polaroid_html = polaroid_html.replace('</body>', f'{slideshow_bgtext}\n</body>')
# 3. Append script before </body>
polaroid_html = polaroid_html.replace('</body>', f'<script>\n{slideshow_js}\n</script>\n</body>')

# 4. Add transition to stage-2 for fade out
polaroid_html = polaroid_html.replace('#stage-2 {', '#stage-2 {\n            transition: opacity 1s ease-out;')
polaroid_html = polaroid_html.replace('body {', 'body { transition: background 1s ease-out;')

with open('02-polaroid.html', 'w') as f:
    f.write(polaroid_html)
