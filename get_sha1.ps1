# PowerShell script to get SHA-1 fingerprint for Firebase
# Run this script to get your debug keystore SHA-1

Write-Host "Getting SHA-1 fingerprint from debug keystore..." -ForegroundColor Cyan
Write-Host ""

$keystorePath = "$env:USERPROFILE\.android\debug.keystore"

if (Test-Path $keystorePath) {
    Write-Host "Found debug keystore at: $keystorePath" -ForegroundColor Green
    Write-Host ""
    Write-Host "SHA-1 Fingerprint:" -ForegroundColor Yellow
    Write-Host "==================" -ForegroundColor Yellow
    
    # Try to find keytool in common Java locations
    $keytoolPaths = @(
        "$env:JAVA_HOME\bin\keytool.exe",
        "C:\Program Files\Java\*\bin\keytool.exe",
        "C:\Program Files (x86)\Java\*\bin\keytool.exe",
        "$env:ANDROID_HOME\jre\bin\keytool.exe"
    )
    
    $keytool = $null
    foreach ($path in $keytoolPaths) {
        $found = Get-ChildItem -Path $path -ErrorAction SilentlyContinue | Select-Object -First 1
        if ($found) {
            $keytool = $found.FullName
            break
        }
    }
    
    if ($keytool) {
        & $keytool -list -v -keystore $keystorePath -alias androiddebugkey -storepass android -keypass android | Select-String "SHA1"
    } else {
        Write-Host "ERROR: keytool not found!" -ForegroundColor Red
        Write-Host ""
        Write-Host "Please run this command manually:" -ForegroundColor Yellow
        Write-Host "keytool -list -v -keystore `"$keystorePath`" -alias androiddebugkey -storepass android -keypass android" -ForegroundColor White
        Write-Host ""
        Write-Host "Or use Android Studio:" -ForegroundColor Yellow
        Write-Host "1. Open your project in Android Studio" -ForegroundColor White
        Write-Host "2. Open Gradle panel (right side)" -ForegroundColor White
        Write-Host "3. Navigate to: YourApp > Tasks > android > signingReport" -ForegroundColor White
        Write-Host "4. Double-click signingReport to run it" -ForegroundColor White
        Write-Host "5. Check the Run panel for SHA-1 fingerprint" -ForegroundColor White
    }
} else {
    Write-Host "ERROR: Debug keystore not found at: $keystorePath" -ForegroundColor Red
    Write-Host ""
    Write-Host "The debug keystore will be created automatically when you build your first Android app." -ForegroundColor Yellow
    Write-Host "Try building your app first, then run this script again." -ForegroundColor Yellow
}

Write-Host ""
Write-Host "After getting SHA-1:" -ForegroundColor Cyan
Write-Host "1. Go to Firebase Console: https://console.firebase.google.com/" -ForegroundColor White
Write-Host "2. Select your project: belstream-daa04" -ForegroundColor White
Write-Host "3. Go to Project Settings > Your apps > Android app" -ForegroundColor White
Write-Host "4. Click 'Add fingerprint' and paste your SHA-1" -ForegroundColor White
Write-Host "5. Download the new google-services.json file" -ForegroundColor White
Write-Host "6. Replace android/app/google-services.json with the new file" -ForegroundColor White

