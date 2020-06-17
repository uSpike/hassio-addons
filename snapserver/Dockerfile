ARG BUILD_FROM=homeassistant/amd64-base:3.11


## librespot
FROM ${BUILD_FROM} as librespot
WORKDIR /usr/src

RUN apk add --no-cache \
    git \
    cargo \
    portaudio-dev \
    protobuf-dev

ARG LIBRESPOT_VERSION

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

ARG SNAPCAST_VERSION

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

ARG SNAPWEB_VERSION

RUN apk add --no-cache python3

RUN git clone https://github.com/badaix/snapweb.git snapweb \
 && cd snapweb \
 && git checkout ${SNAPWEB_VERSION}
COPY patches/snapweb /usr/src/snapweb/patches
RUN cd /usr/src/snapweb && git apply patches/0001-Change-path.patch

COPY --from=librespot /usr/bin/librespot /usr/bin/librespot

WORKDIR /
COPY rootfs /
