# PowerShell script to get SHA-1 fingerprint for RELEASE keystore (Google Sign-In fix)
# Use this when Google Sign-In works in debug but fails in release.
# Reads android/key.properties for keystore path, alias, and passwords (file is gitignored).

$ErrorActionPreference = "Stop"
$scriptDir = if ($PSScriptRoot) { $PSScriptRoot } else { Get-Location }
$androidDir = Join-Path $scriptDir "android"
$keyPropsPath = Join-Path $androidDir "key.properties"
$appDir = Join-Path $androidDir "app"

Write-Host "Release keystore SHA-1 for Firebase / Google Sign-In" -ForegroundColor Cyan
Write-Host ""

if (-not (Test-Path $keyPropsPath)) {
    Write-Host "ERROR: key.properties not found at: $keyPropsPath" -ForegroundColor Red
    Write-Host "Create it with: storeFile, storePassword, keyAlias, keyPassword" -ForegroundColor Yellow
    exit 1
}

$keyProps = @{}
Get-Content $keyPropsPath | ForEach-Object {
    if ($_ -match '^\s*([^#=]+)=(.*)$') {
        $keyProps[$matches[1].Trim()] = $matches[2].Trim()
    }
}

$storeFile = $keyProps['storeFile']
$storePass = $keyProps['storePassword']
$keyPass = $keyProps['keyPassword']
$keyAlias = $keyProps['keyAlias']

if (-not $storeFile -or -not $keyAlias) {
    Write-Host "ERROR: key.properties must contain storeFile and keyAlias" -ForegroundColor Red
    exit 1
}

# Gradle resolves storeFile relative to android/app (app/build.gradle)
$keystorePath = Join-Path $appDir $storeFile
if (-not (Test-Path $keystorePath)) {
    $keystorePath = Join-Path $androidDir $storeFile
}
if (-not (Test-Path $keystorePath)) {
    Write-Host "ERROR: Keystore not found at: $keystorePath" -ForegroundColor Red
    exit 1
}

Write-Host "Keystore: $keystorePath" -ForegroundColor Green
Write-Host "Alias: $keyAlias" -ForegroundColor Green
Write-Host ""

$keytoolPaths = @(
    "$env:JAVA_HOME\bin\keytool.exe",
    "C:\Program Files\Java\*\bin\keytool.exe",
    "C:\Program Files (x86)\Java\*\bin\keytool.exe",
    "$env:ANDROID_HOME\jre\bin\keytool.exe"
)
$keytool = $null
foreach ($path in $keytoolPaths) {
    $found = Get-ChildItem -Path $path -ErrorAction SilentlyContinue | Select-Object -First 1
    if ($found) { $keytool = $found.FullName; break }
}

if (-not $keytool) {
    Write-Host "ERROR: keytool not found. Install JDK or set JAVA_HOME." -ForegroundColor Red
    Write-Host ""
    Write-Host "Run manually (you will be prompted for password):" -ForegroundColor Yellow
    Write-Host "keytool -list -v -keystore `"$keystorePath`" -alias $keyAlias" -ForegroundColor White
    exit 1
}

$keytoolOutput = & $keytool -list -v -keystore $keystorePath -alias $keyAlias -storepass $storePass -keypass $keyPass 2>&1
if ($LASTEXITCODE -ne 0) {
    Write-Host "keytool failed. Wrong password or alias? Run manually:" -ForegroundColor Red
    Write-Host "keytool -list -v -keystore `"$keystorePath`" -alias $keyAlias" -ForegroundColor White
    exit 1
}

$sha1Line = $keytoolOutput | Select-String "SHA1:"
if ($sha1Line) {
    $sha1WithColons = ($sha1Line -replace '^\s*SHA1:\s*', '').Trim()
    $sha1NoColons = $sha1WithColons -replace ':', '' -replace ' ', ''
    Write-Host "SHA-1 (use this in Firebase):" -ForegroundColor Yellow
    Write-Host $sha1WithColons -ForegroundColor White
    Write-Host ""
    Write-Host "SHA-1 without colons (for reference):" -ForegroundColor Gray
    Write-Host $sha1NoColons -ForegroundColor Gray
} else {
    Write-Host "Could not parse SHA1 from keytool output. Full output:" -ForegroundColor Yellow
    Write-Host $keytoolOutput
}

Write-Host ""
Write-Host "Fix Google Sign-In for RELEASE build:" -ForegroundColor Cyan
Write-Host "1. Open Firebase Console: https://console.firebase.google.com/" -ForegroundColor White
Write-Host "2. Project: belstream-daa04 -> Project settings (gear) -> Your apps" -ForegroundColor White
Write-Host "3. Select the Android app with package: com.livestream.touchvoice" -ForegroundColor White
Write-Host "4. Click 'Add fingerprint' and paste the SHA-1 above" -ForegroundColor White
Write-Host "5. Download the new google-services.json" -ForegroundColor White
Write-Host "6. Replace: Tiki stream\android\app\google-services.json" -ForegroundColor White
Write-Host "7. Rebuild release: flutter build apk --release (or app bundle)" -ForegroundColor White
Write-Host ""
