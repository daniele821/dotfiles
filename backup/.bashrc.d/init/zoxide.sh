#!/bin/bash

export _ZO_EXCLUDE_DIRS="$HOME:$HOME/.local*:$HOME/.cache*:/afs*:/bin*:/boot*:/dev*:/etc*:/lib*:/lib64*:/media*:/mnt*:/opt*:/proc*:/run*:/sbin*:/srv*:/sys*:/tmp*:/usr*:/var*:/"

eval "$(zoxide init bash)"
