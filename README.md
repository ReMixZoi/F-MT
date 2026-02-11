# 📱 App Usage Tracker

แอปบันทึกการใช้งาน YouTube, TikTok และแอปอื่นๆ พร้อมส่งข้อมูลไป Google Sheets

## 📁 โครงสร้างไฟล์

```
App/
├── index.html              ← ตัวแอปหลัก (Web App)
├── www/
│   └── index.html          ← ไฟล์สำหรับ build APK
├── android/                ← โปรเจค Android (Capacitor)
├── capacitor.config.json   ← ค่าตั้ง Capacitor
├── package.json            ← Node.js dependencies
├── google_apps_script.js   ← โค้ดสำหรับ Google Apps Script
├── build_apk.bat           ← สคริปต์ build APK
├── setup_android.bat       ← สคริปต์ติดตั้ง Android SDK
└── README.md               ← ไฟล์นี้
```

## 🔧 วิธีตั้งค่า Google Sheet

1. สร้าง **Google Sheet ใหม่**
2. ไปที่ **Extensions > Apps Script**
3. คัดลอกโค้ดจากไฟล์ `google_apps_script.js` วางลงไป
4. กด **Deploy > New deployment**
   - Type: **Web app**
   - Execute as: **Me**
   - Who has access: **Anyone**
5. กด **Deploy** แล้วคัดลอก URL
6. เปิดแอป → ⚙️ ตั้งค่า → วาง URL → บันทึก

## 📦 วิธี Build APK

### วิธีที่ 1: ใช้ build script (แนะนำ)

1. **ติดตั้ง JDK 17 + Android SDK:**
   ```
   setup_android.bat
   ```

2. **Build APK:**
   ```
   build_apk.bat
   ```

3. ไฟล์ APK จะอยู่ที่ `AppTracker.apk`

### วิธีที่ 2: ใช้ Android Studio

1. ติดตั้ง [Android Studio](https://developer.android.com/studio)
2. เปิด terminal ในโฟลเดอร์ App:
   ```
   npx cap open android
   ```
3. Android Studio จะเปิดขึ้น กด **Build > Build APK(s)**

### วิธีที่ 3: ใช้ command line

```bash
# Copy web assets
npx cap copy android

# Build APK
cd android
gradlew.bat assembleDebug

# APK อยู่ที่:
# android/app/build/outputs/apk/debug/app-debug.apk
```

## 📱 วิธีติดตั้งบนมือถือ

1. ส่งไฟล์ `.apk` ไปมือถือ (ผ่าน USB, Bluetooth, Google Drive, ฯลฯ)
2. เปิดไฟล์บนมือถือ
3. อนุญาต "Install from Unknown Sources" ถ้าถูกถาม
4. ติดตั้ง!

## ✨ ฟีเจอร์

- 🎯 บันทึกการใช้งาน YouTube, TikTok, Facebook, Instagram, Twitter/X, LINE, Netflix
- 📊 ส่งข้อมูลอัตโนมัติไป Google Sheets
- 📋 ดูประวัติการใช้งานทั้งหมด
- ⚙️ ตั้งค่าชื่อผู้ใช้
- 🌙 Dark Mode สวยงาม
- 📱 รองรับ Android APK
