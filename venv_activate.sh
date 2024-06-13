# I have all my python venvs in a certain location
venv() {
    if [ "$1" = "list" ]; then
        ls ~/py_venvs
    else
        source ~/py_venvs/$1/bin/activate
    fi
}

