set NAME date +"%F-%T"
XCURSOR_SIZE=24 grim -g "$(slurp)" ~/Pictures/($NAME).png
wl-copy <~/Pictures/($NAME).png
