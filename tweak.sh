#!/usr/bin/env bash
set -xe

IMAGE=buildroot:2019.08-rc2

CONFIG=rpi4_norns_open_defconfig

# Make sure the Docker image is up to date
#docker pull $IMAGE

# Run the build
docker run --rm -ti \
  -v "${HOME}/.cache/buildroot-downloads":/buildroot/dl \
  -v "${HOME}/.cache/buildroot-ccache":/root/.buildroot-ccache \
  -v "${PWD}":/mycustombuildroot \
  -v "${PWD}/output/images":/buildroot/output/images \
  -v "${PWD}/output/graphs":/buildroot/output/graphs \
  -e BR2_EXTERNAL=/mycustombuildroot \
  -e BR2_GRAPH_OUT=png \
  $IMAGE
