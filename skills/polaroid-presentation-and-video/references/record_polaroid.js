const { chromium } = require('playwright');
const path = require('path');
const fs = require('fs');

(async () => {
  const browser = await chromium.launch({ 
    headless: true,
    args: ['--window-size=1920,1080'] 
  });
  const context = await browser.newContext({
    viewport: { width: 1920, height: 1080 },
    recordVideo: {
      dir: './videos_polaroid/',
      size: { width: 1920, height: 1080 }
    }
  });

  const page = await context.newPage();
  await page.setViewportSize({ width: 1920, height: 1080 });
  
  console.log("Navigating to slideshow...");
  await page.goto('http://127.0.0.1:8085/slideshow.html', { waitUntil: 'load' });
  
  console.log("Waiting 35 seconds for animation to finish...");
  await page.waitForTimeout(35000); 
  
  console.log("Closing context to save video...");
  await context.close();
  await browser.close();
  
  const videoFile = fs.readdirSync('./videos_polaroid/').sort().reverse().find(f => f.endsWith('.webm'));
  if (videoFile) {
    const oldPath = path.join('./videos_polaroid/', videoFile);
    const newArtifactPath = path.join('/home/riccardo/.gemini/antigravity/brain/43c773e7-2e6b-4e41-a2d9-8f3357f794e3', 'polaroids_slideshow_small.webm');
    
    fs.copyFileSync(oldPath, newArtifactPath);
    console.log(`Video saved successfully!`);
  } else {
    console.log("No video found.");
  }
})();
