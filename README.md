# HFlashPlayer (macOS Port)

A native macOS handler to automatically launch Flash content in standalone Ruffle from custom `hflash://` scheme URLs.

This repository is a native macOS port of [h-flash/HFlashPlayer](https://github.com/h-flash/HFlashPlayer), replacing the legacy Windows Forms/.NET launcher with a lightweight, universal Cocoa application.

---

## Features
- **Universal Binary:** Native support for both Apple Silicon (M1/M2/M3/M4) and Intel Macs.
- **Embedded Ruffle Engine:** No external dependencies or Homebrew prerequisites required.
- **Protocol Integration:** Registers `hflash://` seamlessly with macOS LaunchServices.

---

## Quick Start (macOS)

### 1. Install the Application
1. Download **`HFlashPlayer-macOS-Universal.dmg`** from the [Latest Release](https://github.com/nightc00re/HFlashPlayer_Mac/releases).
2. Open the `.dmg` and drag `HFlashPlayer.app` into `/Applications`.
3. Open `HFlashPlayer.app` once from Launchpad or Finder to allow macOS to register the protocol handler (you can close it right after).

### 2. Install the Browser Userscript
The userscript detects Flash elements on web pages and converts them into clickable `hflash://` links.

1. Install a userscript manager in your browser:
   - [Tampermonkey for Chrome](https://chrome.google.com/webstore/detail/tampermonkey/dhdgffkkebhmkfjojejmpbldmpobfkfo)
   - [Tampermonkey for Firefox](https://addons.mozilla.org/en-US/firefox/addon/tampermonkey/)
2. Install the script:
   - Click the Tampermonkey extension icon $\rightarrow$ **Dashboard** $\rightarrow$ **Utilities**.
   - Under **Install from URL**, paste:
     ```text
     [https://raw.githubusercontent.com/nightc00re/HFlashPlayer_Mac/main/ScriptInjector.user.js](https://raw.githubusercontent.com/nightc00re/HFlashPlayer_Mac/main/ScriptInjector.user.js)
     ```
   - Click **Install**.

### 3. Play
Visit any supported Flash site (such as [h-flash.com](https://h-flash.com)), click **"CLICK TO PLAY"**, and allow Chrome to open `HFlashPlayer`. The game will launch directly in an accelerated native Ruffle window.

---

## Troubleshooting

- **Nothing happens when clicking "CLICK TO PLAY":**
  Make sure you opened `HFlashPlayer.app` at least once from `/Applications` so macOS LaunchServices can associate `hflash://` with the app. You can also re-register manually in Terminal:
  ```bash
  /System/Library/Frameworks/CoreServices.framework/Frameworks/LaunchServices.framework/Support/lsregister -f /Applications/HFlashPlayer.app
