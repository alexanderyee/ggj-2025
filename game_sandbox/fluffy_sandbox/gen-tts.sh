#!/bin/sh
# generate the TTS voices for crebs

for voice in Rishi Samantha Junior Fred Daniel Daria ; do
    echo $voice
    for word in creb pinch peench bubbles "i peench you" ; do
        say -v $voice "$word"
    done
done
