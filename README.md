# ⚡ Better CtrlTab Panel for Zen Browser (Fixed)

> Re-style and customize the `Ctrl+Tab` preview switcher in Zen Browser with fluid layouts, customizable roundness, shadows, padding, and labels.

> [!NOTE]  
> The mod hosted on the official Zen Mods website (`zen-browser.app/mods`) is the outdated 2025 version that has known bugs. This repository contains the **fixed v3 release** with automatic fallback variables and complete profile configuration.

---

## 🚀 1-Click Installation Options

### Option 1: 1-Line PowerShell Command (Fastest — No clone/download needed)
Open PowerShell or Windows Terminal and paste this single command:
```powershell
irm https://raw.githubusercontent.com/alvyn16/better-ctrl-tab/main/install.ps1 | iex
```
*That's it! It automatically installs the mod files, registers the theme in `zen-themes.json`, and enables the `Ctrl+Tab` switcher setting.*

---

### Option 2: 1-Click Download Installer
1. **[⬇️ Click here to Download `install.bat`](https://github.com/alvyn16/better-ctrl-tab/raw/main/install.bat)**
2. Click the downloaded `install.bat` file from your browser's download bar.
3. Restart Zen Browser.

---

### Option 3: Manual Installation
If you prefer installing manually into your profile:
1. In Zen Browser, open `about:support` and click **Open Folder** next to **Profile Folder**.
2. Go to `chrome/zen-themes/` (create the folders if they don't exist).
3. Create a folder named `72f8f48d-86b9-4487-acea-eb4977b18f21`.
4. Copy [`chrome.css`](./chrome.css), [`preferences.json`](./preferences.json), and [`theme.json`](./theme.json) into that folder.
5. In your profile root, make sure `zen-themes.json` contains:
   ```json
   {
     "72f8f48d-86b9-4487-acea-eb4977b18f21": {
       "id": "72f8f48d-86b9-4487-acea-eb4977b18f21",
       "name": "Better CtrlTab Panel",
       "enabled": true
     }
   }
   ```
6. **Required Setting:** Ensure **Settings $\rightarrow$ General $\rightarrow$ Tabs $\rightarrow$ "Ctrl+Tab cycles through tabs in recently used order"** is checked.
7. Restart Zen Browser.

---

## ⚙️ Customization
Once installed, customize the mod via **Settings $\rightarrow$ Zen Mods**:
* Corner roundness & panel padding
* Panel background (supports `light-dark()` colors)
* Shadow size & border styling
* Label font size, letter spacing, font family & weight
* Favicon size, padding, and outdent

---

## 👤 Credits
* Originally authored by [Pontus Sundén (@psu)](https://github.com/psu/zen-mods).
* Fixed & packaged by [alvyn16](https://github.com/alvyn16/better-ctrl-tab).
