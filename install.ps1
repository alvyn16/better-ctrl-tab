$ErrorActionPreference = "Stop"
Write-Host "===================================================" -ForegroundColor Cyan
Write-Host "   Installing Better CtrlTab (Fixed) for Zen" -ForegroundColor Cyan
Write-Host "===================================================" -ForegroundColor Cyan

$zenDir = Join-Path $env:APPDATA "zen\Profiles"
if (-not (Test-Path $zenDir)) {
    Write-Error "Zen Browser profile folder not found at: $zenDir"
    return
}

$profile = Get-ChildItem -Path $zenDir -Directory | Where-Object { $_.Name -like "*default*" } | Select-Object -First 1
if (-not $profile) {
    $profile = Get-ChildItem -Path $zenDir -Directory | Select-Object -First 1
}

if (-not $profile) {
    Write-Error "No active Zen profile found in $zenDir"
    return
}

$profileDir = $profile.FullName
Write-Host "[*] Target Profile: $profileDir" -ForegroundColor Green

$modId = "72f8f48d-86b9-4487-acea-eb4977b18f21"
$themesDir = Join-Path $profileDir "chrome\zen-themes\$modId"
if (-not (Test-Path $themesDir)) {
    New-Item -ItemType Directory -Path $themesDir -Force | Out-Null
}

$rawBase = "https://raw.githubusercontent.com/alvyn16/better-ctrl-tab/main"
$files = @("chrome.css", "preferences.json", "theme.json", "image.png")

foreach ($f in $files) {
    Write-Host "[*] Downloading $f..." -ForegroundColor Yellow
    Invoke-WebRequest -Uri "$rawBase/$f" -OutFile (Join-Path $themesDir $f) -UseBasicParsing
}

# Update zen-themes.json
$jsonPath = Join-Path $profileDir "zen-themes.json"
$json = if (Test-Path $jsonPath) {
    try { Get-Content $jsonPath -Raw | ConvertFrom-Json } catch { [PSCustomObject]@{} }
} else { [PSCustomObject]@{} }

if ($null -eq $json) { $json = [PSCustomObject]@{} }
if (-not $json.PSObject.Properties[$modId]) {
    $json | Add-Member -NotePropertyName $modId -NotePropertyValue ([PSCustomObject]@{ id = $modId; name = "Better CtrlTab Panel"; enabled = $true }) -Force
} else {
    $json.$modId.enabled = $true
}
$json | ConvertTo-Json -Depth 10 | Set-Content -Path $jsonPath -Encoding utf8

# Enable user.js pref
$userJs = Join-Path $profileDir "user.js"
if (-not (Test-Path $userJs)) { "" | Set-Content $userJs -Encoding utf8 }
$userJsContent = Get-Content $userJs -Raw
if ($userJsContent -notmatch "browser\.ctrlTab\.sortByRecentlyUsed") {
    Add-Content -Path $userJs -Value 'user_pref("browser.ctrlTab.sortByRecentlyUsed", true);'
}

Write-Host ""
Write-Host "===================================================" -ForegroundColor Cyan
Write-Host "  [SUCCESS] Better CtrlTab installed successfully!" -ForegroundColor Green
Write-Host "  Please restart Zen Browser to apply changes." -ForegroundColor Cyan
Write-Host "===================================================" -ForegroundColor Cyan
