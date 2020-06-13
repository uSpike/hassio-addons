ARG BUILD_FROM=homeassistant/amd64-base:3.11


## librespot
FROM ${BUILD_FROM} as librespot
WORKDIR /usr/src

RUN apk add --no-cache \
    git \
    cargo \
    portaudio-dev \
    protobuf-dev

ARG LIBRESPOT_VERSION=e8ec5feb2260e9d2e3b8bfc927cc5211d626e015

RUN git clone https://github.com/librespot-org/librespot.git librespot \
 && cd librespot \
 && git checkout ${LIBRESPOT_VERSION} \
 && cargo build --jobs $(( $(nproc) + 1 )) --release --no-default-features \
 && cp target/release/librespot /usr/bin/librespot

## main image
FROM ${BUILD_FROM}
WORKDIR /usr/src

RUN apk add --no-cache \
    nginx \
    build-base \
    git \
    cmake \
    boost \
    asio-dev \
    avahi-dev \
    flac-dev \
    libvorbis-dev \
    alsa-lib-dev \
    opus-dev

ARG SNAPCAST_VERSION=01e7778b9a7a1cb95a291b0cddcd69934386d581

RUN git clone https://github.com/badaix/snapcast.git snapcast \
 && cd snapcast \
 && git checkout ${SNAPCAST_VERSION} \
 && git checkout $SNAPCAST_REF \
 && cd externals \
 && git submodule update --init --recursive \
 && cd .. \
 && cmake -B build \
      -DBUILD_WITH_FLAC=ON \
      -DBUILD_WITH_VORBIS=ON \
      -DBUILD_WITH_OPUS=ON \
      -DBUILD_WITH_AVAHI=ON \
 && make -C build -j $(( $(nproc) + 1 )) snapserver \
 && cp bin/snapserver /usr/bin/snapserver

ARG SNAPWEB_VERSION=c82213ccb514f71aee568d2e2d8d2e9b34716dea

RUN git clone https://github.com/badaix/snapweb.git snapweb \
 && cd snapweb \
 && git checkout ${SNAPWEB_VERSION} \
 && rm -rf /var/www \
 && cp -R page /var/www

COPY --from=librespot /usr/bin/librespot /usr/bin/librespot

WORKDIR /
COPY rootfs /
