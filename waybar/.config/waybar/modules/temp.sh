#!/bin/bash

cputemp=$(sensors -A | grep Tctl | sed -E "s/.*\+(.*)\..*/\1/")
gputemp=$(nvidia-smi | grep -oE "[0-9][0-9]C" | sed -r "s/(.*)C/\1/")

echo -e "$cputemp $gputemp"
