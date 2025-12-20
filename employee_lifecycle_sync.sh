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

    local timestamp_file=$(date "+%Y%m%d_%H%M%S")
    local pretty_date=$(date "+%Y-%m-%d %H:%M:%S")
    local report_file="$REPORTS_DIR/manager_update_${timestamp_file}.txt"

    LATEST_REPORT="$report_file"

    local added_count=0
    local removed_count=0
    local terminated_count=0

    if [ -f "added_list.txt" ]; then
        added_count=$(wc -l < "added_list.txt")
    fi

    if [ -f "removed_list.txt" ]; then
        removed_count=$(wc -l < "removed_list.txt")
    fi

    if [ -f "terminated_list.txt" ]; then
        terminated_count=$(wc -l < "terminated_list.txt")
    fi

    {
        echo "Manager Employee Update"
        echo "======================="
        echo "Timestamp: $pretty_date"
        echo "Mode: LIVE"
        echo ""
        echo "Summary"
        echo "-------"
        echo "Added employees          : $added_count"
        echo "Removed employees        : $removed_count"
        echo "Offboarded by status     : $terminated_count"
        echo ""
        echo "Details"
        echo "-------"
        echo "Added (username, department):"
        if [ -f "added_list.txt" ] && [ $added_count -gt 0 ]; then
            cat "added_list.txt"
        else
            echo "None"
        fi
        echo ""

        echo "Removed (username, department):"
        if [ -f "removed_list.txt" ] && [ $removed_count -gt 0 ]; then
             cat "removed_list.txt"
        else
            echo "None"
        fi
        echo ""

        echo "Terminated processed (username, department):"
        if [ -f "terminated_list.txt" ] && [ $terminated_count -gt 0 ]; then
             cat "terminated_list.txt"
        else
            echo "None"
        fi

        echo ""
        echo "Artifacts"
        echo "---------"
        echo "Archives folder : $ARCHIVE_DIR"
        echo "Snapshot file   : $SNAPSHOT_FILE"
        echo "Log file        : $LOG_DIR/lifecycle_sync.log"

    } > "$report_file"

    log_message "INFO" "Manager report generated: $report_file"
}

# Send mail
# Command: mail -s "Subject" manager@email.com < report.txt.
send_email_report() {

    # Proje sunumunda "kendi üniversite emailinizi kullanabilirsiniz" deniyor
    # Test için "root" veya kendi emailini yazabilirsin.
    local recipient="oguzhanaydin@stu.khas.edu.tr"
    local subject="Employee Lifecycle Update - $(date +%Y-%m-%d)"

    if [ -n "$LATEST_REPORT" ] && [ -f "$LATEST_REPORT" ]; then

        mail -s "$subject" "$recipient" < "$LATEST_REPORT" 2>/dev/null

        if [ $? -eq 0 ]; then
            log_message "INFO" "Report emailed successfully to $recipient"
        else
            log_message "ERROR" "Failed to send email. Ensure 'mailutils' is installed."
        fi

    else
        log_message "ERROR" "Report file not found (LATEST_REPORT is empty). Email skipped."
    fi
}

# Save the employee.csv file as last_employees.csv. You can use copy.
update_snapshot() {
if [ -f "$CURRENT_FILE" ]; then

        cp "$CURRENT_FILE" "$SNAPSHOT_FILE"

        log_message "INFO" "Snapshot updated: $SNAPSHOT_FILE"
    else
        log_message "ERROR" "Could not update snapshot. Source file $CURRENT_FILE not found."
    fi
}

# Delete all temp files.
clean_temp_files() {
    rm -f sorted_current.txt sorted_last.txt
    rm -f added_list.txt removed_list.txt terminated_list.txt

    log_message "INFO" "Temporary files cleaned up. Cycle finished."
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
