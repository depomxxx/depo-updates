@echo off
chcp 65001 >nul 2>&1
title FARMA RADAR - ONLINE TAM KURULUM SIHIRBAZI
color 0B

echo ===============================================================================
echo        FARMA RADAR - AKILLI DEPO ^& MF SISTEMI ONLINE TAM KURULUMU
echo ===============================================================================
echo.
echo [1/4] Kurulum dizini hazirlaniyor (C:\FarmaRadar_Kurulum)...
set "WORK_DIR=C:\FarmaRadar_Kurulum"
if not exist "%WORK_DIR%" mkdir "%WORK_DIR%"

echo [2/4] Tam Kurulum Paketi buluttan indiriliyor (Lutfen bekleyin)...
powershell -NoProfile -ExecutionPolicy Bypass -Command ^
    "$ProgressPreference = 'SilentlyContinue'; ^
    [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; ^
    $url = 'https://github.com/depomxxx/depo-updates/releases/latest/download/FarmaRadar_Tam_Kurulum.zip'; ^
    $out = '%WORK_DIR%\FarmaRadar_Tam_Kurulum.zip'; ^
    Write-Host 'Indiriliyor: ' $url; ^
    Invoke-WebRequest -Uri $url -OutFile $out -UseBasicParsing;"

if not exist "%WORK_DIR%\FarmaRadar_Tam_Kurulum.zip" (
    echo [HATA] Tam kurulum paketi indirilemedi! Lutfen internet baglantinizi kontrol edin.
    pause
    exit /b 1
)

echo [3/4] Kurulum dosyalari cikartiliyoruz...
powershell -NoProfile -ExecutionPolicy Bypass -Command ^
    "$ProgressPreference = 'SilentlyContinue'; ^
    Expand-Archive -Path '%WORK_DIR%\FarmaRadar_Tam_Kurulum.zip' -DestinationPath '%WORK_DIR%' -Force;"

del /f /q "%WORK_DIR%\FarmaRadar_Tam_Kurulum.zip" >nul 2>&1

echo [3.5/4] En son canli guncelleme paketi kontrol ediliyor...
powershell -NoProfile -ExecutionPolicy Bypass -Command ^
    "$ProgressPreference = 'SilentlyContinue'; ^
    try { ^
        $m = Invoke-RestMethod -Uri 'https://raw.githubusercontent.com/depomxxx/depo-updates/main/version.json?t=' + [DateTimeOffset]::Now.ToUnixTimeSeconds() -UseBasicParsing; ^
        if ($m.download_url) { ^
            $uZip = '%WORK_DIR%\latest_update.zip'; ^
            Invoke-WebRequest -Uri $m.download_url -OutFile $uZip -UseBasicParsing; ^
            Expand-Archive -Path $uZip -DestinationPath '%WORK_DIR%' -Force; ^
            Remove-Item $uZip -Force -ErrorAction SilentlyContinue; ^
        } ^
    } catch {}"

echo [4/4] Profesyonel Kurulum Sihirbazi baslatiliyor...
cd /d "%WORK_DIR%"
call "%WORK_DIR%\1_PROFESYONEL_KURULUM_SIHIRBAZI.bat"
