import re

with open('02-polaroid.html', 'r') as f:
    polaroid_html = f.read()

# Extract slideshow JS properly
# dropPolaroid ends with setTimeout(dropPolaroid, 1000); }
images_array = re.search(r'(const images = \[.*?\];)', polaroid_html, re.DOTALL).group(1)
drop_polaroid_func = re.search(r'(let currentIndex = 0;.*?setTimeout\(dropPolaroid, 1000\);\n\s*\})', polaroid_html, re.DOTALL).group(1)

with open('123-merged.it.html', 'r') as f:
    merged_html = f.read()

# Replace the broken JS with the fixed one
# The broken JS starts with `let step = 1;` and ends with `document.body.addEventListener` block
# Let's just reconstruct the whole script tag.

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

# Replace the script block inside 123-merged.it.html
# The script we want to replace is the one at the end, containing 'advanceStage()'
merged_html = re.sub(r'<script>\s*let step = 1;.*?</script>', f'<script>\n{new_js}\n    </script>', merged_html, flags=re.DOTALL)

with open('123-merged.it.html', 'w') as f:
    f.write(merged_html)

