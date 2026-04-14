#!/bin/bash

read -p "Enter a project identifier: " INPUT_NAME

trap 'tar -czf attendance_tracker_${INPUT_NAME}_archive.tar.gz attendance_tracker_${INPUT_NAME}; rm -rf attendance_tracker_${INPUT_NAME}; exit' SIGINT

mkdir attendance_tracker_${INPUT_NAME}
mkdir attendance_tracker_${INPUT_NAME}/Helpers
mkdir attendance_tracker_${INPUT_NAME}/reports
touch attendance_tracker_${INPUT_NAME}/attendance_checker.py
touch attendance_tracker_${INPUT_NAME}/Helpers/assets.csv
touch attendance_tracker_${INPUT_NAME}/Helpers/config.json
touch attendance_tracker_${INPUT_NAME}/reports/reports.log
read -p "Do you want to update attendance thresholds? (yes/no): " UPDATE
if [[ "$UPDATE" == "yes" ]]; then
        read -p "Enter a new warning threshold % (default 75): " WARNING
        read -p "Enter new failure threshold % (default 50): " FAILURE
        WARNING=${WARNING:-75}
        FAILURE=${FAILURE:-50}
        sed -i "s/\"warning_threshold\": [0-9]*/\"warning_threshold\": $WARNING/" attendance_tracker_${INPUT_NAME}/Helpers/config.json
        sed -i "s/\"failure_threshold\": [0-9]*/\"failure_threshold\": $FAILURE/" attendance_tracker_${INPUT_NAME}/Helpers/config.json
        echo "Done! Warning: ${WARNING}%, FAILURE ${FAILURE}%"
else
        echo "Keeping defaults - Warning: 75%, Failure: 50%"
fi
if python3 --version; then
        echo "Python3 is installed"
else
        echo "WARNING: Python3 is not installed"
fi
