#!/usr/bin/env bash
#dependencies: wmctrl xclip translate-shell zenity notify-send

#the language which selected words will be translated into (your native language)
#use ``trans -R`` to get a full list of language codes
TARGET_LANGCODE=en

#close existing translate shell windows
wmctrl -c "Translation";

TEMPFILE=$(mktemp);
xclip -o > $TEMPFILE

FILTERED_TEXT=$(cat "$TEMPFILE" | tr '\r\n' ' ' | tr '`' "'" )
DETECTED_LANG=$(echo "$FILTERED_TEXT" | trans -j -identify -no-ansi | grep --color=never "Name" | awk '{$1=""; sub(/^[ \t]+/, ""); print $0}')
DETECTED_LANGCODE=$(echo "$FILTERED_TEXT" | trans -j -identify -no-ansi | grep --color=never "Code" | awk '{$1=""; sub(/^[ \t]+/, ""); print $0}')

#checks if too much content for zenity window. this is a workaround for bad software. switch to YAD or Rofi instead of zenity?
echo "$FILTERED_TEXT" | wc -m
if [ "$(echo "$FILTERED_TEXT" | wc -m)" -le "5000" ] ; then
OUTPUT=$(zenity  --title="Translation - $DETECTED_LANG Detected" \
        --width=400 \
        --info \
        --window-icon='~/.icons/custom/google-translate.png' \
        --text="$(echo "$FILTERED_TEXT" | trans -brief -j -target $TARGET_LANGCODE )" \
        --ok-label=Close \
        --icon-name=document-export \
        --extra-button "$DETECTED_LANG Pronunciation" \
        --extra-button "Speak Translation" \
        --extra-button "Interactive Shell" &
    #checks if input is > 1000 bytes; be patient while googling
	if [ "$(wc -c < $TEMPFILE)" -gt "1000" ] ; then
    	notify-send -u low -h int:transient:1 -i image-loading 'Fetching translation...'
    fi;
)
else
OUTPUT="ZENITY_TRANSLATE_TEXT_TOO_LONG"
fi;

if [[ "$OUTPUT" == "ZENITY_TRANSLATE_TEXT_TOO_LONG" ]] ; then
	notify-send -u low -h int:transient:1 -i error 'Selected text too long' 'Try a smaller selection'
fi

#what the extra buttons do
if [[ "$OUTPUT" == "$DETECTED_LANG Pronunciation" ]] ; then
	echo "$FILTERED_TEXT" | trans -brief -j -speak
else
	if [[ "$OUTPUT" == "Speak Translation" ]] ; then
		echo "$FILTERED_TEXT" | trans -brief -j -target "$TARGET_LANGCODE" -play
	fi;
	if [[ "$OUTPUT" == "Interactive Shell" ]] ; then
		gnome-terminal -- bash -c 'echo "Language Codes:" ; trans -R ; echo "Usage: source-lang:target-lang, Example: en:de" ; trans -shell -brief -join-sentence -play'
	fi;
fi;
rm ${TEMPFILE}
