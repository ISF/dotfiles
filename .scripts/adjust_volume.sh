#!/bin/bash

if [[ -n $(find . -name '*.mp3') ]]; then
    mp3gain -o -s i *.mp3
fi
if [[ -n $(find . -name '*.flac') ]]; then
    metaflac --add-replay-gain *.flac
fi
