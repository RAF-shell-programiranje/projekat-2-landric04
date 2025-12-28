#!/bin/bash
set -e

/usr/sbin/sshd
exec java -jar /app/app.jar app.log 100
