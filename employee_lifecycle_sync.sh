#!/bin/bash

INPUT_FILE="employees.csv"
SNAPSHOT_FILE="./output/last_employees.csv"
ARCHIVE_DIR="./output/archives"
LOG_DIR="./output/logs"

if [ ! -f "$INPUT_FILE" ]; then
    echo "$INPUT_FILE is not found!"
    exit 1
fi


add_employee() {
    local employee=$1
    local department=$2
    echo " ->Adding: $employee (Dept: $department)"

    if ! getent group "$department" >/dev/null; then
        sudo groupadd "$department"
    fi

    if ! id "$employee" >/dev/null 2>&1; then
        sudo employeeadd -m -s /bin/bash -G "$department" "$employee"
    fi
}

remove_employee() {
    local employee=$1
    echo "Deleting: $employee"
}

changes_employees() {
    local file_path="$1"
    if [ ! -f "$file_path" ]; then
        echo "$file_path is not found!"
        exit 1
    fi

    tail -n +2 "$SNAPSHOT_FILE" | awk -F, '{print $2}' | tr -d ' ' | sort > old.txt
    tail -n +2 "$INPUT_FILE" | awk -F, '{print $2}' | tr -d ' ' | sort > new.txt

    comm -13 old.txt new.txt > add_employees.txt

    while read -r employee; do
        if [ -z "$employee" ]; then
            continue; 
        fi         

        employee_info=$(grep -w "$employee" "$INPUT_FILE")

        department=$(echo "$employee_info" | awk -F, '{print $4}' | tr -d ' ')
        status=$(echo "$employee_info" | awk -F, '{print $5}' | tr -d ' ')

        if [[ "$status" == "active" ]]; then
            add_employee "$employee" "$department"
        fi
    done < add_employees.txt

    comm -23 old.txt new.txt > remove_employees.txt

    while read -r employee; do
        if [ -z "$employee" ]; then 
            continue; 
        fi
        remove_employee "$employee"
    done < remove_employees.txt

    grep "terminated" "$INPUT_FILE" | awk -F, '{print $2}' | tr -d ' ' | while read -r employee; do
        if ! grep -q "$employee" remove_employees.txt; then
            remove_employee "$employee"
        fi
    done      

    rm old.txt new.txt add_employees.txt remove_employees.txt
}

changes_employees $SNAPSHOT_FILE
cp "$INPUT_FILE" "$SNAPSHOT_FILE"
