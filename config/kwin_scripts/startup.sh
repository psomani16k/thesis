#!/bin/bash

# start terminal 

alacritty &

# start chrome

google-chrome &

# start slack

flatpak run com.slack.Slack &

# start spotify

flatpak run com.spotify.Client &

# start obsidian

flatpak run md.obsidian.Obsidian &
