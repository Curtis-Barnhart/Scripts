#!/bin/bash

goto() {
    local label
    local location
    local label_found

    # Make sure the config file is there
    if [ ! -e ~/Scripts/.config/goto ]; then
        echo "config directory not found"
        echo "creating config directory ~/Scripts/.config/goto"
        mkdir -p ~/Scripts/.config/goto
    fi
    if [ ! -e ~/Scripts/.config/goto/labels ]; then
        echo "config file not found"
        echo "creating empty config file ~/Scripts/.config/goto/labels"
        touch ~/Scripts/.config/goto/labels
    fi

    case "$1" in
        "--set"|"-s")
            # Add a new label
            # Check to see if label was already in use
            while read label; do
                read location
                if [ "$label" = "$2" ]; then
                    echo "label '$2' already exists: $location"
                    echo "the old label must be unset before you can set it to a new location"
                    return
                fi
            done < ~/Scripts/.config/goto/labels

            # Set label as cwd
            echo "$2" >> ~/Scripts/.config/goto/labels
            echo "$(pwd)" >> ~/Scripts/.config/goto/labels
            echo "label set"
            ;;
        "--unset"|"-u")
            # Remove an existing label
            label_found=false
            touch ~/Scripts/.config/goto/tempfile

            # Loop over all labels. If target label is found, do not copy it.
            while read label; do
                read location

                if [ "$label" != "$2" ]; then
                    echo "$label" >> ~/Scripts/.config/goto/tempfile
                    echo "$location" >> ~/Scripts/.config/goto/tempfile
                else
                    label_found=true
                fi
            done < ~/Scripts/.config/goto/labels

            if [ label_found ]; then
                echo "label deleted"
            else
                echo "label not found"
            fi
            mv ~/Scripts/.config/goto/tempfile ~/Scripts/.config/goto/labels
            ;;
        "--where"|"-w")
            # Lookup where a label goes to
            label_found=false

            # Loop over all labels. If target label is found, print it
            while read label; do
                read location

                if [ "$label" == "$2" ]; then
                    echo "$location"
                    label_found=true
                fi
            done < ~/Scripts/.config/goto/labels

            if [ ! label_found ]; then
                echo "label not found"
            fi       
            ;;
        "--list"|"-l")
            # List out all the defined labels the user has
            if [ "$2" = "all" ]; then
                cat ~/Scripts/.config/goto/labels
            else
                while read label; do
                    read location
                    echo $label
                done < ~/Scripts/.config/goto/labels
            fi
            ;;
        "--help"|"-h")
            # display some sort of manual or guide
            cat ~/Scripts/.config/goto/helptext
            ;;
        *)
            # Lookup the label user entered - cd to corresponding location
            while read label; do
                read location
                if [ "$label" = "$1" ]; then
                    cd "$location"
                    return
                fi
            done < ~/Scripts/.config/goto/labels

            # If they haven't entered a matching label
            echo "Usage: goto [<label>|--set <label>|--where <label>|--list|--help]"
            ;;
    esac
}

