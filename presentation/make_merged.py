import re

with open('01-family-intro.it.html', 'r') as f:
    intro_html = f.read()

with open('02-polaroid.html', 'r') as f:
    polaroid_html = f.read()

# Extract slideshow CSS
slideshow_css = re.search(r'(@import url.*?\.falling-polaroid\.show \{\n\s*opacity: 1;\n\s*\})', polaroid_html, re.DOTALL).group(1)

# Extract background text HTML
slideshow_html_div = re.search(r'<div id="background-text">.*?</div>', polaroid_html, re.DOTALL).group(0)

# Extract slideshow JS (images array and dropPolaroid function)
images_array = re.search(r'(const images = \[.*?\];)', polaroid_html, re.DOTALL).group(1)
drop_polaroid_func = re.search(r'(let currentIndex = 0;.*?function dropPolaroid\(\) \{.*?\n\s*\})', polaroid_html, re.DOTALL).group(1)

# We will inject these into intro_html
# 1. Add CSS
intro_html = intro_html.replace('</style>', f'\n{slideshow_css}\n    </style>')

# 2. Add transition to body and stage-2
intro_html = intro_html.replace('body {', 'body { transition: background 1s ease-out;')
intro_html = intro_html.replace('#stage-2 {', '#stage-2 {\n            transition: opacity 1s ease-out;')

# 3. Add background-text div
intro_html = intro_html.replace('</body>', f'    {slideshow_html_div}\n</body>')

# 4. Modify the JS in intro_html to handle 3 steps
new_js = f"""
        let step = 1;
        
        {images_array}
        {drop_polaroid_func}
        
        // Listen to BOTH spacebar and click
        function advanceStage() {{
            if (step === 1) {{
                step = 2;
                
                // Effetto PUFF
                const puff = document.getElementById('puff');
                puff.style.animation = 'puff 1s forwards';
                
                // Transizione a Stage 2
                setTimeout(() => {{
                    // Nascondi titoli
                    document.getElementById('stage-1').style.opacity = '0';
                    document.getElementById('stage-1').style.pointerEvents = 'none';
                    
                    // Mostra Polaroids
                    const stage2 = document.getElementById('stage-2');
                    stage2.style.opacity = '1';
                    stage2.style.pointerEvents = 'auto';
                    setTimeout(() => stage2.classList.add('show-stage-2'), 100);
                }}, 400);
            }} 
            else if (step === 2) {{
                step = 3;
                
                // Fade out stage 2 and background
                const stage2 = document.getElementById('stage-2');
                stage2.style.opacity = '0';
                stage2.style.pointerEvents = 'none';
                
                document.getElementById('bkg').style.opacity = '0'; // fade out safari background
                document.getElementById('bkg').style.transition = 'opacity 1s ease-out';
                
                // Switch to dark background
                document.body.style.background = '#222';
                
                document.getElementById('background-text').style.opacity = '1';
                
                setTimeout(() => {{
                    stage2.style.display = 'none';
                    dropPolaroid();
                }}, 1000);
            }}
        }}

        document.addEventListener('keydown', (e) => {{
            if (e.code === 'Space') {{
                advanceStage();
            }}
        }});
        
        document.body.addEventListener('click', () => {{
            advanceStage();
        }});
"""

intro_html = re.sub(r'<script>.*?</script>', f'<script>\n{new_js}\n    </script>', intro_html, flags=re.DOTALL)

with open('123-merged.html', 'w') as f:
    f.write(intro_html)

