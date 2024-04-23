#!/bin/bash

# Cute little script that pushes and pulls my obsidian git repo from anywhere
# in the filesystem

know_sync () {
    local commit_message
    local previous_location
    previous_location="$(pwd)"

    if [ "$1" = "pull" ]; then
        cd ~/Knowledge
        git pull
    elif [ "$1" = "push" ]; then
        if [ "$2" = "" ]; then
            commit_message="default commit message"
        else
            commit_message="$2"
        fi
        cd ~/Knowledge
        # this next line runs a python script in the directory that makes sure all assets are in dark mode
        ./mode_shift.py dark
        git add .
        git commit -m "$commit_message"
        git push
    elif [ "$1" = "help" ]; then
        echo "know_sync pull"
        echo "  - performs git pull on obsidian repository"
        echo "know_sync push [message]"
        echo "  - adds all and makes commit on obsidian repository, then pushes"
        echo "  - if [message] is not specified, then 'default commit message' is used"
        echo "know_sync help"
        echo "  - displays this help page"
    else
        echo "Usage: know_sync [pull|push|help]"
    fi

    cd "$previous_location"
}

