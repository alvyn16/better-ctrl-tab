@echo off
setlocal enabledelayedexpansion
title Better CtrlTab Installer for Zen Browser

echo ===================================================
echo     Better CtrlTab Panel Installer for Zen Browser
echo ===================================================
echo.

set "ZEN_DIR=%APPDATA%\zen\Profiles"
if not exist "%ZEN_DIR%" (
    echo [ERROR] Zen Browser profile folder not found at:
    echo "%ZEN_DIR%"
    echo Please make sure Zen Browser is installed and has been run at least once.
    echo.
    pause
    exit /b 1
)

set "MOD_ID=72f8f48d-86b9-4487-acea-eb4977b18f21"

:: Find active profile directory
set "PROFILE_DIR="
for /d %%D in ("%ZEN_DIR%\*default*") do (
    set "PROFILE_DIR=%%D"
    goto :found_profile
)

if not defined PROFILE_DIR (
    for /d %%D in ("%ZEN_DIR%\*") do (
        set "PROFILE_DIR=%%D"
        goto :found_profile
    )
)

:found_profile
if not defined PROFILE_DIR (
    echo [ERROR] Could not locate an active Zen profile in "%ZEN_DIR%".
    pause
    exit /b 1
)

echo [*] Target Profile: %PROFILE_DIR%

set "THEMES_DIR=%PROFILE_DIR%\chrome\zen-themes\%MOD_ID%"
if not exist "%THEMES_DIR%" (
    mkdir "%THEMES_DIR%" 2>nul
)

echo [*] Installing mod files...
if exist "%~dp0chrome.css" (
    copy /y "%~dp0chrome.css" "%THEMES_DIR%\chrome.css" >nul
    copy /y "%~dp0preferences.json" "%THEMES_DIR%\preferences.json" >nul
    copy /y "%~dp0theme.json" "%THEMES_DIR%\theme.json" >nul
    if exist "%~dp0image.png" copy /y "%~dp0image.png" "%THEMES_DIR%\image.png" >nul
) else (
    echo [*] Downloading latest mod files from GitHub...
    curl -sSL "https://raw.githubusercontent.com/alvyn16/better-ctrl-tab/main/chrome.css" -o "%THEMES_DIR%\chrome.css"
    curl -sSL "https://raw.githubusercontent.com/alvyn16/better-ctrl-tab/main/preferences.json" -o "%THEMES_DIR%\preferences.json"
    curl -sSL "https://raw.githubusercontent.com/alvyn16/better-ctrl-tab/main/theme.json" -o "%THEMES_DIR%\theme.json"
    curl -sSL "https://raw.githubusercontent.com/alvyn16/better-ctrl-tab/main/image.png" -o "%THEMES_DIR%\image.png"
)

echo [*] Registering mod in zen-themes.json...
powershell -NoProfile -ExecutionPolicy Bypass -Command ^
  "$profileDir = [System.Environment]::ExpandEnvironmentVariables('%PROFILE_DIR%');" ^
  "$jsonPath = Join-Path $profileDir 'zen-themes.json';" ^
  "$modId = '%MOD_ID%';" ^
  "$json = if (Test-Path $jsonPath) { try { Get-Content $jsonPath -Raw | ConvertFrom-Json } catch { [PSCustomObject]@{} } } else { [PSCustomObject]@{} };" ^
  "if ($null -eq $json) { $json = [PSCustomObject]@{} };" ^
  "if (-not $json.PSObject.Properties[$modId]) {" ^
  "  $json | Add-Member -NotePropertyName $modId -NotePropertyValue ([PSCustomObject]@{ id = $modId; name = 'Better CtrlTab Panel'; enabled = $true }) -Force;" ^
  "} else {" ^
  "  $json.$modId.enabled = $true;" ^
  "};" ^
  "$json | ConvertTo-Json -Depth 10 | Set-Content -Path $jsonPath -Encoding utf8;"

echo [*] Enabling Ctrl+Tab switcher in user.js...
set "USER_JS=%PROFILE_DIR%\user.js"
if not exist "%USER_JS%" type nul > "%USER_JS%"
findstr /C:"browser.ctrlTab.sortByRecentlyUsed" "%USER_JS%" >nul 2>&1
if errorlevel 1 (
    echo user_pref("browser.ctrlTab.sortByRecentlyUsed", true);>>"%USER_JS%"
)

echo.
echo ===================================================
echo   [SUCCESS] Better CtrlTab installed successfully!
echo   Please restart Zen Browser to apply changes.
echo ===================================================
echo.
pause
