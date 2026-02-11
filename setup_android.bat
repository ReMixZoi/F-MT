@echo off
chcp 65001 >nul
echo ============================================
echo    Setup Android Build Environment
echo ============================================
echo.
echo This script will install:
echo   1. JDK 17 (Eclipse Temurin)
echo   2. Android Command-line Tools
echo   3. Android SDK Platform 34
echo   4. Android Build Tools 34.0.0
echo.
echo ============================================
echo.

:: Check if winget is available
where winget >nul 2>&1
if %errorlevel% neq 0 (
    echo [ERROR] winget not found. Please install App Installer from Microsoft Store.
    pause
    exit /b 1
)

:: Install JDK 17
echo [1/4] Installing JDK 17...
where java >nul 2>&1
if %errorlevel% equ 0 (
    echo [✓] Java already installed, skipping.
) else (
    winget install EclipseAdoptium.Temurin.17.JDK --accept-source-agreements --accept-package-agreements
    if %errorlevel% neq 0 (
        echo [WARNING] Auto-install failed. Please install JDK 17 manually:
        echo   https://adoptium.net/
    ) else (
        echo [✓] JDK 17 installed.
    )
)
echo.

:: Setup Android SDK directory
set SDK_DIR=%LOCALAPPDATA%\Android\Sdk
echo [2/4] Setting up Android SDK at %SDK_DIR%...
if not exist "%SDK_DIR%" mkdir "%SDK_DIR%"
if not exist "%SDK_DIR%\cmdline-tools" mkdir "%SDK_DIR%\cmdline-tools"

:: Set environment variables
echo [3/4] Setting environment variables...
setx ANDROID_HOME "%SDK_DIR%" >nul 2>&1
setx ANDROID_SDK_ROOT "%SDK_DIR%" >nul 2>&1
set ANDROID_HOME=%SDK_DIR%
set ANDROID_SDK_ROOT=%SDK_DIR%
echo [✓] ANDROID_HOME set to %SDK_DIR%
echo.

echo ============================================
echo.
echo   Next steps:
echo.
echo   1. Download Android Command-line Tools from:
echo      https://developer.android.com/studio#command-tools
echo.
echo   2. Extract the 'cmdline-tools' folder to:
echo      %SDK_DIR%\cmdline-tools\latest\
echo.
echo   3. Run these commands in a NEW terminal:
echo      cd %SDK_DIR%\cmdline-tools\latest\bin
echo      sdkmanager "platforms;android-34"
echo      sdkmanager "build-tools;34.0.0"
echo      sdkmanager "platform-tools"
echo.
echo   4. Then go back to c:\Code\App and run:
echo      build_apk.bat
echo.
echo   OR simply install Android Studio from:
echo   https://developer.android.com/studio
echo   (This includes everything automatically)
echo.
echo ============================================
pause
