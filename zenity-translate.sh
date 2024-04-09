#!/bin/bash
#DEPENDENCIES:
#wmctrl xclip translate-shell zenity notify-send
#
#Normcap from Flathub: (for OCR screen selection)
#https://dynobo.github.io/normcap/

#the language which selected words will be translated into (your native language)
#use ``trans -R`` to get a full list of language codes
TARGET_LANGCODE=en

#close existing translate shell windows
wmctrl -c "Translation";

TEMPFILE=$(mktemp);

#prefer current selection as input but fallback to clipboard
if [[ -n "$(xclip -o -selection primary)" ]] ; then
    xclip -o -selection primary > $TEMPFILE
else
    xclip -o -selection clipboard > $TEMPFILE
fi


FILTERED_TEXT=$(cat "$TEMPFILE" | tr '\r\n' ' ' | tr '`' "'" )
DETECTED_LANG=$(echo "$FILTERED_TEXT" | trans -j -identify -no-ansi -no-browser | grep --color=never "Name" | awk '{$1=""; sub(/^[ \t]+/, ""); print $0}')
DETECTED_LANGCODE=$(echo "$FILTERED_TEXT" | trans -j -identify -no-ansi -no-browser | grep --color=never "Code" | awk '{$1=""; sub(/^[ \t]+/, ""); print $0}')

#checks if too much content for zenity window. this is a workaround for bad software. switch to YAD or Rofi instead of zenity?
echo "$FILTERED_TEXT" | wc -m
if [ "$(echo "$FILTERED_TEXT" | wc -m)" -le "5000" ] ; then
OUTPUT=$(zenity  --title="Translation - $DETECTED_LANG Detected" \
        --width=400 \
        --info \
        --window-icon='~/.icons/custom/google-translate.png' \
        --text="$(echo "$FILTERED_TEXT" | trans -brief -j -no-browser -target $TARGET_LANGCODE )" \
        --ok-label=Close \
        --icon-name=document-export \
        --extra-button "Screen Select" \
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
if [[ "$OUTPUT" == "Screen Select" ]] ; then
	#run OCR tool, which saves selected text to xclip clipboard, then run translate-zenity again
	/usr/bin/flatpak run com.github.dynobo.normcap &&
	$0
else
	if [[ "$OUTPUT" == "$DETECTED_LANG Pronunciation" ]] ; then
		echo "$FILTERED_TEXT" | trans -brief -j -speak -no-browser
	else
		if [[ "$OUTPUT" == "Speak Translation" ]] ; then
			echo "$FILTERED_TEXT" | trans -brief -j -target "$TARGET_LANGCODE" -play -no-browser
		fi;
		if [[ "$OUTPUT" == "Interactive Shell" ]] ; then
			cd '/home/pointblank/.translate'
			gnome-terminal --wait -- bash -c '
				echo "Language Codes:" ;
				trans -R ;
				echo "Usage: source-lang:target-lang, Example: en:de" ;
				trans -shell -brief -join-sentence -play -download-audio -no-browser'
			for ts_file in *.ts; do
    			mp3_file="${ts_file%.ts}.mp3"
    			mv "$ts_file" "$mp3_file"
			done
		fi;
	fi;
fi;
rm ${TEMPFILE}
