FROM ubuntu:16.04

RUN apt-get update

RUN apt-get install software-properties-common -y

RUN add-apt-repository ppa:jonathonf/ffmpeg-3 && \
    apt-get update && apt-get clean && apt-get install -y \
    ffmpeg libav-tools x264 x265 \
    alsa-base alsa-utils pulseaudio \
    curl \
    x11vnc \
    xvfb \
    fluxbox \
    wmctrl \
    wget \
    && wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add - \
    && echo "deb http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google.list \
    && apt-get update && apt-get -y install google-chrome-stable \
    && apt-get -y install unclutter

RUN apt-get install -y \
        python3 \
        python3-pip \
        python3-setuptools \
        groff \
        less \
    && pip3 install --upgrade pip

RUN pip3 --no-cache-dir install --upgrade awscli

RUN useradd apps \
    && mkdir -p /home/apps/videos \
    && chown -v -R apps:apps /home/apps

COPY bootstrap.sh /

USER apps
ENV VNC_SERVER_PASSWORD=password
ENV CAPTURE_URL="https://www.youtube.com/watch?v=-oIJvTaUKyM"

CMD '/bootstrap.sh'