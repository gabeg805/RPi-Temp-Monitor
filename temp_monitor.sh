#!/bin/bash

# Log directory and file
LOG_DIR="${HOME}/.log/temp_monitor"
LOG_FILE="${LOG_DIR}/temp.log"

# Timestamp at which temperature was taken
TIMESTAMP=$(/bin/date)

# Temperature of the raspberry pi
TEMP=$(/usr/bin/vcgencmd measure_temp)

mkdir -p "${LOG_DIR}"
#echo "[${TIMESTAMP}] ${TEMP}" | tee -a "${LOG_FILE}"
