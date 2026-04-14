#!/bin/bash

# Ask user for project name and store it
read -p "Enter a project identifier: " INPUT_NAME

# Trap SIGINT (Ctrl+C) - archive and clean up if interrupted
trap 'tar -czf attendance_tracker_${INPUT_NAME}_archive.tar.gz attendance_tracker_${INPUT_NAME}; rm -rf attendance_tracker_${INPUT_NAME}; exit' SIGINT

# Create main project directory
mkdir attendance_tracker_${INPUT_NAME}

# Create subdirectories
mkdir attendance_tracker_${INPUT_NAME}/Helpers
mkdir attendance_tracker_${INPUT_NAME}/reports

# Create required files
touch attendance_tracker_${INPUT_NAME}/attendance_checker.py
touch attendance_tracker_${INPUT_NAME}/Helpers/assets.csv
touch attendance_tracker_${INPUT_NAME}/Helpers/config.json
touch attendance_tracker_${INPUT_NAME}/reports/reports.log

# Ask user if they want to update thresholds
read -p "Do you want to update attendance thresholds? (yes/no): " UPDATE
if [[ "$UPDATE" == "yes" ]]; then
        # Capture new threshold values
        read -p "Enter a new warning threshold % (default 75): " WARNING
        read -p "Enter new failure threshold % (default 50): " FAILURE
        WARNING=${WARNING:-75}
        FAILURE=${FAILURE:-50}
        # Use sed to update config.json in place
        sed -i "s/\"warning_threshold\": [0-9]*/\"warning_threshold\": $WARNING/" attendance_tracker_${INPUT_NAME}/Helpers/config.json
        sed -i "s/\"failure_threshold\": [0-9]*/\"failure_threshold\": $FAILURE/" attendance_tracker_${INPUT_NAME}/Helpers/config.json
        echo "Done! Warning: ${WARNING}%, Failure: ${FAILURE}%"
else
        echo "Keeping defaults - Warning: 75%, Failure: 50%"
fi

# Health check - verify python3 is installed
if python3 --version; then
        echo "Python3 is installed"
else
        echo "WARNING: Python3 is not installed"
fi
