#!/usr/bin/env bash
set -e
docker build -t web-video-capture -t gcr.io/hackaton2018-site-recorder/web-video-capture-image .
docker run \
    	--rm --name web-video-capture \
        -v $(pwd):/home/apps/videos \
        -e JOB_ID="job-$(pwgen 10 1)" \
        --user apps \
        --privileged web-video-capture