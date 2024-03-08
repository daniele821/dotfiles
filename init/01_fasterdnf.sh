#!/bin/env bash

cat /etc/dnf/dnf.conf
echo -en "\nDo you want to append the two lines to speed up dnf [y/n]? "
read -r answer
[[ "${answer,,:0:1}" != "y" ]] && exit 0
echo 'max_parallel_downloads=10
fastestmirror=True' | sudo tee -a /etc/dnf/dnf.conf
