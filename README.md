# zenity-translate
Use Zenity to translate selected text and play pronounciations via Translate-shell

# Dependencies
**- X11 display server** (for xclip and wmctrl) (no Wayland)  
**- wmctrl** (used for closing existing Translate windows)  
**- xclip** (used to grab selected text)  
**- translate-shell** (does the brunt of the work here. uses google engine by default)  
**- zenity** (graphical display for translated text)  
**- notify-send** (for alerting users of errors. transient notifications only, so no clutter)  
**- gnome-terminal** (for the interactive shell portion of the script. can definitely be modified to other terminals)  
**- NormCap** (OCR app used to get text from a selected rectangle on screen) https://dynobo.github.io/normcap/
_note: i used the flatpak install of normcap in this script. it does make sense to use a more traditional install method as a requirement in a script, but this was what was on my system at the time and i was too lazy to track down a .deb file (it is not in the apt repos)_

# Installation
Add the .sh file to `$PATH`. make sure to `chmod +x` it
Add a keybind to execute the script (different depending on OS, most likely in keyboard settings)

# Usage
Select text in any app, press your keybind.  
Zenity window will pop up and show the text  
Translated output defaults to English but you can change the `TARGET_LANGCODE` in the script. However, Zenity buttons and the popup window title are not localized (hardcoded english).

Alternatively, use the "Screen Select" button to open NormCap and drag a rectangle across the screen, to detect text within. You may need to download OCR packages for different languages within NormCap. I also recommend turning off its notifications.

# Demo
(video has spoken translation)

https://github.com/Ao1Pointblank/zenity-translate/assets/88149675/d8af6c4b-f757-44b0-b1bc-a60e425de248

# To-do
detect which install of normcap is installed, and disable Screen Select if none is found
