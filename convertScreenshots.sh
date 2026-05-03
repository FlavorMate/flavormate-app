#!/usr/bin/env sh
# Converts all generated screenshots into reduced .webp images for GitHub use
find metadata/. -name "*.png" -exec sh -c 'magick "$1" -thumbnail "4000x800>" -quality 80 "${1%.png}.webp"' sh {} \;
