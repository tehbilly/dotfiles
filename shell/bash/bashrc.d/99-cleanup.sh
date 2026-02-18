#!/usr/bin/env bash
# Final housekeeping

# Deduplicate PATH entries (-e excludes non-existent paths)
if command -v pdedupe >/dev/null 2>&1; then
    export PATH=$(pdedupe -e)
fi
