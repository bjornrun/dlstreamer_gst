#!/bin/bash
# ==============================================================================
# Copyright (C) 2018-2019 Intel Corporation
#
# SPDX-License-Identifier: MIT
# ==============================================================================

set -e

VIDEO_EXAMPLES_PATH="/nfs/ailab/ride/gva/data/video/"
INTEL_MODELS_PATH="/nfs/ailab/ride/smb_demo/models"
MODELS_PATH="/nfs/ailab/ride/opt/intel/openvino_2021.3.394/deployment_tools/open_model_zoo/models/"
OPENVINO_PATH="/nfs/ailab/ride/opt/intel/openvino_2021.3.394/"
DEMO_PATH="/nfs/ailab/ride/smb_demo/demo_analytics"
IMAGE_NAME="bjornrun/smb-analytics-dev:latest"

for i in "$@"
do
case $i in
    -h|--help)
    echo "usage: sudo ./run_smb_docker_container.sh [--video-examples-path=<path>]"
    echo "[--intel-models-path=<path>] [--models-path=<path>] [--image-name=<name>]"
    exit 0
    ;;
    --video-examples-path=*)
    VIDEO_EXAMPLES_PATH="${i#*=}"
    shift
    ;;
    --intel-models-path=*)
    INTEL_MODELS_PATH="${i#*=}"
    shift
    ;;
    --models-path=*)
    MODELS_PATH="${i#*=}"
    shift
    ;;
    --image-name=*)
    IMAGE_NAME="${i#*=}"
    shift
    ;;
    *)
          # unknown option
    ;;
esac
done

#xhost local:root
sudo docker run -it --privileged --net=host \
    -e HTTP_PROXY=$HTTP_PROXY \
    -e HTTPS_PROXY=$HTTPS_PROXY \
    -e http_proxy=$http_proxy \
    -e https_proxy=$https_proxy \
    \
    -v $INTEL_MODELS_PATH:/home/clion/intel_models \
    -v $MODELS_PATH:/home/clion/models \
    -e MODELS_PATH=/home/clion/intel_models:/home/clion/models \
    \
    -v $VIDEO_EXAMPLES_PATH:/home/clion/video-examples \
    -e VIDEO_EXAMPLES_DIR=/home/clion/video-examples \
    \
    -v $DEMO_PATH:/home/clion/gva/dl-streamer/samples/cpp/demo_analytics \
    -v $OPENVINO_PATH:/home/clion/openvino \
    -w /home/clion/gva/dl-streamer/samples/cpp/demo_analytics \
    \
    --cap-add sys_ptrace \
    $IMAGE_NAME
