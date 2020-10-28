#!/bin/bash

# params for initial data processing
SPLIT_TIME=4
# FREQUENCY=

# download youtube audio using the sources file
for url in `cat sources`; do
	youtube-dl -xf 'best[ext=mp4]/mp4' "$url" --output "raw/%(title)s.%(ext)s"
done

# WaveGAN performs fastest when training wav files. use ffmpeg to convert to wav
for m4af in raw/*; do
	ffmpeg -i "$m4af" "${m4af//m4a/wav}"
done
find raw -type f ! -name "*.wav" -delete

# split files into SPLIT_TIME second chunks for WaveGAN
mkdir processed
for file in raw/*.wav; do
	ffmpeg -i "$file" -f segment -segment_time $SPLIT_TIME -c copy processed/%03d."${file#'raw/'}"
done

