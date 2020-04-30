#!/bin/bash

URL="https://redactionapp.blob.core.windows.net/openimages/open_images.zip"

get_openimages() {
  for i in `seq -w 0 10`; do
    wget -c "$URL"."$i"
  done
}

build_zip() {
  echo "Assembling open_images.zip"
  cat open_images.zip.* > open_images.zip
}

extract_zip() {
  echo "Extracting open_images.zip quietly"
  unzip -q open_images.zip
}

if [ -d open_images ]; then
  echo "target open_images directory already exists, exiting"
  exit 1
fi

get_openimages
build_zip
extract_zip
