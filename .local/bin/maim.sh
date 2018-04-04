#!/bin/bash

PNG=~/pics/screenshots/$(date +%Y-%m-%dT%H:%M:%S).png
maim -q -s -k $PNG
xclip -selection clipboard -t image/png -in $PNG
