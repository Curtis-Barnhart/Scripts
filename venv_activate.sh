source ~/Scripts/util.sh

# I have all my python venvs in a certain location
# Also I'm pretty sure that if any of the venvs has a space in the name,
# _something_ will break.
venv() {
    # constant pointing to where we want to store venvs.
    # This is what you would modify if you want to store yours somewhere else
    local VENV_PATH=~/py_venvs/
    # array to hold all currently existing venvs
    local existing_envs=($(ls $VENV_PATH))

    case "$1" in
        "create" | "-c")
            array_contains existing_envs $2
            if [ $? = 0 ]; then
                echo "venv $2 already exists - exiting"
                return 1
            else
                python3 -m venv "$VENV_PATH$2"
                echo "virtual environment $VENV_PATH$2 created"
            fi
            ;;
        "activate" | "-a")
            array_contains existing_envs $2
            if [ $? = 0 ]; then
                source "$VENV_PATH$2/bin/activate"
            else
                echo "venv $2 does not exist - exiting"
                return 2
            fi
            ;;
        "list" | "-l")
            echo ${existing_envs[@]}
            ;;
        "remove" | "-r")
            array_contains existing_envs $2
            if [ $? = 0 ]; then
                rm -r "$VENV_PATH$2"
                echo "venv $2 was successfully removed"
            else
                echo "venv $2 does not exist - exiting"
                return 2
            fi
            ;;
        "help" | "-h")
            echo "oops - no help yet"
            ;;
        *)
            echo "oops"
            ;;
    esac
}

_venv_completions() {
    # The first argument will always be "create/-c", "open/-o", "list/-l", "remove/-r", or "help/-h"
    if [[ ${#COMP_WORDS[@]} < 3 ]]; then
        COMPREPLY=($(compgen -W "create activate list remove help" ${COMP_WORDS[1]}))
        return
    fi

    # COMPREPLY is magic variable to hold completions lol
    # COMP_WORDS is a list of already or partially completed words the user has typed
    case "${COMP_WORDS[1]}" in
        "activate" | "-a" | "remove" | "-r")
            COMPREPLY=($(compgen -W "$(ls ~/py_venvs)" ${COMP_WORDS[2]}))
            ;;

        *)
            unset COMPREPLY
            ;;
    esac
}

complete -F _venv_completions venv

