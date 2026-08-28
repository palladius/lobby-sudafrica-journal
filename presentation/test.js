
        let step = 1;
        
        const images = [
    "polaroid/2026-02-08-kate-giraffe-selfie.png",
    "polaroid/2026-02-09-1750-afternoon-elephant-pixar.jpg",
    "polaroid/2026-02-09-1035-family-valley-of-waves-pixar.png",
    "polaroid/2026-02-09-0957-valley-waves-overlook-pixar.png",
    "polaroid/2026-02-09-0821-waffle-brothers.png",
    "polaroid/2026-02-08-family-sebi-zebra-selfie.png",
    "polaroid/2026-02-08-family-car-selfie.png",
    "polaroid/vista-camps-bay-pixar.png",
    "polaroid/2026-02-07-sebi-cuddling-rhino-pixar.png",
    "polaroid/rhino-and-son-pixar.png",
    "polaroid/sebi_feeding_donkeys_pixar_style_20260210.png",
    "polaroid/seby-pasta-colazione-pixar.png",
    "polaroid/museum-ale-dinosauro-pixar.png",
    "polaroid/lions_nuzzling_pixar_style_20260210.png",
    "polaroid/2026-02-07-rhinos-crossing-pixar.png",
    "polaroid/2026-02-25-11-37-31-bo-kaap-yellow-house-pixar.png",
    "polaroid/peeking_hippo_pixar_style_20260210.png",
    "polaroid/sebastian-pixar.jpg",
    "polaroid/francois_elephant_pixar_style_20260210_v2.png",
    "polaroid/best_kids_elephant_selfie_pixar_style_20260210.png",
    "polaroid/riccardo-pixar.jpg",
    "polaroid/2026-02-25-11-38-56-bo-kaap-green-wall-pixar.png",
    "polaroid/ale_safari_hippos_pixar_style_20260210_v2.png",
    "polaroid/riccardo_kate_lion_selfie_pixar_style_20260210.png",
    "polaroid/kids_watching_elephants_pixar_style_20260210.png",
    "polaroid/zebras-pixar.png",
    "polaroid/2026-02-25-23-00-55-kids-sleeping-pixar.png",
    "polaroid/2026-02-07-ale-zebra-pixar.png",
    "polaroid/alessandro-pixar.jpg"
  ];
        let currentIndex = 0;
  let nextTiltLeft = Math.random() > 0.5;
  
  function dropPolaroid() {
    if (currentIndex >= images.length) return;
    
    const imgFile = images[currentIndex];
    const div = document.createElement('div');
    div.className = 'falling-polaroid';
    
    const img = document.createElement('img');
    img.src = imgFile;
    div.appendChild(img);
    
    document.body.appendChild(div);
    
    const maxW = window.innerWidth - 450;
    const maxH = window.innerHeight - 450;
    
    const randX = Math.random() * maxW + 20;
    const randY = Math.random() * maxH + 20;
    
    let randRot;
    if (nextTiltLeft) {
      randRot = -(Math.random() * 25 + 10);
    }
        
        // Listen to BOTH spacebar and click
        function advanceStage() {
            if (step === 1) {
                step = 2;
                
                // Effetto PUFF
                const puff = document.getElementById('puff');
                puff.style.animation = 'puff 1s forwards';
                
                // Transizione a Stage 2
                setTimeout(() => {
                    // Nascondi titoli
                    document.getElementById('stage-1').style.opacity = '0';
                    document.getElementById('stage-1').style.pointerEvents = 'none';
                    
                    // Mostra Polaroids
                    const stage2 = document.getElementById('stage-2');
                    stage2.style.opacity = '1';
                    stage2.style.pointerEvents = 'auto';
                    setTimeout(() => stage2.classList.add('show-stage-2'), 100);
                }, 400);
            } 
            else if (step === 2) {
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
                
                setTimeout(() => {
                    stage2.style.display = 'none';
                    dropPolaroid();
                }, 1000);
            }
        }

        document.addEventListener('keydown', (e) => {
            if (e.code === 'Space') {
                advanceStage();
            }
        });
        
        document.body.addEventListener('click', () => {
            advanceStage();
        });

