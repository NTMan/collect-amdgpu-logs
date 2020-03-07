#!/bin/bash

(( EUID != 0 )) && exec sudo -- "$0" "$@"

echo w > /proc/sysrq-trigger

UMR_PATH="/home/mikhail/packaging-work/git/umr/build/src/app/"
DATETIME=$(date '+%Y-%m-%d %H-%M-%S')
LOG_PATH="/home/mikhail/radeon/${DATETIME}/"

cd ${UMR_PATH}
mkdir -p "${LOG_PATH}"

# Declare a string array with type
declare -a COMMANDS=(
  "./umr -O halt_waves -wa"
  "./umr -R gfx[.]"
  "./umr -O many,bits -r *.*.mmGRBM_STATUS*"
  "./umr -O many,bits -r *.*.mmCP_EOP_*"
  "./umr -O many,bits -r *.*.mmCP_PFP_HEADER_DUMP"
  "./umr -O many,bits -r *.*.mmCP_ME_HEADER_DUMP"
  "dmesg"
)

declare -a LOGS_NAMES=(
  "halt_waves"
  "gfx"
  "mmGRBM_STATUS"
  "mmCP_EOP"
  "mmCP_PFP_HEADER_DUMP"
  "mmCP_ME_HEADER_DUMP"
  "dmesg"
)

# Read the array values with space
for IDX in "${!COMMANDS[@]}"; do
  echo ${COMMANDS[$IDX]}
  echo ${COMMANDS[$IDX]} > "${LOG_PATH}${LOGS_NAMES[$IDX]}.txt"
  ${COMMANDS[$IDX]} >> "${LOG_PATH}${LOGS_NAMES[$IDX]}.txt" 2>&1
done
