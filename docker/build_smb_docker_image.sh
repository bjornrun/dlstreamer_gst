#!/bin/bash
# ==============================================================================
# Copyright (C) 2018-2020 Intel Corporation
#
# SPDX-License-Identifier: MIT
# ==============================================================================

build_type=${1:-opensource}
tag=${2:-latest}

dockerfile=smb.Dockerfile

BASEDIR=$(dirname "$0")
docker build -f ${BASEDIR}/${dockerfile} -t smb-analytics:$tag \
    --build-arg http_proxy=${HTTP_PROXY:-$http_proxy} \
    --build-arg https_proxy=${HTTPS_PROXY:-$https_proxy} \
    ${BASEDIR}/..
