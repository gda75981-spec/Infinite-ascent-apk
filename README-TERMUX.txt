INFINITE ASCENT — OFFLINE ANDROID APK
=====================================

This package wraps your uploaded index.html game with Capacitor.
Three.js is downloaded once during setup and copied into www/vendor,
then the HTML is changed to load that local copy. Google Fonts links
are removed; the game's CSS has fallback fonts. Once built/installed,
the game does not need an internet connection to run.

IMPORTANT ABOUT TERMUX:
Termux can prepare the project and run npm/Capacitor. Building an APK
locally also requires a working Android SDK, build-tools, platform
tools, and compatible Java/Gradle. Setting up the full Android SDK
directly inside Termux on a Fire tablet is not the easiest/reliable
route. The included GitHub Actions workflow can build the APK remotely;
the resulting APK itself is offline.

1) Install Termux from F-Droid or its official GitHub release.
2) Put this ZIP in Download and extract it in Termux, for example:
     pkg update && pkg upgrade
     pkg install nodejs-lts python curl unzip git
     termux-setup-storage
     cd ~/storage/downloads
     unzip infinite-ascent-capacitor.zip
     cd infinite-ascent-capacitor
     bash setup-termux.sh

3) For the APK build:
   - Easiest: create a GitHub repository and upload this project folder
     after setup (including package-lock.json and the generated android/
     folder), then run the included GitHub Actions workflow.
   - The workflow uploads app-debug.apk as a downloadable build artifact.
   - Download that APK to the Fire tablet and install it. You may need
     to allow installation from the app/browser used to open the APK.

4) To update the game later:
     replace www/index.html with your newer game file
     npx cap sync android
   Then rebuild the APK.

OFFLINE NOTES:
- The Three.js library is bundled in www/vendor/three.min.js.
- The Google Fonts are not bundled; fallback system fonts are used.
- The game uses localStorage for its save data. Android WebView keeps
  this app's local web storage between launches.
- First-time setup/build needs internet for npm packages, Three.js,
  Gradle/Android dependencies, and/or GitHub Actions. Gameplay does not.
