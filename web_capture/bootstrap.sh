#!/bin/bash

# Based on: http://www.richud.com/wiki/Ubuntu_Fluxbox_GUI_with_x11vnc_and_Xvfb

main() {
    log_i "Starting audio server..."
    run_audio_server
    log_i "Starting xvfb virtual display..."
    launch_xvfb
    log_i "Starting window manager..."
    launch_window_manager
    log_i "Starting VNC server..."
    run_vnc_server
    log_i "Starting chrome..."
    open_chrome
    log_i "Starting ffmpeg..."
    start_capturing
}

launch_xvfb() {
    local xvfbLockFilePath="/tmp/.X1-lock"
    if [ -f "${xvfbLockFilePath}" ]
    then
        log_i "Removing xvfb lock file '${xvfbLockFilePath}'..."
        if ! rm -v "${xvfbLockFilePath}"
        then
            log_e "Failed to remove xvfb lock file"
            exit 1
        fi
    fi

    # Set defaults if the user did not specify envs.
    export DISPLAY=${XVFB_DISPLAY:-:1}
    local screen=${XVFB_SCREEN:-0}
    local resolution=${XVFB_RESOLUTION:-1280x960x24}
    local timeout=${XVFB_TIMEOUT:-5}

    # Start and wait for either Xvfb to be fully up or we hit the timeout.
    Xvfb ${DISPLAY} -screen ${screen} ${resolution} &
    local loopCount=0
    until xdpyinfo -display ${DISPLAY} > /dev/null 2>&1
    do
        loopCount=$((loopCount+1))
        sleep 1
        if [ ${loopCount} -gt ${timeout} ]
        then
            log_e "xvfb failed to start"
            exit 1
        fi
    done
}

launch_window_manager() {
    local timeout=${XVFB_TIMEOUT:-5}

    # Start and wait for either fluxbox to be fully up or we hit the timeout.
    fluxbox &
    local loopCount=0
    until wmctrl -m > /dev/null 2>&1
    do
        loopCount=$((loopCount+1))
        sleep 1
        if [ ${loopCount} -gt ${timeout} ]
        then
            log_e "fluxbox failed to start"
            exit 1
        fi
    done
}

run_vnc_server() {
    local passwordArgument='-nopw'

    if [ -n "${VNC_SERVER_PASSWORD}" ]
    then
        local passwordFilePath="${HOME}/.x11vnc.pass"
        if ! x11vnc -storepasswd "${VNC_SERVER_PASSWORD}" "${passwordFilePath}"
        then
            log_e "Failed to store x11vnc password"
            exit 1
        fi
        passwordArgument=-"-rfbauth ${passwordFilePath}"
        log_i "The VNC server will ask for a password"
    else
        log_w "The VNC server will NOT ask for a password"
    fi

    x11vnc -display ${DISPLAY} -forever ${passwordArgument} &>/dev/null &!
}

run_audio_server() {
    # Start the pulseaudio server
    pulseaudio -D --exit-idle-time=-1

    # Load the virtual sink and set it as default
    pacmd load-module module-virtual-sink sink_name=v1
    pacmd set-default-sink v1

    # set the monitor of v1 sink to be the default source
    pacmd set-default-source v1.monitor
}

open_chrome() {
    google-chrome --make-default-browser
    google-chrome -kiosk -fullscreen ${CAPTURE_URL} &>/dev/null &!
    #Hide pointer
    unclutter -idle 0.01 -root &>/dev/null &!
    sleep 2
}

start_capturing() {
    # Works --------
    # ffmpeg -y \
    #     -f pulse -ac 2 -i default \
    #     -f x11grab \
    #     -r 25 -s 1280x960 -i :1 -b:v 3m /home/apps/videos/out.mpeg

    ffmpeg -y \
        -f pulse -ac 2 -i default \
        -f x11grab \
        -r 25 -s 1280x960 -i :1 -c:v libx264 -b:v 3M -strict -2 -movflags faststart /home/apps/videos/out.mp4

}

log_i() {
    log "[INFO] ${@}"
}

log_w() {
    log "[WARN] ${@}"
}

log_e() {
    log "[ERROR] ${@}"
}

log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] ${@}"
}

control_c() {
    echo ""
    exit
}

trap control_c SIGINT SIGTERM SIGHUP

main

exit