#!/usr/bin/env bash
set -eux
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
echo "Building docker container"
docker build -t errorhandler .
# Deploy our skill to Cortex
echo "Deplying cortex components"
cortex actions deploy ${SCRIPT_DIR}/action.json
cortex skills save ${SCRIPT_DIR}/skilla.json
cortex skills save ${SCRIPT_DIR}/skillb.json
cortex skills save ${SCRIPT_DIR}/skillc.json
cortex skills save ${SCRIPT_DIR}/errorHandler.json
cortex agents save ${SCRIPT_DIR}/agent.json
