@echo off
title Farma Radar Hizli Onarim Araci (v1.9.3)
color 0A
echo =========================================================
echo   FARMA RADAR OTOMATIK ONARIM VE GUNCELLEME (v1.9.3)
echo =========================================================
set "TARGET_DIR="
if exist "C:\EczaneDepoPro\server.py" set "TARGET_DIR=C:\EczaneDepoPro"
if not defined TARGET_DIR if exist "D:\EczaneDepoPro\server.py" set "TARGET_DIR=D:\EczaneDepoPro"
if not defined TARGET_DIR if exist "C:\FarmaRadar\server.py" set "TARGET_DIR=C:\FarmaRadar"
if not defined TARGET_DIR if exist "%LOCALAPPDATA%\FarmaRadar\server.py" set "TARGET_DIR=%LOCALAPPDATA%\FarmaRadar"
if not defined TARGET_DIR (
  for /f "usebackq delims=" %%I in (`powershell -NoProfile -Command "$ws=New-Object -ComObject WScript.Shell; foreach($d in @([Environment]::GetFolderPath('Desktop'), [Environment]::GetFolderPath('CommonDesktopDirectory'))) { Get-ChildItem $d -Filter *.lnk -EA SilentlyContinue | ForEach-Object { $s=$ws.CreateShortcut($_.FullName); if($s.WorkingDirectory -and (Test-Path (Join-Path $s.WorkingDirectory 'server.py'))) { Write-Output $s.WorkingDirectory; exit } } }"`) do set "TARGET_DIR=%%I"
)
if not defined TARGET_DIR (
  echo [HATA] Kurulum klasoru bulunamadi!
  pause
  exit /b 1
)
echo Kurulum klasoru bulundu: %TARGET_DIR%
set "PY_EXE=%TARGET_DIR%\runtime\python.exe"
if not exist "%PY_EXE%" set "PY_EXE=%TARGET_DIR%\runtime\Tria.exe"
if not exist "%PY_EXE%" set "PY_EXE=python"
set "HEAL_PY=%TEMP%\_fr_cloud_heal.py"
(
echo import os, io, ssl, zipfile, urllib.request
echo t = os.environ["TARGET_DIR"]
echo url = "https://raw.githubusercontent.com/depomxxx/depo-updates/main/update_v1.9.3.zip?t=" + str(os.getpid())
echo ctx = ssl._create_unverified_context()
echo print("Buluttan guncel surum indiriliyor...")
echo data = urllib.request.urlopen(url, timeout=25, context=ctx).read()
echo zipfile.ZipFile(io.BytesIO(data)).extractall(t)
echo print("Basariyla onarildi ve v1.9.3 kuruldu!")
) > "%HEAL_PY%"
"%PY_EXE%" "%HEAL_PY%"
echo Program baslatiliyor...
if exist "%TARGET_DIR%\runtime\pythonw.exe" (
  start "" "%TARGET_DIR%\runtime\pythonw.exe" "%TARGET_DIR%\launcher.py"
) else (
  start "" "%PY_EXE%" "%TARGET_DIR%\launcher.py"
)
timeout /t 2 >nul
exit /b 0
