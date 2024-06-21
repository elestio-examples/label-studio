#!/usr/bin/env bash

sed -i "s~django.middleware.csrf.CsrfViewMiddleware~# django.middleware.csrf.CsrfViewMiddleware~g" ./label_studio/core/settings/basy.py

docker buildx build . --output type=docker,name=elestio4test/label-studio:latest | docker load

