#!/usr/bin/env bash
# دانلود فونت‌های وزیرمتن و لالزار (هر دو با مجوز SIL OFL) و افزودن آن‌ها به pubspec.yaml
# اگر دانلود نشد، برنامه بدون فونت اختصاصی و با فونت فارسی سیستم ساخته می‌شود.
set -u
APP="$1"
F="$APP/assets/fonts"
mkdir -p "$F"

get() { # get <خروجی> <آدرس‌ها...>
  local out="$1"; shift
  for url in "$@"; do
    if curl -fsSL --retry 2 -o "$out" "$url" && [ "$(wc -c < "$out")" -gt 10000 ]; then return 0; fi
  done
  rm -f "$out"; return 1
}

ok=1
get "$F/Vazirmatn-Regular.ttf" \
  "https://github.com/rastikerdar/vazirmatn/raw/master/fonts/ttf/Vazirmatn-Regular.ttf" \
  "https://cdn.jsdelivr.net/gh/rastikerdar/vazirmatn@v33.003/fonts/ttf/Vazirmatn-Regular.ttf" || ok=0
get "$F/Vazirmatn-Bold.ttf" \
  "https://github.com/rastikerdar/vazirmatn/raw/master/fonts/ttf/Vazirmatn-Bold.ttf" \
  "https://cdn.jsdelivr.net/gh/rastikerdar/vazirmatn@v33.003/fonts/ttf/Vazirmatn-Bold.ttf" || ok=0
get "$F/Lalezar-Regular.ttf" \
  "https://github.com/google/fonts/raw/main/ofl/lalezar/Lalezar-Regular.ttf" \
  "https://cdn.jsdelivr.net/gh/google/fonts@main/ofl/lalezar/Lalezar-Regular.ttf" || ok=0

if [ "$ok" = 1 ]; then
  perl -0pi -e "s/uses-material-design: true/uses-material-design: true\n\n  fonts:\n    - family: Vazirmatn\n      fonts:\n        - asset: assets\/fonts\/Vazirmatn-Regular.ttf\n        - asset: assets\/fonts\/Vazirmatn-Bold.ttf\n          weight: 700\n    - family: Lalezar\n      fonts:\n        - asset: assets\/fonts\/Lalezar-Regular.ttf/" "$APP/pubspec.yaml"
  echo "فونت‌ها اضافه شدند."
else
  echo "دانلود فونت ممکن نشد؛ ادامه با فونت سیستم."
  rm -rf "$F"
fi
exit 0
