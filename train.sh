#!/bin/bash

# Nasty hack because pip list and pipes are busted
if [ ! -r pip_deps_installed ]; then
  pip install --no-cache-dir .
  pip install tensorboardX
  touch pip_deps_installed
fi

if [ ! -r retinanet_rn34fpn.pth ]; then
  wget https://github.com/NVIDIA/retinanet-examples/releases/download/19.04/retinanet_rn34fpn.zip
  unzip -j retinanet_rn34fpn.zip
fi

if [ "$1" ]; then
  BATCH="$1"
else
  BATCH="30"
fi

rm -rf logs
mkdir -p logs

time retinanet train redaction.pth --backbone ResNet34FPN  \
    --fine-tune retinanet_rn34fpn.pth  --classes 1 --lr 0.00003  \
    --batch "$BATCH" --images /data/open_images/train_faces  \
    --annotations /data/open_images/train_faces.json  \
    --val-images /data/open_images/validation \
    --val-annotations /data/open_images/val_faces.json --val-iters 3000  \
    --resize 800  --max-size 880 --iters 30000 \
    --milestones 15000 22500 --logdir logs/ | tee redaction.log

if [ -r redaction.pth ]; then
  time retinanet export redaction.pth redaction.onnx --size 512 864 --batch 4
fi
