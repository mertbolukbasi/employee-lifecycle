# Employee Lifecycle

## 📖 Summary

This is an enterprise-grade automation script that bridges HR systems with IT infrastructure by automatically managing
Linux user accounts based on employee data from CSV files.

**Onboarding:** It creates user accounts and department groups for new and active employees.
**Offboarding:** I locks the accounts of employees who have been removed from list or whose status is "terminated" and archives their home directories.
**State Management:** It uses snapshot that is "last_employees.csv", to monitor system status and detect changes.
**Report:**: It generates detailed reports for managers and sends email.

## 📂 Directory Structure

```text
employee-lifecycle/
├── output/
│ ├── archives/
│ ├── logs/
│ ├── reports/
│ └── last_employees.csv
├── employee_lifecycle_sync.sh
├── employees.csv
```

## ⚙️ Prerequisites

**CSV Format:**
`employee_id,username,name_surname,department,status`

**Example (employees.csv):**

```csv
employee_id,username,name_surname,department,status
10001,ayse.aydin,Ayşe Aydın,data,active
10002,mehmet.kaya,Mehmet Kaya,dev,terminated
10003,elif.demir,Elif Demir,hr,active
10004,can.ozkan,Can Özkan,marketing,active
10005,zeynep.sari,Zeynep Sarı,finance,active
10006,burak.yilmaz,Burak Yılmaz,dev,terminated
```

## How to Run

```bash
chmod +x employee_lifecycle_sync.sh
sudo ./employee_lifecycle_sync.sh
```

## 🧪 How to Test Safely

1. Use example csv format (employees.csv). Check output/logs/ to confirm users are created.\
2. Add a new row with active status to employees.csv or remove.
3. Run the script again.
4. Check output/reports/ for the manager update report showing added and removed counts.

## ⚠️ Assumptions and Limitations

1. Username should be unique.
2. Change detection relies on output/last_employees.csv. If this file is deleted, the script treats all records as "new additions" in the next run.
3. Sending email works locally.
