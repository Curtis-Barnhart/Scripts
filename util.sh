# returns 0 if item is contained in array and 1 otherwise
array_contains() {
    # local variable to hold the array name (reference to passed array)
    local array=$1
    declare -n array

    # dumbest way to check for containment
    for item in ${array[@]}; do
        [ "$2" = "$item" ] && return 0
    done
    return 1;
}

print_table_array() {
    local index array_end
    local array=$1
    declare -n array
    declare -i array_end

    array_end=${#array[@]}
    array_end=$array_end-1

    echo ---BEGIN PRINT ARRAY---
    for index in $(seq 0 $array_end); do
        echo $index: ${array[$index]}
    done
    echo ----END PRINT ARRAY----
}

