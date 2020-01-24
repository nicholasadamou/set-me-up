#!/bin/bash

command -v "lporg" &> /dev/null && [ -f "$HOME/.launchpad.yaml" ] && {
	lporg load "$HOME"/.launchpad.yaml
}
