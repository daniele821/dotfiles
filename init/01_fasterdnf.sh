#!/bin/env bash

function dnf_config() {
	CONFIG="${1}"
	PAIR="${1}${2}"
	if [[ "$(grep -c "${CONFIG}" /etc/dnf/dnf.conf)" -gt 0 ]]; then
		echo "dnf setting already exists: '$(grep "${CONFIG}" /etc/dnf/dnf.conf)'"
	else
		echo -en "Do you want to modify dnf configuration to set ${PAIR} [y/n]? "
		read -r answer </dev/tty
		[[ "${answer,,:0:1}" == "y" ]] && echo "${PAIR}" | sudo tee -a /etc/dnf/dnf.conf
	fi
}

dnf_config "max_parallel_downloads=" "10"
dnf_config "fastestmirror=" "True"
