# syntax=docker/dockerfile:1

ARG IDF=release-v5.0
FROM espressif/idf:$IDF
ARG ADF=v2.6
ENV ADF_PATH=/opt/esp/adf

RUN git clone https://github.com/espressif/esp-adf.git \
  -b $ADF                                              \
  --depth 1                                            \
  $ADF_PATH

RUN cd $ADF_PATH && git -c submodule."esp-idf".update=none submodule update --init --recursive

COPY esp-adf.patch /opt
RUN set -e; \
    git apply --reject --whitespace=fix /opt/esp-adf.patch || true

# Manually edit the conflicted file
RUN sed -i 's/GPIO_NUM_18/GPIO_NUM_33/g' /opt/esp/adf/components/audio_board/lyrat_v4_3/board_pins_config.c && \
    sed -i 's/GPIO_NUM_23/GPIO_NUM_32/g' /opt/esp/adf/components/audio_board/lyrat_v4_3/board_pins_config.c

RUN apt-get update && apt-get install -y \
    g++

WORKDIR /app
