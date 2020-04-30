#!/bin/bash

# Change to 30k if you're curious
ITERATIONS="60k"

URL="https://redactionapp.blob.core.windows.net/openimages/$ITERATIONS.zip"

wget -c "$URL"

# Extract to the current path
unzip -j "$ITERATIONS".zip
