# Hilo 4.16.0 Reverse Engineering Reference

Reverse-engineered from `Hilo-4.16.0.apk` (package: `com.qiahao.nextvideo`).

## Quick access

| Resource | Path |
|----------|------|
| Full decompiled APK | `.apk-inspect-temp/hilo-4.16-decompiled/` |
| Organized design kit | `.apk-inspect-temp/hilo-design-kit/` |
| Asset catalog (JSON) | `.apk-inspect-temp/hilo-design-kit/catalog.json` |
| Visual browser | `hilo-design-catalog.html` (open in browser) |
| Section previews | `hilo-bottom-nav-preview.html`, `hilo-group-section-preview.html`, `hilo-match-section-preview.html`, `hilo-games-section-preview.html` |
| Re-run extraction | `scripts/hilo-reverse-engineer.ps1` |

## App structure

Hilo uses a single home shell with **4 bottom tabs** and a **ViewPager** for content:

```
fragment_home.xml
├── match_bg (full-screen background)
├── ViewPager (4 pages)
│   ├── fragment_home_matching.xml   → Match tab
│   ├── fragment_home_room.xml       → Group tab
│   ├── fragment_home_game.xml       → Game tab
│   └── fragment_home_chat.xml       → Chat tab
└── CustomTabLayout (bottom, 70dp height)
    ├── icon_random (Match)
    ├── icon_group (Group)
    ├── icon_game (Game)
    └── icon_chat (Chat)
```

## Bottom navigation

| Tab | Selected icon | Unselected icon |
|-----|---------------|-----------------|
| Match | `icon_random_selected.webp` | `icon_random_unselected.webp` |
| Group | `icon_group_selected.webp` | `icon_group_unselected.webp` |
| Game | `icon_game_selected.webp` | `icon_game_unselected.webp` |
| Chat | `icon_chat_selected.webp` | `icon_chat_unselected.webp` |

- Height: **70dp**
- Tab item layout: `layout_tab_bottom.xml` (text above icon)
- Icons are 3D gold-style webp pairs (xxhdpi recommended)
- Copied to Flutter: `assets/png/bottomNav/hilo/`

## Group section (audio rooms)

Layout: `fragment_home_room.xml`

- Top background: `ic_group_top_bg_all` (151dp height)
- Top tabs: `CommonTabLayout` with margins 55dp left/right
  - Selected text: `#FFFFFFFF`, unselected: `#80FFFFFF`, size 15sp
  - Tabs: Related / Popular / Discover (from strings + code)
- Search icon: `icon_group_search_all`
- Content: `ViewPager` + room list items (`item_group_popular*.xml`)
- Bottom padding: 56dp (for bottom nav)

## Match section

Layout: `fragment_home_matching.xml`

- `PlanetsView` — scrolling avatar planet carousel
- Diamond/gem balance bar at top
- Grid of match cards via `include_match_big_item.xml` / `include_match_min_item.xml`
- Background: `match_bg`
- SVGA animations in `assets/svga/` (e.g. `in_matching_pool.svga`)

## Games section

Layout: `fragment_home_game.xml`

- Full background: `home_game_bg.webp`
- Diamond balance + add button
- RecyclerView of game rooms (`item_home_game.xml`, `item_home_game_room.xml`)
- Game banners: Ludo, UNO, etc. (`home_game_ludo.webp`, `home_game_uno.webp`)

## Design kit categories

After running `scripts/hilo-reverse-engineer.ps1`:

| Folder | Contents | Count |
|--------|----------|-------|
| `bottom-nav/` | Tab icons | 48 |
| `group/` | Group section UI | 54 |
| `match/` | Match section UI | 43 |
| `games/` | Game section UI | 156 |
| `chat/` | Chat UI | 252 |
| `room/` | Live/audio room UI | 140 |
| `backgrounds/` | BG images | 465 |
| `profile/` | My/profile menu icons | 23 |
| `gifts/` | Gift assets | 22 |
| `ranking/` | Rank/trophy UI | 68 |
| `family/` | Family/SVIP/VIP | 150 |
| `layouts/` | Key XML layouts | 94 |
| `values/` | colors.xml, dimens.xml, styles.xml, strings.xml | 4 |
| `curated/` | Pre-picked demo assets per section | 114 |

## Key colors (from colors.xml)

Extract full palette from `.apk-inspect-temp/hilo-design-kit/values/colors.xml`.

Group tab tokens (from layout):
- Selected tab text: `#FFFFFFFF`
- Unselected tab text: `#80FFFFFF`
- Tab bar background: `#FFF5F5F5`

## How to re-extract

```powershell
cd Tiki-stream-app
powershell -ExecutionPolicy Bypass -File scripts/hilo-reverse-engineer.ps1
powershell -ExecutionPolicy Bypass -File scripts/generate-hilo-catalog-html.ps1
```

Then open `hilo-design-catalog.html` in a browser to search and preview all 2,687 assets.

## Using in TouchVoice Flutter app

Already integrated:
- Bottom nav Hilo icons → `assets/png/bottomNav/hilo/`
- Icon paths → `lib/utils/constants/app_constants.dart` (`hiloNav*` constants)
- Bottom nav UI → `lib/view/screens/dashboard_screen.dart`
- Group home tabs → `lib/view/screens/home/group/touchvoice_group_home_screen.dart`

To port more sections, copy assets from `hilo-design-kit/<category>/` into `assets/png/` and reference layout XMLs in `hilo-design-kit/layouts/` for exact sizing and structure.
