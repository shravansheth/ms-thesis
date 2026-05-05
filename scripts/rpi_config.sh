#!/usr/bin/env bash
# Local-network hostnames/IPs and SSH config for Raspberry Pi benchmarks.
# If local hostnames like "rpi3b" do not resolve on your network, use each Pi's
# LAN IP address instead, e.g. RPI3B_HOST="192.168.1.23".

RPI3B_HOST="rpi3b"      # local hostname or LAN IP - Cortex-A53, in-order
RPI4B_HOST="rpi4b"      # local hostname or LAN IP - Cortex-A72, light OOO
RPI5_HOST="rpi5"        # local hostname or LAN IP - Cortex-A76, deep OOO

RPI_USER="shrav"           # SSH username on all Pis 

# Remote directory where binaries are copied and run.
RPI_BENCH_DIR="/tmp/alias_bench"
