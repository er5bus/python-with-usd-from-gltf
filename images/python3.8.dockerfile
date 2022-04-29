FROM python:3.8-buster as compile-image


LABEL maintainer="Rami sfari <rami2sfari@gmail.com>"

ENV PYTHONPATH=/app
ENV PYTHONUNBUFFERED 1

# ---------------------------------------------------------------------
# Configuration
WORKDIR /usr/src/usd

ARG USD_RELEASE="21.02"
ARG USD_INSTALL="/usr/local/usd"
ENV PYTHONPATH="${PYTHONPATH}:${USD_INSTALL}/lib/python"
ENV PATH="${PATH}:${USD_INSTALL}/bin"

# Dependencies
RUN apt-get -qq update && apt-get install -y --no-install-recommends \
    git build-essential cmake nasm \
    libxrandr-dev libxcursor-dev libxinerama-dev libxi-dev && \
    rm -rf /var/lib/apt/lists/*

# Build + install USD
RUN git clone --branch "v${USD_RELEASE}" --depth 1 https://github.com/PixarAnimationStudios/USD.git /usr/src/usd
RUN python ./build_scripts/build_usd.py --verbose --prefer-safety-over-speed --no-examples --no-tutorials --no-python --no-imaging --no-usdview --draco "${USD_INSTALL}" && \
  rm -rf "${USD_REPO}" "${USD_INSTALL}/build" "${USD_INSTALL}/src"

# Configuration
ARG UFG_RELEASE="master"
ARG UFG_SRC="/usr/src/ufg/usd_from_gltf"
ARG UFG_INSTALL="/usr/local/ufg"
ENV USD_DIR="/usr/local/usd"
ENV LD_LIBRARY_PATH="${USD_DIR}/lib:${UFG_SRC}/lib"
ENV PATH="${PATH}:${UFG_INSTALL}/bin"
ENV PYTHONPATH="${PYTHONPATH}:${UFG_INSTALL}/python"

WORKDIR /usr/src/ufg

# Build + install usd_from_gltf
RUN git clone --branch "${UFG_RELEASE}" https://github.com/google/usd_from_gltf.git && \
    python "${UFG_SRC}/tools/ufginstall/ufginstall.py" -v "${UFG_INSTALL}" "${USD_DIR}" && \
    cp -r "${UFG_SRC}/tools/ufgbatch" "${UFG_INSTALL}/python" && \
    rm -rf "${UFG_SRC}" "${UFG_INSTALL}/build" "${UFG_INSTALL}/src"
# ---------------------------------------------------------------------

FROM python:3.8-slim

ARG USD_INSTALL="/usr/local/usd"
COPY --from=compile-image $USD_INSTALL $USD_INSTALL
ENV PYTHONPATH="${PYTHONPATH}:${USD_INSTALL}/lib/python"
ENV PATH="${PATH}:${USD_INSTALL}/bin"

ARG UFG_INSTALL="/usr/local/ufg"
COPY --from=compile-image $UFG_INSTALL $UFG_INSTALL
ENV PATH="${PATH}:${UFG_INSTALL}/bin"
ENV PYTHONPATH="${PYTHONPATH}:${UFG_INSTALL}/python"

ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONUNBUFFERED 1
