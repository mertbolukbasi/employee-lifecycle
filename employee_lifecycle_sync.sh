#!/bin/bash

CURRENT_FILE="employees.csv"
SNAPSHOT_FILE="./output/last_employees.csv"
ARCHIVE_DIR="./output/archives"
LOG_DIR="./output/logs"
REPORTS_DIR="./output/reports"

# Controls directory, if any file does not exist, you should create.
#employee-lifecycle/
#├── output/
#│   ├── archives/
#│   ├── logs/
#│   ├── reports/
#│   └── last_employees.csv
#├── employee_lifecycle_sync.sh
#├── employees.csv
#
# Commands: mkdir -p
setup_environment() {
    mkdir -p "$ARCHIVE_DIR"
    mkdir -p "$LOG_DIR"
    mkdir -p "$REPORTS_DIR"

    if [ ! -f "$LOG_DIR/lifecycle_sync.log" ]; then
        touch "$LOG_DIR/lifecycle_sync.log"
    fi

    log_message "INFO" "Environment setup complete. Directories are ready."
}

# The log file records the operation along with its timestamp.
# YYYY-MM-DD HH:MM:SS | [LEVEL] | Message
# Commands: date, echo >>
log_message() {
    local level=$1
    local message=$2
    local timestamp=$(date "+%Y-%m-%d %H:%M:%S")
    local log_file="$LOG_DIR/lifecycle_sync.log"

    # Format: YYYY-MM-DD HH:MM:SS | [LEVEL] | Message
    local formatted_log="$timestamp | [$level] | $message"

    echo "$formatted_log"
    echo "$formatted_log" >> "$log_file"
}

# Sort employees.csv and last_employees.csv files. 
# Use 2 temp files that name are sorted_current.txt and sorted_last.txt
read_and_normalize_csv() {

}

# Detect changes as added, removed or status check.
# If it detects adding, call add_user otherwise call remove_user function.
# Commands: comm -13 (Only exists on new file), comm =23 (Only exists on old file)
detect_changes() {

}

# If status == active, add user.
# If deparment does not exist, you should add.
# Do not forget logging with log_message function.
# Commands: getent group (control department exists or not), groupadd (add departmant), useradd -m (add user), usermod -aG (add group)
add_user() {
    local employee_id=$1
    local username=$2
    local name_surname=$3
    local departmant=$4
    local status=$5

    #use log_message function at the end.
}

# Find user. (getent passwd)
# Backup the directory. (tar -czf)
# Lock the account. (usermod -L)
# Do not forget logging with log_message function.
remove_user() {
    local username=$1

    #use log_message function at the end.
}

# Generate repot that includes date, statistics.
generate_report() {

}

# Send mail
# Command: mail -s "Subject" manager@email.com < report.txt.
send_email_report() {

}

# Save the employee.csv file as last_employees.csv. You can use copy.
update_snapshot() {

}

# Delete all temp files.
clean_temp_files() {

}

main() {

    # If last_exmployees.csv does not exist, create a new csv file.
    if [ ! -f "$SNAPSHOT_FILE" ]; then
        touch "$SNAPSHOT_FILE"
    fi

    # If employees.csv does not exist, terminate the program because we need current data.
    if [ ! -f "$CURRENT_FILE" ]; then
    echo "$CURRENT_FILE is not found!"
    exit 1
    fi

    read_and_normalize_csv
    detect_changes

    generate_report
    send_email_report
    update_snapshot
    cleanup
}

main
