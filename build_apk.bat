@echo off
chcp 65001 >nul
echo ============================================
echo    App Tracker - APK Builder
echo ============================================
echo.

:: Check if JAVA_HOME is set
if defined JAVA_HOME (
    echo [✓] JAVA_HOME found: %JAVA_HOME%
    goto :check_android
)

:: Check if java is in PATH
where java >nul 2>&1
if %errorlevel% equ 0 (
    echo [✓] Java found in PATH
    goto :check_android
)

echo [!] Java not found. 
echo.
echo Please install JDK 17 first:
echo   Option 1: Download from https://adoptium.net/
echo   Option 2: Run: winget install EclipseAdoptium.Temurin.17.JDK
echo.
echo After installing, restart this script.
echo.
pause
exit /b 1

:check_android
echo.

:: Check for Android SDK
if defined ANDROID_HOME (
    echo [✓] ANDROID_HOME found: %ANDROID_HOME%
    goto :build
)

if defined ANDROID_SDK_ROOT (
    set ANDROID_HOME=%ANDROID_SDK_ROOT%
    echo [✓] ANDROID_SDK_ROOT found: %ANDROID_SDK_ROOT%
    goto :build
)

:: Check default location
set DEFAULT_SDK=%LOCALAPPDATA%\Android\Sdk
if exist "%DEFAULT_SDK%" (
    set ANDROID_HOME=%DEFAULT_SDK%
    echo [✓] Android SDK found: %DEFAULT_SDK%
    goto :build
)

echo [!] Android SDK not found.
echo.
echo Please install Android Studio or Android Command-line Tools:
echo   Download: https://developer.android.com/studio
echo.
echo Or install just the command-line tools:
echo   1. Download from https://developer.android.com/studio#command-tools
echo   2. Extract to %LOCALAPPDATA%\Android\Sdk\cmdline-tools\latest
echo   3. Run: sdkmanager "platforms;android-34" "build-tools;34.0.0"
echo.
echo After installing, restart this script.
echo.
pause
exit /b 1

:build
echo.
echo ============================================
echo    Building APK...
echo ============================================
echo.

:: Copy web assets
echo [1/3] Copying web assets...
copy /Y index.html www\index.html >nul
npx cap copy android
if %errorlevel% neq 0 (
    echo [ERROR] Failed to copy assets.
    pause
    exit /b 1
)
echo [✓] Web assets copied.
echo.

:: Build APK
echo [2/3] Building debug APK...
cd android
call gradlew.bat assembleDebug
if %errorlevel% neq 0 (
    echo [ERROR] Build failed.
    cd ..
    pause
    exit /b 1
)
cd ..
echo [✓] Build complete!
echo.

:: Copy APK to output
echo [3/3] Copying APK...
set APK_PATH=android\app\build\outputs\apk\debug\app-debug.apk
if exist "%APK_PATH%" (
    copy /Y "%APK_PATH%" "AppTracker.apk" >nul
    echo.
    echo ============================================
    echo    ✅ APK Built Successfully!
    echo ============================================
    echo.
    echo    File: AppTracker.apk
    echo    Location: %cd%\AppTracker.apk
    echo.
    echo    Transfer this file to your Android phone
    echo    and install it!
    echo ============================================
    echo.
) else (
    echo [!] APK file not found at expected location.
    echo     Check android\app\build\outputs\ for the APK.
)

pause
