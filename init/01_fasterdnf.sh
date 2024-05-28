#!/bin/env bash

# exit early if dnf is already speed up
ALREADY_PARALLEL="$(grep -c 'max_parallel_downloads=' /etc/dnf/dnf.conf)"
if [[ "${ALREADY_PARALLEL}" -gt 0 ]]; then
	msg="$(grep 'max_parallel_downloads=' /etc/dnf/dnf.conf)"
	echo "dnf was already speed up (${msg})"
	exit 0
fi

echo -en "\nDo you want to modify /etc/dnf/dnf.conf to speed up dnf downloads [y/n]? "
read -r answer </dev/tty
[[ "${answer,,:0:1}" != "y" ]] && exit 0
echo 'max_parallel_downloads=10' | sudo tee -a /etc/dnf/dnf.conf
