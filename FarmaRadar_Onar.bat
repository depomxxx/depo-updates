@echo off
chcp 65001 >nul 2>&1
title Farma Radar Hizli Onarim ve Kisayol Duzeltme Araci
color 0A
echo =========================================================
echo   FARMA RADAR OTOMATIK ONARIM VE KISAYOL DUZELTME ARACI
echo =========================================================
set "TARGET_DIR="
if exist "C:\EczaneDepoPro\server.py" set "TARGET_DIR=C:\EczaneDepoPro"
if not defined TARGET_DIR if exist "D:\EczaneDepoPro\server.py" set "TARGET_DIR=D:\EczaneDepoPro"
if not defined TARGET_DIR if exist "C:\FarmaRadar\server.py" set "TARGET_DIR=C:\FarmaRadar"
if not defined TARGET_DIR if exist "%LOCALAPPDATA%\FarmaRadar\server.py" set "TARGET_DIR=%LOCALAPPDATA%\FarmaRadar"
if not defined TARGET_DIR (
  echo [HATA] C:\EczaneDepoPro kurulum klasoru bulunamadi!
  echo Eger bu bilgisayar kalfa/istemci bilgisayari ise ana bilgisayarin IP adresini tarayicidan aciniz.
  pause
  exit /b 1
)
echo [1/3] Kurulum klasoru bulundu: %TARGET_DIR%
set "PY_EXE=%TARGET_DIR%\runtime\python.exe"
if not exist "%PY_EXE%" set "PY_EXE=%TARGET_DIR%\runtime\Tria.exe"
if not exist "%PY_EXE%" set "PY_EXE=python"

echo [2/3] Buluttan en guncel surum indiriliyor...
set "HEAL_PY=%TEMP%\_fr_cloud_heal.py"
(
echo import os, io, ssl, json, zipfile, urllib.request, time
echo t = os.environ["TARGET_DIR"]
echo ctx = ssl._create_unverified_context()
echo mf = json.loads(urllib.request.urlopen("https://raw.githubusercontent.com/depomxxx/depo-updates/main/version.json?t=" + str(int(time.time()*1000)), timeout=15, context=ctx).read().decode("utf-8"))
echo dl = mf.get("download_url") or ("update_v" + mf["version"] + ".zip")
echo if not dl.startswith("http"):
echo     dl = "https://raw.githubusercontent.com/depomxxx/depo-updates/main/" + dl.lstrip("/")
echo data = urllib.request.urlopen(dl + "?t=" + str(int(time.time()*1000)), timeout=30, context=ctx).read()
echo zipfile.ZipFile(io.BytesIO(data)).extractall(t)
echo print("Basariyla onarildi -> v" + str(mf.get("version")))
) > "%HEAL_PY%"
"%PY_EXE%" "%HEAL_PY%"

echo [3/3] Masaustu Farma Radar kisayolu onariliyor...
powershell -NoProfile -ExecutionPolicy Bypass -Command "$ws=New-Object -ComObject WScript.Shell; $td='%TARGET_DIR%'; $pyw=Join-Path $td 'runtime\pythonw.exe'; if(-not (Test-Path $pyw)){ $pyw=Join-Path $td 'Eda_Depo.exe' }; $lp=Join-Path $td 'launcher.py'; $ico=Join-Path $td 'backend\ui\farma_radar.ico'; $desks=@([Environment]::GetFolderPath('Desktop'), (Join-Path $env:USERPROFILE 'Desktop'), (Join-Path $env:USERPROFILE 'OneDrive\Masaüstü'), (Join-Path $env:USERPROFILE 'OneDrive\Desktop')) | Where-Object { $_ -and (Test-Path $_) } | Select-Object -Unique; foreach($d in $desks){ $lnk=Join-Path $d 'Farma Radar.lnk'; Remove-Item $lnk -Force -EA SilentlyContinue; $s=$ws.CreateShortcut($lnk); $s.TargetPath=$pyw; if($pyw -match 'pythonw'){ $s.Arguments='\"'+$lp+'\"' }; $s.WorkingDirectory=$td; $s.WindowStyle=7; if(Test-Path $ico){ $s.IconLocation=$ico+',0' }; $s.Save(); Write-Host ('Kisayol onarildi: '+$lnk) }"

echo Program baslatiliyor...
if exist "%TARGET_DIR%\runtime\pythonw.exe" (
  start "" "%TARGET_DIR%\runtime\pythonw.exe" "%TARGET_DIR%\launcher.py"
) else (
  start "" "%PY_EXE%" "%TARGET_DIR%\launcher.py"
)
timeout /t 2 >nul
exit /b 0
