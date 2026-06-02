# 🌌 StellarPages — Ebook Reader

> *A universe of stories at your fingertips.*

A beautiful space-themed Flutter ebook reader app, inspired by Moon+ Reader.

---

## 📁 Project Structure

```
lib/
├── main.dart                    # App entry point
├── models/
│   ├── book_model.dart          # Book, Bookmark, Highlight data models
│   └── book_model.g.dart        # Hive adapter (auto-generated)
├── themes/
│   └── app_themes.dart          # 10 space themes (Deep Space, Nebula, etc.)
├── utils/
│   └── app_state.dart           # State management (ChangeNotifier)
├── widgets/
│   ├── starfield_background.dart # Animated star background
│   └── book_card.dart            # Book grid card widget
└── screens/
    ├── bookshelf_screen.dart     # Home — book library grid
    ├── reader_screen.dart        # Full EPUB/PDF/TXT reader
    ├── settings_screen.dart      # Themes, font, cloud sync
    └── stats_screen.dart         # Reading statistics
```

---

## 🚀 Quick Start

### 1. Install Flutter
Follow https://flutter.dev/docs/get-started/install

### 2. Add dependencies
```bash
cd stellar_pages
flutter pub add provider uuid
flutter pub get
```

### 3. Run
```bash
flutter run
```

---

## 📦 Dependencies

| Package | Purpose |
|---|---|
| `epub_view` | Render EPUB files |
| `syncfusion_flutter_pdfviewer` | Render PDF files |
| `file_picker` | Import files from device |
| `hive` + `hive_flutter` | Local database for books/bookmarks |
| `flutter_tts` | Text-to-speech |
| `provider` | State management |
| `percent_indicator` | Progress bars |
| `uuid` | Unique IDs for books |

---

## ✨ Features Built

### MVP (Complete)
- [x] **Bookshelf** — Grid layout with book covers and progress
- [x] **EPUB Reader** — Full text rendering with chapter navigation
- [x] **PDF Reader** — Syncfusion PDF viewer
- [x] **TXT Reader** — Scrollable text view
- [x] **10 Themes** — Deep Space, Nebula, Aurora, Starlight, Mars, Sunrise, Sepia, Black Hole, Cosmic Dust, Galaxy Mint
- [x] **Font Size + Line Height** — Adjustable sliders
- [x] **Font Family** — Georgia, Serif, Monospace, Sans-serif
- [x] **Bookmarks** — Add/view bookmarks with notes
- [x] **Reading Timer** — Track time spent reading
- [x] **Progress Tracking** — Per-book progress %
- [x] **Auto-scroll** — 5 speed levels
- [x] **TTS** — Text-to-speech toggle
- [x] **Stats Screen** — Total time, books read, progress

### Animated
- [x] **Starfield Background** — Twinkling animated stars (dark themes)
- [x] **Smooth theme transitions**

---

## 🔧 Next Steps (v2.0)

### Cloud Sync (Anti-Gravity Cloud)
```dart
// Wire up in settings_screen.dart
// 1. Add google_sign_in + googleapis packages
// 2. Authenticate user
// 3. Upload Hive box file to Google Drive
// 4. Download on new device
```

### Dictionary (tap word to define)
```dart
// In reader_screen.dart, wrap text with SelectableText
// OnSelectionChanged → show definition popup
// Use a dictionary API or local wordlist
```

### Highlights
```dart
// SelectableText with onSelectionChanged
// Show color picker popup
// Save Highlight to Hive via AppState.addHighlight()
```

### Volume Key Paging (Android)
```dart
// Add to MainActivity.kt:
// override fun onKeyDown(keyCode: Int, event: KeyEvent): Boolean {
//     if (keyCode == KeyEvent.KEYCODE_VOLUME_UP) { /* next page */ }
//     if (keyCode == KeyEvent.KEYCODE_VOLUME_DOWN) { /* prev page */ }
// }
```

---

## 🎨 Themes

| # | Name | Emoji | Style |
|---|---|---|---|
| 1 | Deep Space | 🌌 | Dark blue — default |
| 2 | Nebula | 🔮 | Purple/pink |
| 3 | Aurora | 🌈 | Teal/green |
| 4 | Starlight | ⭐ | Dark gold |
| 5 | Cosmic Dust | 💫 | Blue-grey |
| 6 | Sunrise Planet | 🌅 | Light/day mode |
| 7 | Old Galaxy | 📜 | Sepia |
| 8 | Mars | 🔴 | Dark red |
| 9 | Black Hole | ⚫ | Pure black |
| 10 | Galaxy Mint | 🌿 | Dark mint |

---

## 📱 Supported Formats
- `.epub` / `.epub3` — Full chapter navigation
- `.pdf` — Page-by-page viewer
- `.txt` — Plain text reader

---

## 🏪 Play Store Listing

**Title:** StellarPages - Ebook Reader  
**Short:** A universe of stories. Read EPUB, PDF, TXT offline.  
**Description:**  
Navigate the cosmos of literature with StellarPages — a beautiful, fast, offline ebook reader.

✨ **Features:**  
• Read EPUB, PDF, TXT files  
• 10 stunning space themes  
• Adjustable font size & family  
• Auto-scroll at 5 speeds  
• Bookmarks & notes  
• Text-to-speech  
• Reading statistics  
• Anti-Gravity Cloud sync (coming soon)

---

*Built with Flutter 💙 by StellarPages*
