$Root = Split-Path -Parent $PSScriptRoot
$KitDir = Join-Path $Root ".apk-inspect-temp\hilo-design-kit"
$CatalogPath = Join-Path $KitDir "catalog.json"
$OutHtml = Join-Path $Root "hilo-design-catalog.html"

$catalog = Get-Content $CatalogPath -Raw -Encoding UTF8 | ConvertFrom-Json

$catCounts = $catalog.assets | Group-Object category | Sort-Object Name
$catOptions = ($catCounts | ForEach-Object { "<option value='$($_.Name)'>$($_.Name) ($($_.Count))</option>" }) -join "`n"

$assetCards = ($catalog.assets | ForEach-Object {
    $src = ".apk-inspect-temp/hilo-design-kit/$($_.file)"
    $isImage = $_.ext -match '\.(png|webp|jpg|jpeg|gif|svg)$'
    $preview = if ($isImage) {
        "<img src='$src' alt='$($_.name)' loading='lazy' />"
    } else {
        "<div class='no-preview'>$($_.ext)</div>"
    }
    @"
    <div class="card" data-cat="$($_.category)" data-name="$($_.name)">
      <div class="thumb">$preview</div>
      <div class="meta">
        <div class="name">$($_.name)</div>
        <div class="cat">$($_.category)</div>
      </div>
    </div>
"@
}) -join "`n"

$layoutList = ($catalog.keyLayouts | ForEach-Object {
    "<li><code>$_</code> - <a href='.apk-inspect-temp/hilo-design-kit/layouts/$_'>XML</a></li>"
}) -join "`n"

$html = @"
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1" />
  <title>Hilo 4.16.0 Design Catalog</title>
  <style>
    * { box-sizing: border-box; }
    body { margin: 0; font-family: system-ui, sans-serif; background: #12081f; color: #f5f0ff; }
    header { padding: 20px 24px; background: linear-gradient(135deg,#2a1048,#12081f); border-bottom: 1px solid #ffd76a44; }
    h1 { margin: 0 0 6px; font-size: 1.5rem; color: #ffd76a; }
    .sub { opacity: .8; font-size: .9rem; }
    .toolbar { display: flex; gap: 12px; flex-wrap: wrap; padding: 16px 24px; position: sticky; top: 0; background: #1a0f2e; z-index: 10; border-bottom: 1px solid #ffffff15; }
    input, select { padding: 10px 12px; border-radius: 8px; border: 1px solid #ffffff22; background: #241538; color: #fff; }
    input { flex: 1; min-width: 200px; }
    .stats { padding: 0 24px 8px; font-size: .85rem; opacity: .75; }
    .grid { display: grid; grid-template-columns: repeat(auto-fill,minmax(130px,1fr)); gap: 12px; padding: 16px 24px 40px; }
    .card { background: #1e1233; border: 1px solid #ffffff12; border-radius: 10px; overflow: hidden; }
    .thumb { height: 100px; display: flex; align-items: center; justify-content: center; background: repeating-conic-gradient(#2a2040 0% 25%, #221838 0% 50%) 0 0/16px 16px; }
    .thumb img { max-width: 90%; max-height: 90%; object-fit: contain; }
    .no-preview { font-size: .75rem; opacity: .6; }
    .meta { padding: 8px; }
    .name { font-size: .72rem; word-break: break-all; line-height: 1.2; }
    .cat { font-size: .65rem; color: #ffd76a; margin-top: 4px; text-transform: uppercase; }
    section.docs { padding: 8px 24px 24px; }
    section.docs h2 { color: #ffd76a; font-size: 1.1rem; }
    section.docs ul { line-height: 1.7; }
    a { color: #9ad0ff; }
    code { background: #ffffff10; padding: 2px 6px; border-radius: 4px; font-size: .85rem; }
    .hidden { display: none !important; }
  </style>
</head>
<body>
  <header>
    <h1>Hilo 4.16.0 Design Catalog</h1>
    <div class="sub">Package: $($catalog.package) | $($catalog.stats.totalAssets) assets | $($catalog.stats.layouts) key layouts</div>
  </header>

  <section class="docs">
    <h2>Screen map</h2>
    <ul>
      <li><b>Main shell</b>: $($catalog.screens.mainShell)</li>
      <li><b>Bottom nav</b>: $($catalog.screens.bottomNavTabs)</li>
      <li><b>Group</b>: $($catalog.screens.groupSection)</li>
      <li><b>Match</b>: $($catalog.screens.matchSection)</li>
      <li><b>Games</b>: $($catalog.screens.gamesSection)</li>
      <li><b>Chat</b>: $($catalog.screens.chatSection)</li>
    </ul>
    <h2>Design tokens</h2>
    <ul>
      <li>Bottom nav height: <code>$($catalog.designTokens.bottomNavHeight)</code></li>
      <li>Group top bg height: <code>$($catalog.designTokens.groupTopBgHeight)</code></li>
      <li>Group tab selected: <code>$($catalog.designTokens.groupTabTextSelected)</code></li>
      <li>Group tab unselected: <code>$($catalog.designTokens.groupTabTextUnselected)</code></li>
      <li>Content bottom margin: <code>$($catalog.designTokens.bottomMarginForContent)</code></li>
    </ul>
    <h2>Key layout XML files</h2>
    <ul>$layoutList</ul>
    <p>Full decompiled source: <code>.apk-inspect-temp/hilo-4.16-decompiled/</code></p>
    <p>Organized kit: <code>.apk-inspect-temp/hilo-design-kit/</code></p>
  </section>

  <div class="toolbar">
    <input id="search" type="search" placeholder="Search asset name..." />
    <select id="category">
      <option value="">All categories</option>
      $catOptions
    </select>
  </div>
  <div class="stats" id="count"></div>
  <div class="grid" id="grid">
    $assetCards
  </div>

  <script>
    const search = document.getElementById('search');
    const category = document.getElementById('category');
    const cards = [...document.querySelectorAll('.card')];
    const count = document.getElementById('count');

    function filter() {
      const q = search.value.trim().toLowerCase();
      const cat = category.value;
      let visible = 0;
      cards.forEach(card => {
        const name = card.dataset.name.toLowerCase();
        const ok = (!q || name.includes(q)) && (!cat || card.dataset.cat === cat);
        card.classList.toggle('hidden', !ok);
        if (ok) visible++;
      });
      count.textContent = visible + ' assets shown';
    }
    search.addEventListener('input', filter);
    category.addEventListener('change', filter);
    filter();
  </script>
</body>
</html>
"@

$html | Set-Content $OutHtml -Encoding UTF8
Write-Host "Generated: $OutHtml"
