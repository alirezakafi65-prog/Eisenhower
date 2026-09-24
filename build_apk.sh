#!/usr/bin/env bash
# ساخت فایل نصبی اندروید (APK) چهارسو
# پیش‌نیاز: Flutter (کانال stable) و JDK 17 و Android SDK
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
APP="$ROOT/build_app"

rm -rf "$APP"
flutter create --platforms=android --project-name chaharsu --org app.chaharsu "$APP"

# کد برنامه
rm -rf "$APP/lib" "$APP/test"
cp -r "$ROOT/lib" "$APP/lib"

# آیکن برنامه
cp -r "$ROOT/android_res/." "$APP/android/app/src/main/res/"

# نام برنامه روی گوشی
perl -pi -e "s/android:label=\"chaharsu\"/android:label=\"چهارسو\"/" "$APP/android/app/src/main/AndroidManifest.xml"

cd "$APP"
flutter pub add shared_preferences
bash "$ROOT/tools/fetch_fonts.sh" "$APP"
flutter pub get
flutter build apk --release

mkdir -p "$ROOT/dist"
cp build/app/outputs/flutter-apk/app-release.apk "$ROOT/dist/chaharsu.apk"
echo "فایل نصبی آماده است: $ROOT/dist/chaharsu.apk"
