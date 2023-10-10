#!/usr/bin/env bash

cp .dotter/local.example.toml .dotter/local.toml
./dotter --force --noconfirm
