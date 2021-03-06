#!/bin/bash

# Log directory and file
LOG_DIR="${HOME}/.log/temp_monitor"
LOG_FILE="${LOG_DIR}/temp.log"

# Timestamp at which temperature was taken
TIMESTAMP=$(/bin/date +"%Y-%m-%d %H:%M:%S %Z")

# Temperature of the raspberry pi
TEMP=$(/usr/bin/vcgencmd measure_temp)

# Write to the log
if [ "${1}" == "-l" -o "${1}" == "--log" ]
then
	mkdir -p "${LOG_DIR}"
	echo "[${TIMESTAMP}] ${TEMP}" >> "${LOG_FILE}"

# Print to the terminal
else
	echo "[${TIMESTAMP}] ${TEMP}"
fi
