###Build docker

    docker build -t web-video-capture .

###Run Container
    docker run -p 5900:5900 \
        -v /Users/bohdan/Projects/web-video-capture/videos:/home/apps/videos \
        -e VNC_SERVER_PASSWORD=password \
        -e CAPTURE_URL="https://www.youtube.com/watch?v=-oIJvTaUKyM" \
        --user apps \
        --privileged web-video-capture

NOTICE. In order to stop capturing and not to compromise the mp4 output video run the following command.

##Stop recording
    docker exec <container_id> pkill ffmpeg