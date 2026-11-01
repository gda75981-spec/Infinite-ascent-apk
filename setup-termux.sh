#!/data/data/com.termux/files/usr/bin/bash
set -euo pipefail
cd "$(dirname "$0")"

echo "== Infinite Ascent offline APK setup =="
command -v node >/dev/null || { echo "Node.js missing. Run: pkg install nodejs-lts"; exit 1; }
command -v npm >/dev/null || { echo "npm missing. Reinstall nodejs-lts."; exit 1; }
command -v curl >/dev/null || { echo "curl missing. Run: pkg install curl"; exit 1; }

mkdir -p www/vendor
echo "Downloading Three.js r128 for local/offline use..."
curl -fL --retry 3 \
  https://cdnjs.cloudflare.com/ajax/libs/three.js/r128/three.min.js \
  -o www/vendor/three.min.js

python - <<'PY'
from pathlib import Path
p = Path("www/index.html")
s = p.read_text(encoding="utf-8")
old = '<script src="https://cdnjs.cloudflare.com/ajax/libs/three.js/r128/three.min.js"></script>'
new = '<script src="./vendor/three.min.js"></script>'
if old not in s:
    if new not in s:
        raise SystemExit("Could not find the expected Three.js script tag. No changes made.")
else:
    s = s.replace(old, new, 1)
# Remove Google Fonts network requests; the game's CSS already defines local fallback fonts.
import re
s = re.sub(r'\s*<link rel="preconnect" href="https://fonts\\.googleapis\\.com">', '', s)
s = re.sub(r'\s*<link rel="preconnect" href="https://fonts\\.gstatic\\.com" crossorigin>', '', s)
s = re.sub(r'\s*<link href="https://fonts\\.googleapis\\.com/css2\\?[^"]+" rel="stylesheet">', '', s)
p.write_text(s, encoding="utf-8")
PY

echo "Installing Capacitor packages..."
npm install
if [ ! -d android ]; then
  npx cap add android
fi
npx cap sync android
echo
echo "Web assets are now bundled locally. The game itself can run offline."
echo "To build locally, a compatible Android SDK must also be installed and ANDROID_HOME configured."
echo "Otherwise, push this project to GitHub and use the included Actions workflow to build the APK."
