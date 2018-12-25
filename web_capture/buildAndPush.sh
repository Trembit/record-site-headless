#!/usr/bin/env bash
set -e
docker build -t web-video-capture -t gcr.io/hackaton2018-site-recorder/web-video-capture-image .
docker push gcr.io/hackaton2018-site-recorder/web-video-capture-image