#!/bin/bash

export HTTP_PROXY="$(wslvar HTTP_PROXY)"
export HTTPS_PROXY=$HTTP_PROXY
export HOME=/home/livebook
export EVISION_PREFER_PRECOMPILED=true
