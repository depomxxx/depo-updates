@echo off
chcp 65001 >nul 2>&1
title FARMA RADAR - ONLINE TAM KURULUM SIHIRBAZI
color 0B

echo ===============================================================================
echo        FARMA RADAR - AKILLI DEPO VE MF SISTEMI ONLINE TAM KURULUMU
echo ===============================================================================
echo.
set "WORK_DIR=C:\FarmaRadar_Kurulum"
set "ZIP_FILE=%WORK_DIR%\FarmaRadar_Tam_Kurulum.zip"
set "DL_URL=https://github.com/depomxxx/depo-updates/releases/latest/download/FarmaRadar_Tam_Kurulum.zip"

echo [1/4] Kurulum dizini hazirlaniyor (%WORK_DIR%)...
if not exist "%WORK_DIR%" mkdir "%WORK_DIR%"
if exist "%ZIP_FILE%" del /f /q "%ZIP_FILE%" >nul 2>&1

echo [2/4] Tam Kurulum Paketi buluttan indiriliyor (Yaklasik 1-2 dk, lutfen bekleyin)...
where curl.exe >nul 2>&1
if %errorlevel% equ 0 (
    curl.exe -fL --retry 3 --connect-timeout 25 -o "%ZIP_FILE%" "%DL_URL%"
) else (
    powershell -NoProfile -ExecutionPolicy Bypass -Command "[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; (New-Object System.Net.WebClient).DownloadFile('%DL_URL%', '%ZIP_FILE%')"
)

if not exist "%ZIP_FILE%" (
    echo.
    echo [HATA] Tam kurulum paketi indirilemedi! Lutfen internet baglantinizi kontrol edin.
    pause
    exit /b 1
)

echo.
echo [3/4] Kurulum dosyalari cikartiliyor (Lutfen bekleyin)...
where tar.exe >nul 2>&1
if %errorlevel% equ 0 (
    tar.exe -xf "%ZIP_FILE%" -C "%WORK_DIR%"
) else (
    powershell -NoProfile -ExecutionPolicy Bypass -Command "Add-Type -AssemblyName System.IO.Compression.FileSystem; if (Test-Path '%WORK_DIR%') { }; [System.IO.Compression.ZipFile]::ExtractToDirectory('%ZIP_FILE%', '%WORK_DIR%')"
)

del /f /q "%ZIP_FILE%" >nul 2>&1

echo [3.5/4] En son canli guncelleme paketi kontrol ediliyor...
if exist "%WORK_DIR%\runtime\python.exe" (
    "%WORK_DIR%\runtime\python.exe" -c "import sys; sys.path.insert(0, r'%WORK_DIR%'); from backend.updater import AutoUpdater; u=AutoUpdater(r'%WORK_DIR%'); c=u.check_for_updates(8.0); u.apply_update(c['download_url'], c.get('sha256',''), c.get('latest_version','')) if (c.get('update_available') and c.get('download_url')) else None" >nul 2>&1
)

echo [4/4] Profesyonel Kurulum Sihirbazi baslatiliyor...
cd /d "%WORK_DIR%"
call "%WORK_DIR%\1_PROFESYONEL_KURULUM_SIHIRBAZI.bat"
