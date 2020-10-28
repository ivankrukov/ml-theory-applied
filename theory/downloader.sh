#!/bin/bash

for url in `cat sources`; do
	youtube-dl -xf 'best[ext=mp4]/mp4' "$url" --output "raw/%(title)s.%(ext)s"
done

for m4af in raw/*; do
	ffmpeg -i "$m4af" "${m4af//m4a/wav}"
done
rm -r raw/*.m4a
