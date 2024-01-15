# zenity-translate
Use Zenity to translate selected text and play pronounciations via Translate-shell

# Dependencies
**X11 display server** (for xclip and wmctrl) (no Wayland)  
**wmctrl** (used for closing existing Translate windows)  
**xclip** (used to grab selected text)  
**translate-shell** (does the brunt of the work here. uses google engine by default)  
**zenity** (graphical display for translated text)  
**notify-send** (for alerting users of errors. transient notifications only, so no clutter)  
**gnome-terminal** (for the interactive shell portion of the script. can definitely be modified to other terminals)

# Installation
Add the .sh file to `$PATH`. make sure to `chmod +x` it
Add a keybind to execute the script (different depending on OS, most likely in keyboard settings)

# Usage
Select text in any app, press your keybind.  
Zenity window will pop up and show the text  
Translated output defaults to English but you can change the `TARGET_LANGCODE` in the script. However, Zenity buttons and the popup window title are not localized (hardcoded english).


# Demo
(video has spoken translation)




https://github.com/Ao1Pointblank/zenity-translate/assets/88149675/d8af6c4b-f757-44b0-b1bc-a60e425de248

