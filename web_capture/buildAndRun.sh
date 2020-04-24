#!/usr/bin/env bash
set -e
docker build -t trembit/web-video-capture -t gcr.io/hackaton2018-site-recorder/web-video-capture-image .
docker run \
    	--rm --name web-video-capture \
        -v $(pwd):/home/apps/videos \
        -e JOB_ID="job-$(pwgen 10 1)" \
        --user apps \
        --privileged \
        trembit/web-video-capture
#        /bootstrap.sh last-video https://sdcast.ksdaemon.ru/podlove/file/665/s/webplayer/c/episode/SDCast-115.ogg
