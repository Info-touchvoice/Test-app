# Hilo APK reverse-engineering kit builder
# Extracts design assets, layouts, colors from Hilo-4.16.0.apk

$ErrorActionPreference = "Stop"

$Root = Split-Path -Parent $PSScriptRoot
$ApkPath = Join-Path (Split-Path -Parent $Root) "Hilo-4.16.0.apk"
$InspectDir = Join-Path $Root ".apk-inspect-temp"
$ApktoolJar = Join-Path $InspectDir "apktool.jar"
$Decompiled = Join-Path $InspectDir "hilo-4.16-decompiled"
$KitDir = Join-Path $InspectDir "hilo-design-kit"
$CatalogJson = Join-Path $KitDir "catalog.json"

Write-Host "Hilo reverse-engineering kit"
Write-Host "APK: $ApkPath"
Write-Host "Output: $KitDir"

if (-not (Test-Path $ApkPath)) {
    throw "APK not found: $ApkPath"
}

# Decompile with apktool if missing or APK is newer
$needsDecompile = -not (Test-Path (Join-Path $Decompiled "apktool.yml"))
if (-not $needsDecompile) {
    $apkTime = (Get-Item $ApkPath).LastWriteTimeUtc
    $decTime = (Get-Item (Join-Path $Decompiled "apktool.yml")).LastWriteTimeUtc
    if ($apkTime -gt $decTime) { $needsDecompile = $true }
}

if ($needsDecompile) {
    Write-Host "Decompiling APK with apktool..."
    if (-not (Test-Path $ApktoolJar)) { throw "apktool.jar missing at $ApktoolJar" }
    if (Test-Path $Decompiled) { Remove-Item $Decompiled -Recurse -Force }
    & java -jar $ApktoolJar d $ApkPath -o $Decompiled -f
}

# Clean and recreate design kit
if (Test-Path $KitDir) { Remove-Item $KitDir -Recurse -Force }
$categories = @(
    "bottom-nav", "group", "match", "games", "chat", "room", "profile",
    "backgrounds", "gifts", "ranking", "family", "common", "layouts", "values", "fonts", "svga"
)
foreach ($cat in $categories) {
    New-Item -ItemType Directory -Path (Join-Path $KitDir $cat) -Force | Out-Null
}

function Get-AssetCategory([string]$name) {
    $n = $name.ToLower()
    if ($n -match '^icon_(random|group|game|chat)') { return "bottom-nav" }
    if ($n -match 'bottom|tab_nav|nav_') { return "bottom-nav" }
    if ($n -match 'group|ic_group') { return "group" }
    if ($n -match 'match|planet|mating') { return "match" }
    if ($n -match 'home_game|ludo|uno|game_') { return "games" }
    if ($n -match 'chat|message|msg_') { return "chat" }
    if ($n -match 'room|micro|seat|mic_') { return "room" }
    if ($n -match 'icon_my|profile|my_') { return "profile" }
    if ($n -match '_bg|background|bg_|match_bg|launch') { return "backgrounds" }
    if ($n -match 'gift|present') { return "gifts" }
    if ($n -match 'rank|trophy|charm|power') { return "ranking" }
    if ($n -match 'family|nobility|svip|vip|aristo') { return "family" }
    return "common"
}

# Prefer xxhdpi, then xhdpi, dedupe by base name
$drawableDirs = Get-ChildItem (Join-Path $Decompiled "res") -Directory |
    Where-Object { $_.Name -like "drawable*" -and $_.Name -notlike "*-ar*" -and $_.Name -notlike "*-ur*" -and $_.Name -notlike "*-en*" -and $_.Name -notlike "*-es*" -and $_.Name -notlike "*-hi*" -and $_.Name -notlike "*-id*" -and $_.Name -notlike "*-in*" -and $_.Name -notlike "*-ko*" -and $_.Name -notlike "*-pt*" -and $_.Name -notlike "*-ru*" -and $_.Name -notlike "*-th*" -and $_.Name -notlike "*-tr*" -and $_.Name -notlike "*-vi*" } |
    Sort-Object { if ($_.Name -eq "drawable-xxhdpi") { 0 } elseif ($_.Name -eq "drawable-xhdpi") { 1 } elseif ($_.Name -eq "drawable") { 2 } else { 3 } }, Name

