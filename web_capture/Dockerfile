FROM ubuntu:16.04

RUN apt-get update

RUN apt-get install software-properties-common -y

RUN add-apt-repository ppa:jonathonf/ffmpeg-3 && \
    apt-get update && apt-get clean && apt-get install -y \
    ffmpeg libav-tools x264 x265 \
    alsa-base alsa-utils pulseaudio \
    x11vnc \
    xvfb \
    fluxbox \
    wmctrl \
    wget \
    && wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add - \
    && echo "deb http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google.list \
    && apt-get update && apt-get -y install google-chrome-stable

RUN apt-get -y install unclutter

RUN useradd apps \
    && mkdir -p /home/apps/videos \
    && chown -v -R apps:apps /home/apps

COPY bootstrap.sh /

CMD '/bootstrap.sh'