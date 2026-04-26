#!/usr/bin/env bash
# Tailscale hostnames and SSH config for Raspberry Pi benchmarks.

RPI3B_HOST="rpi3b"      # Tailscale hostname or IP — Cortex-A53, in-order
RPI4B_HOST="rpi4b"      # Tailscale hostname or IP — Cortex-A72, light OOO
RPI5_HOST="rpi5"        # Tailscale hostname or IP — Cortex-A76, deep OOO

RPI_USER="shrav"           # SSH username on all Pis 

# Remote directory where binaries are copied and run.
RPI_BENCH_DIR="/tmp/alias_bench"