$seen = @{}
$assets = @()

foreach ($dir in $drawableDirs) {
    Get-ChildItem $dir.FullName -File | ForEach-Object {
        $base = $_.BaseName
        if ($seen.ContainsKey($base)) { return }
        $seen[$base] = $true
        $cat = Get-AssetCategory $base
        $destDir = Join-Path $KitDir $cat
        $dest = Join-Path $destDir $_.Name
        Copy-Item $_.FullName $dest -Force
        $assets += [ordered]@{
            name = $base
            file = "$cat/$($_.Name)"
            ext = $_.Extension
            source = $dir.Name
            category = $cat
        }
    }
}

# Copy key layout XMLs
$keyLayoutPatterns = @(
    "fragment_home*.xml", "activity_main.xml", "layout_tab_*.xml",
    "item_home_*.xml", "item_group_*.xml", "include_match_*.xml",
    "view_room_*.xml", "item_rank*.xml", "dialog_room_*.xml",
    "fragment_group_*.xml", "activity_*group*.xml", "activity_*room*.xml"
)
$layoutDirs = Get-ChildItem (Join-Path $Decompiled "res") -Directory | Where-Object { $_.Name -like "layout*" }
$layouts = @()
foreach ($pattern in $keyLayoutPatterns) {
    foreach ($ld in $layoutDirs) {
        Get-ChildItem $ld.FullName -Filter $pattern -File -ErrorAction SilentlyContinue | ForEach-Object {
            $dest = Join-Path (Join-Path $KitDir "layouts") $_.Name
            if (-not (Test-Path $dest)) {
                Copy-Item $_.FullName $dest -Force
                $layouts += $_.Name
            }
        }
    }
}
$layouts = $layouts | Sort-Object -Unique

# Copy values (colors, dimens, styles)
$valuesDir = Join-Path $Decompiled "res\values"
foreach ($vf in @("colors.xml", "dimens.xml", "styles.xml", "strings.xml")) {
    $src = Join-Path $valuesDir $vf
    if (Test-Path $src) { Copy-Item $src (Join-Path $KitDir "values\$vf") -Force }
}

# Copy bottom-nav demo assets (curated)
$demoDirs = @("bottom-nav-demo", "group-section-demo", "match-section-demo", "games-section-demo")
foreach ($demo in $demoDirs) {
    $src = Join-Path $InspectDir $demo
    if (Test-Path $src) {
        $dest = Join-Path $KitDir "curated\$demo"
        Copy-Item $src $dest -Recurse -Force
    }
}

# Build catalog
$catalog = [ordered]@{
    apk = "Hilo-4.16.0.apk"
    package = "com.qiahao.nextvideo"
    decompiledAt = (Get-Item (Join-Path $Decompiled "apktool.yml")).LastWriteTime.ToString("o")
    stats = [ordered]@{
        totalAssets = $assets.Count
        layouts = $layouts.Count
        categories = ($assets | Group-Object category | ForEach-Object { [ordered]@{ name = $_.Name; count = $_.Count } })
    }
    screens = [ordered]@{
        mainShell = "fragment_home.xml - ViewPager + CustomTabLayout bottom nav (70dp), match_bg background"
        bottomNavTabs = "Match (icon_random), Group (icon_group), Game (icon_game), Chat (icon_chat)"
        groupSection = "fragment_home_room.xml - CommonTabLayout top tabs (Related/Popular/Discover), ic_group_top_bg_all"
        matchSection = "fragment_home_matching.xml - PlanetsView carousel, match cards grid"
        gamesSection = "fragment_home_game.xml - home_game_bg, RecyclerView game rooms"
        chatSection = "fragment_home_chat.xml"
    }
    designTokens = [ordered]@{
        bottomNavHeight = "70dp"
        groupTopBgHeight = "151dp"
        groupTabTextSelected = "#FFFFFFFF"
        groupTabTextUnselected = "#80FFFFFF"
        groupTabTextSize = "15sp"
        bottomMarginForContent = "56dp"
    }
    keyLayouts = $layouts
    assets = $assets
}

$catalog | ConvertTo-Json -Depth 6 | Set-Content $CatalogJson -Encoding UTF8
Write-Host "Done. Assets: $($assets.Count), Layouts: $($layouts.Count)"
Write-Host "Catalog: $CatalogJson"
