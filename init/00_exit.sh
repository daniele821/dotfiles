#!/bin/env bash

echo "Warning: automatic installation may fail, doing these operations manually is recommended"
echo -n "Do you still wish to proceed [y/n]? " 
read -r answer </dev/tty
[[ "${answer,,:0:1}" == "y" ]]

