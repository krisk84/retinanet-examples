#!/bin/bash

pip install --no-cache-dir .
pip install tensorboardX

# Default to batch 30 for two Nvidia 1080 Tis
if [ "$1" ]; then
  BATCH="$1"
else
  BATCH="30"
fi

# Iterations have been changed to 30000 with milestones adjusted accordingly
retinanet train redaction.pth --backbone ResNet34FPN  \
    --fine-tune retinanet_rn34fpn.pth  --classes 1 --lr 0.00003  \
    --batch "$BATCH" --images /data/open_images/train_faces  \
    --annotations /data/open_images/train_faces.json  \
    --val-images /data/open_images/validation \
    --val-annotations /data/open_images/val_faces.json --val-iters 3000  \
    --resize 800  --max-size 880 --iters 30000 \
    --milestones 15000 22500 --logdir logs/ | tee redaction.log
