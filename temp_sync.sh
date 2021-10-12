#!/bin/bash

# Email address
EMAIL_ADDR="${1}"

# Log directory and file
LOG_DIR="${HOME}/.log/temp_monitor"
LOG_FILE="${LOG_DIR}/temp.log"

# Destination directory
DST_DIR="~/katty/static/temps/$(hostname)"

# SSH config file
SSH_CONFIG="${HOME}/.ssh/config"

# Make sure the log file exists
if [ ! -f "${LOG_FILE}" ]
then
	echo "Log file does not exist." 1>&2
	exit 1
fi

# Make sure the SSH config file exists
if [ ! -f "${SSH_CONFIG}" ]
then
	echo "SSH config file does not exist." 1>&2
	exit 1
fi

# Feeder configuration
FEEDER_CONFIG=$(grep -iw -A 3 "Host feeder" "${SSH_CONFIG}" | sed 's/^[ \t]*//')

# Get the user
FEEDER_USER=$(echo "${FEEDER_CONFIG}" | grep -iw "User" | cut -f 2 -d " ")

# Get the IP address
FEEDER_IP_ADDR=$(echo "${FEEDER_CONFIG}" | grep -iw "Hostname" | cut -f 2 -d " ")

# Get the port
FEEDER_PORT=$(echo "${FEEDER_CONFIG}" | grep -iw "Port" | cut -f 2 -d " ")

# Set feeder user if unable to be found
if [ -z "${FEEDER_USER}" ]
then
	FEEDER_USER="pi"
fi

# Make sure able to find IP address and port in the SSH config
if [ -z "${FEEDER_IP_ADDR}" ]
then
	echo "Unable to find IP address in SSH config." 1>&2
	exit 1
fi

if [ -z "${FEEDER_PORT}" ]
then
	echo "Unable to find port number in SSH config." 1>&2
	exit 1
fi

# Copy the temp.log over
timeout -k 30 30 \
	scp -P "${FEEDER_PORT}" "${LOG_FILE}" \
		"${FEEDER_USER}"@"${FEEDER_IP_ADDR}":"${DST_DIR}"

if [ $? -ne 0 ]
then

	# Email/print that an error occurred
	if [ -z "${EMAIL_ADDR}" ]
	then
		"${HOME}"/projects/bin/email.sh -t "${EMAIL_ADDR}" -s "Temp Monitor Sync Failed"
	else
		echo "Error: Temp monitor sync failed."
		exit 1
	fi

fi
