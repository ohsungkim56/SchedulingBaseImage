#!/bin/bash
./status_report_script.sh up

cron -f

./status_report_script.sh down