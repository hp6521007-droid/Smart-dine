# SMART DINE — Mobile Canteen Ordering Prototype

Tagline: Digital Menu • Zero Queue • Happy You!

This repository is a mobile-first React + Vite prototype for a college canteen ordering system called SMART DINE. It is a demonstration/prototype only — no real payments, no authentication, and no backend.

Designed for a phone-sized canvas: 390 × 844 px. On desktop the app is centered in a phone-like frame.

Features:
- Browse menu, add to cart.
- Choose pickup slot, demo payment (simulated).
- Order confirmation with QR-style visual.
- Order tracking with automatic status progression (for demo).
- Presentation Demo mode that runs a sample order using sample student data.
- Mobile-first styling, animations, and reusable components.
- Ready for local testing and for deployment to GitHub Pages.

Getting started (local):

1. Install
   - Node 18+ recommended.
   - Install dependencies:
     npm ci

2. Run dev server:
     npm run dev
   Open the URL printed by Vite (the app is optimized for mobile view; the desktop browser will show the phone shell).

3. Build:
     npm run build

4. Preview build:
     npm run preview

Deploy to GitHub Pages:
- This project uses an Actions workflow to deploy the `dist/` folder to the `gh-pages` branch automatically when you push the `smart-dine-prototype` branch.
- After you push `smart-dine-prototype`, open the Actions tab and watch the "Deploy SMART DINE to GitHub Pages" workflow. When it finishes, the site will be available at:
  https://hp6521007-droid.github.io/smart-dine/

Presentation Demo:
- Open the Profile tab and click "Run Presentation Demo". This instantly creates a sample order (#SD1024) and navigates to Orders. Status will auto-progress (Payment Confirmed → Preparing → Ready for Pickup) so you can demo the whole flow.

Branding:
- The app consistently uses "SMART DINE". Do not use "Campus Eats" anywhere.

Important notes:
- This is a prototype for college demonstration only.
- No real payment gateway is used.
- The QR shown is a demo/visual only.

If you want, I can:
- Verify the pushed GitHub Actions run and confirm the GitHub Pages URL,
- Or create a pull request instead of pushing directly.
