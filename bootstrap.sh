#!/usr/bin/env bash

cp .dotter/local.example.toml .dotter/local.toml
mv .dotter/post_deploy.sh .dotter/post_deploy.sh.off
./dotter --force --noconfirm
